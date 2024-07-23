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
import SwiftUI
import Utils

struct AppView: View {

    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var shouldDisplayResetPassword = false
    @State private var isLogged: Bool? = nil

    @Bindable var appViewModel: AppViewModel

    var body: some View {
        ZStack {
            if isLogged == nil {
                SplashcreenView()
            } else if isLogged == true {
                HomeView()
                    .transition(.asymmetric(insertion: .movingParts.filmExposure, removal: .movingParts.blur))
            } else {
                LoginCoordinator()
                    //.transition(.asymmetric(insertion: .opacity, removal: .movingParts.blur))
            }
        }
        .onChange(of: appViewModel.state, { oldValue, newValue in
            if oldValue == .loading {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                    if newValue == .logout {
                        isLogged = false
                        appViewModel.notifyFinishSplashscreenAnimation()
                    } else {
                        withAnimation(.smooth(duration: 1)) {
                            isLogged = true
                        } completion: {
                            appViewModel.notifyFinishSplashscreenAnimation()
                        }
                    }

                }
            }

            if oldValue == .logout && newValue == .signedIn || oldValue == .signedIn && newValue == .logout {
                withAnimation(.smooth(duration: 1).delay(newValue == .logout ? 1 : 0)) {
                    isLogged = newValue == .signedIn
                }
            }

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
