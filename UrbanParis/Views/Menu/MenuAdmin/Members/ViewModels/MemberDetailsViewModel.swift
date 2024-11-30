//
//  MemberDetailsViewModel.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 22/11/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
import ProfileManager
import SharedResources
import Supabase
import Observation
import Utils

@MainActor
@Observable
class MemberDetailsViewModel {
    @ObservationIgnored
    @Dependency(\.membersRepository) var repository

    var hasError: Bool = false
    var errorText: String = ""

    var stateLocking: StateView<EmptyResource> = .idle
    var stateAdmin: StateView<EmptyResource> = .idle
    var stateDelete: StateView<EmptyResource> = .idle

    var profile: Profile

    var textButtonBloquerUtilisateur: String {
        if profile.isLocked {
            "Débloquer"
        } else {
            "Bloquer"
        }
    }

    var textButtonAdmin: String {
        if profile.isAdmin {
            "Désactiver le mode admin"
        } else {
            "Activer le mode admin"
        }
    }

    init(profile: Profile) {
        self.profile = profile
    }

    var stateURLImageProfile: StateView<URL?> = .loading

    func retrieveURLProfileImage() async {
        do {
            let photo = await profile.urlDownloadPhoto()
            try Task.checkCancellation()
            stateURLImageProfile = .loaded(photo)
        } catch {
        }
    }

    func lockUnlockProfile() async {
        do {
            stateLocking = .loading

            profile.isLocked.toggle()

            try await repository.udpateMember(profile)

            try Task.checkCancellation()

        } catch {
            profile.isLocked.toggle()

            if error is CancellationError {
                hasError = true
                errorText = SharedResources.commonErrorText
            }
        }

        stateLocking = .idle

    }

    func setUnsetAdmin() async {
        do {
            stateAdmin = .loading

            profile.isAdmin.toggle()

            try await repository.udpateMember(profile)

            try Task.checkCancellation()

        } catch {
            profile.isAdmin.toggle()

            if error is CancellationError {
                hasError = true
                errorText = SharedResources.commonErrorText
            }
        }

        stateAdmin = .idle
    }

    func delete() async {
        do {
            stateDelete = .loading

            try await repository.delete(profile)

            try Task.checkCancellation()

        } catch {

            if error is CancellationError {
                hasError = true
                errorText = SharedResources.commonErrorText
            }
        }

        stateDelete = .idle

    }
}
