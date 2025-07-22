//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 25/04/2024.
//

import AuthenticationManager
import Dependencies
import Foundation
import Logger
import SharedResources
import Utils

@Observable
final class SettingsViewModel {

    @ObservationIgnored
    @Dependency(AuthenticationManager.self) var manager

    var state: StateView<Bool> = .idle

    var hasError: Bool = false
    var errorText: String = ""

    @MainActor
    func signOut() async -> Bool {
        do {
            try await manager.signOut()
            return true
        } catch {
            if !(error is CancellationError) {
                hasError = true
                errorText = SharedResources.commonErrorText

                AppLogger.error(error.localizedDescription)
            }

            return false
        }
    }
}
