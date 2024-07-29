//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 02/07/2024.
//

import AuthenticationManager
import Dependencies
import Foundation
import Observation
import SharedResources
import Supabase
import Utils

@Observable
@MainActor
public final class ResetPasswordViewModel {
    @ObservationIgnored
    @Dependency(AuthenticationManager.self) var manager

    var state: StateView<Bool> = .idle
    var showError: Bool = false
    var errorText: String = ""

    public init() {}

    @MainActor
    func resetPassword(password: String) async -> Bool {
        do {
            state = .loading

            try await manager.resetPassword(password)
            try Task.checkCancellation()

            state = .loaded(true)
            try await Task.sleep(for: .seconds(1))
            try Task.checkCancellation()

            return true
        } catch {
            if !(error is CancellationError) {

                if let authError = error as? Auth.AuthError,
                   case let .api(apiError) = authError, apiError.code == 422 {
                    errorText = "Mot de passe pas différent de l'ancien."
                } else {
                    errorText = SharedResources.commonErrorText
                }

                state = .idle
                showError = true
            }

            return false
        }
    }
}
