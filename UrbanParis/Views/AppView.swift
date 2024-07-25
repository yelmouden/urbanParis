//
//  ContentView.swift
//  FreeWave
//
//  Created by Yassin El Mouden on 12/02/2024.
//

import DeepLinkManager
import DesignSystem
import FlowStacks
import LoginFeature
import Pow
import ProfileFeature
import SwiftUI
import Utils

struct AppView: View {

    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var shouldDisplayResetPassword = false
    @State private var isLogged: Bool? = nil
    @State private var shouldDisplayCreation: Bool = false

    @Bindable var appViewModel: AppViewModel

    var body: some View {
        ZStack {
            if isLogged == nil {
                SplashcreenView() {
                    appViewModel.notifyFinishSplashscreenAnimation()
                }
            } else if isLogged == true {
                HomeView()
                    .transition(.asymmetric(insertion: .movingParts.filmExposure, removal: .movingParts.blur))
            } else {
                LoginCoordinator()
            }
        }
        .onChange(of: appViewModel.state, { oldValue, newValue in
            guard newValue != .missingProfile else {
                return
            }

            if oldValue == .loading {
                if newValue == .logout {
                    isLogged = false
                } else {
                    withAnimation(.default) {
                        isLogged = true
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + (newValue == .logout ? 1 : 0)) {
                    withAnimation(.smooth(duration: 1)) {
                        isLogged = newValue == .signedIn
                    }
                }

            }
            /*if oldValue == .loading {
                withAnimation(.smooth) {
                    if newValue == .createProfile {
                        shouldDisplayCreation = true
                    } else {
                        shouldDisplayCreation = false
                    }
                }
               
            }

            if newValue == .createProfile {
                withAnimation(.smooth) {
                    shouldDisplayCreation = true
                }
            } else if oldValue == .createProfile && newValue == .signedIn ||
                        oldValue == .logout && newValue == .signedIn ||
                        oldValue == .signedIn && newValue == .logout
            {
                shouldDisplayCreation = false

                withAnimation(.smooth(duration: 1).delay(newValue == .logout ? 1 : 0)) {
                    isLogged = newValue == .signedIn
                }
            }*/

            if newValue == .signedIn {
                //delegate.requestAuthorizationForNotifications()
            }
        })
        .onOpenURL(perform: { url in
            appViewModel.handleDeepLink(url: url)
        })
        .onReceive(DeepLinkNotifier.shared.publisher) {
            if $0 is ResetPasswordDeepLink {
                shouldDisplayResetPassword = true
            }
        }
        .sheet(isPresented: .init(get: { appViewModel.state == .missingProfile }, set: { _ in })) {
            ProfileCoordinator()
        }
        /*.sheet(isPresented: $shouldDisplayResetPassword,
               content: {
            LoginCoordinator(
                routes: [.root(
                    LoginScreen.resetPassword(
                        .init(),
                        InterModuleAction<EmptyResource>.init(onClose: {
                            shouldDisplayResetPassword = false
                        })
                    ),
                    embedInNavigationView: true
                )]
            )
        })*/
    }
}