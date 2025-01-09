//
//  AppViewModel.swift
//  FreeWave
//
//  Created by Yassin El Mouden on 23/04/2024.
//

import Combine
import Database
import DeepLinkManager
import Dependencies
import Foundation
import ProfileManager
import Observation
import UserNotifications

enum AppState: Equatable {
    case loading
    case signedIn
    case missingProfile
    case logout
    case userLocked
}

enum SessionState: Equatable {
    case signedIn
    case logout
}

@Observable
@MainActor
class AppViewModel {
    @ObservationIgnored
    @Dependency(\.profileManager) var profileManager

    @ObservationIgnored
    @Dependency(\.deepLinkManager) var deepLinkManager

    @ObservationIgnored
    @Dependency(\.authenticationManager) var authenticationManager

    var state: AppState = .loading

    private let sessionStateChangeSubject = PassthroughSubject<SessionState, Never>()
    private let deeplinkSubject = PassthroughSubject<DeepLink?, Never>()
    private let splashScreenAnimationSubject = PassthroughSubject<Bool, Never>()

    private var cancellables = Set<AnyCancellable>()

    init() {
        startListenDeepLink()

        Task {
            await startListeninAuthStateChanges()
        }

    }

    func startListenDeepLink() {
        Publishers.CombineLatest4(
            sessionStateChangeSubject.removeDuplicates(),
            deeplinkSubject.prepend(nil),
            splashScreenAnimationSubject.filter { $0 }.prefix(1),
            ProfileUpdateNotifier.shared.publisher
                .removeDuplicates(by: { (previous: Profile?, new: Profile?) in
                    previous?.id == new?.id
                })
        )
        .sink { appState, deepLink, _, profile in
            guard appState == .signedIn else {
                self.state = .logout
                return
            }

            guard let profile else {
                self.state = .missingProfile
                return
            }

            guard !profile.isLocked else {
                self.state = .userLocked
                return
            }

            self.state = .signedIn

            guard appState == .signedIn, let deepLink else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                DeepLinkNotifier.shared.send(deepLinkType: deepLink)
            }
        }
        .store(in: &cancellables)
    }

    func notifyFinishSplashscreenAnimation() {
        splashScreenAnimationSubject.send(true)
    }

    func startListeninAuthStateChanges() async {
        for await (event, session) in Database.shared.client.auth.authStateChanges {
            if (event == .initialSession && session == nil) || event == .signedOut {
                deeplinkSubject.send(nil)
                sessionStateChangeSubject.send(.logout)
                ProfileUpdateNotifier.shared.send(profile: nil)
            } else {
                // Get preferred currency and signature
                do {
                    try await profileManager.retrieveProfile(event)
                    sessionStateChangeSubject.send(.signedIn)
                } catch {
                    try? await Database.shared.client.auth.signOut()
                }

            }

        }
    }

    func handleDeepLink(url: URL) {
        let deepLink = deepLinkManager.handleDeepLink(url: url)

        guard let deepLink else { return }

        if let resetPasswordDeepLink = deepLink as? ResetPasswordDeepLink {
            Task {
                do {
                    try await authenticationManager.retrieveSession(code: resetPasswordDeepLink.code)
                    deeplinkSubject.send(resetPasswordDeepLink)
                } catch {
#if DEBUG
                    print("error ", error)
#endif
                }
            }

        } else {
            deeplinkSubject.send(deepLink)
        }
    }
}
