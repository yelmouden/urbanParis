//
//  AppViewModel.swift
//  FreeWave
//
//  Created by Yassin El Mouden on 23/04/2024.
//

import AuthenticationManager
import Combine
import Database
import DeepLinkManager
import Dependencies
import Foundation
import Observation
import UserNotifications

enum AppState: Equatable {
    case loading
    case signedIn
    case logout
}

@Observable
@MainActor
class AppViewModel {
    /*@ObservationIgnored
    @Dependency(\.profileManager) var profileManager*/

    @ObservationIgnored
    @Dependency(\.deepLinkManager) var deepLinkManager

    @ObservationIgnored
    @Dependency(\.authenticationManager) var authenticationManager

    var state: AppState = .loading

    private let appStateChangeSubject = PassthroughSubject<AppState, Never>()
    private let deeplinkSubject = PassthroughSubject<DeepLink?, Never>()
    private let splashScreenAnimationSubject = PassthroughSubject<Bool, Never>()

    private var cancellables = Set<AnyCancellable>()

    init() {
        Task {
            await startListeninAuthStateChanges()
        }

        startListenDeepLink()
    }

    func startListenDeepLink() {
        Publishers.CombineLatest3(
            appStateChangeSubject.removeDuplicates(),
            deeplinkSubject,
            splashScreenAnimationSubject.filter { $0 }.prefix(1)
        )
        .sink { appState, deepLink, _ in
            guard appState == .signedIn, let deepLink else { return }

            DeepLinkNotifier.shared.send(deepLinkType: deepLink)
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
                state = .logout
            } else {
                // Get preferred currency and signature
                //try? await profileManager.retrieveSignature()
                state = .signedIn
            }

            appStateChangeSubject.send(state)
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
