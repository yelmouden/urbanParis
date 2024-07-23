//
//  File.swift
//
//
//  Created by Yassin El Mouden on 11/04/2024.
//

import AuthenticationManager
import Foundation
import Dependencies
import SharedResources
import Supabase
//import TrackingManager
import Utils

@Observable
public final class SignInViewModel {
    @ObservationIgnored
    @Dependency(AuthenticationManager.self) var manager

    /*@ObservationIgnored
    @Dependency(\.trackingManager) var tracking*/

    var state: StateView<Bool> = .idle
    var signWithAppleState: StateView<EmptyResource> = .idle
    var signWithGoogleState: StateView<EmptyResource> = .idle
    var showError = false
    var errorText: String = ""

    @MainActor
    func signIn(email: String, password: String) async {
        do {
            state = .loading
            try await manager.signIn(email: email, password: password)
            //tracking.trackEvent(event: .signIn, parameters: [.method: "email"])
        } catch {
            if let authError = error as? AuthError {
                showError = true
                state = .idle

                switch authError {
                case .api(let error) where error.error == "invalid_grant":
                    errorText = "email ou mot de passe incorrect"
                default:
                    errorText = SharedResources.commonErrorText
                }
            } else if !(error is CancellationError) {
                showError = true
                state = .idle

                errorText = SharedResources.commonErrorText
            }
        }
    }
}
