//
//  File.swift
//
//
//  Created by Yassin El Mouden on 11/04/2024.
//

import AuthenticationManager
import Foundation
import Dependencies
import Logger
import SharedResources
import Supabase
import Utils

@Observable
public final class SignUpViewModel {
    @ObservationIgnored
    @Dependency(AuthenticationManager.self) var manager

    /*@ObservationIgnored
    @Dependency(\.trackingManager) var tracking*/

    var signUpState: StateView<Bool> = .idle

    var showError: Bool = false
    var errorText: String = ""
   

    private var task: Task<Void, Never>?

    func signUp(email: String, password: String) async {
        do {
            signUpState = .loading
            try await manager.createUser(email: email, password: password)
        } catch {
            if let authError = error as? AuthError {
                showError = true
                signUpState = .idle

                switch authError {
                case .api(let error) where error.code == 422:
                    errorText = "email déjà utilisé"
                default:
                    errorText = SharedResources.commonErrorText
                }

                AppLogger.error(authError.decodedOrLocalizedDescription)

            } else if !(error is CancellationError) {
                showError = true
                signUpState = .idle

                errorText = SharedResources.commonErrorText

                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }
    }

    
}
