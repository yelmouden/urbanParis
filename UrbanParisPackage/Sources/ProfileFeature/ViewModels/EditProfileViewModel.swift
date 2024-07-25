//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 24/07/2024.
//

import Combine
import Foundation
import Dependencies
import ProfileManager
import SharedResources
import Supabase
import Observation
import Utils

@Observable
@MainActor
public class EditProfileViewModel {

    @ObservationIgnored
    @Dependency(\.profileManager) var profileManager

    var profile: Profile!

    var cancellables = Set<AnyCancellable>()

    var state: StateView<EmptyResource> = .idle
    var showError: Bool = false
    var errorText: String = ""

    var isCreation: Bool = false

    init() {
        ProfileUpdateNotifier.shared.publisher
            .prefix(1)
            .sink { [weak self] profile in
                self?._isCreation = profile == nil
                self?._profile = profile ?? Profile()
            }
            .store(in: &cancellables)
    }

    var isFieldsAllValid: Bool {
        return !profile.firstname.isEmpty &&
        !profile.lastname.isEmpty &&
        !profile.nickname.isEmpty &&
        profile.typeAbo != nil
    }

    func saveProfile() async -> Bool {
        do {
            state = .loading

            if isCreation {
                try await profileManager.createProfile(profile)
            } else {
                try await profileManager.updateProfile(profile)
            }

            try Task.checkCancellation()

            state = .loaded(.emptyResource)

            try await Task.sleep(for: .seconds(1))

            try Task.checkCancellation()

            state = .idle

            return true

        } catch {
            if !(error is CancellationError) {

                state = .idle
                showError = true

                if let postgrestError = error as? PostgrestError, postgrestError.code == "23505" {
                    errorText = "Surnom déjà utilisé"
                } else {
                    errorText = SharedResources.commonErrorText
                }

                print("error ", error)
            }

            return false
        }
    }

}
