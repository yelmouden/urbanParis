//
//  MemberDetailsViewModel.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 22/11/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
import Logger
import ProfileManager
import SharedModels
import SharedRepository
import SharedResources
import Supabase
import Observation
import Utils

@MainActor
@Observable
class MemberDetailsViewModel {
    @ObservationIgnored
    @Dependency(\.profileRepository) var repository

    var hasError: Bool = false
    var errorText: String = ""

    var stateLocking: StateView<EmptyResource> = .idle
    var stateAdmin: StateView<EmptyResource> = .idle
    var stateDelete: StateView<EmptyResource> = .idle

    private let id: Int
    let firstname: String
    let lastname: String
    let nickname: String
    let year: Int
    let typeAbo: String

    var status: String
    var isLocked: Bool
    var isAdmin: Bool

    let profile: Profile

    var textButtonBloquerUtilisateur: String {
        if isLocked {
            "Débloquer"
        } else {
            "Bloquer"
        }
    }

    var textButtonAdmin: String {
        if isAdmin {
            "Désactiver le mode admin"
        } else {
            "Activer le mode admin"
        }
    }

    init(profile: Profile) {
        self.profile = profile
        
        self.id = profile.id
        self.isLocked = profile.isLocked
        self.isAdmin = profile.isAdmin
        self.firstname = profile.firstname
        self.lastname = profile.lastname
        self.nickname = profile.nickname
        self.year = profile.year
        self.typeAbo = profile.typeAbo.title
        self.status = profile.status?.title ?? "Non défini"
    }

    var stateURLImageProfile: StateView<URL?> = .loading

    func retrieveURLProfileImage() async {
        do {
            let photo = await profile.urlDownloadPhoto()
            try Task.checkCancellation()
            stateURLImageProfile = .loaded(photo)
        } catch {
            AppLogger.error(error.decodedOrLocalizedDescription)
        }
    }

    func lockUnlockProfile() async {
        do {
            stateLocking = .loading

            isLocked.toggle()

            var updateProfileRequest = UpdateProfileRequest()
            updateProfileRequest.isLocked = isLocked

            try await repository.updateProfile(
                id,
                updateProfileRequest,
                nil
            )

            try Task.checkCancellation()

        } catch {
            isLocked.toggle()

            if error is CancellationError {
                hasError = true
                errorText = SharedResources.commonErrorText
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }

        stateLocking = .idle

    }

    func setUnsetAdmin() async {
        do {
            stateAdmin = .loading

            isAdmin.toggle()

            var updateProfileRequest = UpdateProfileRequest()
            updateProfileRequest.isAdmin = isAdmin

            try await repository.updateProfile(
                id,
                updateProfileRequest,
                nil
            )

            try Task.checkCancellation()

        } catch {
            isAdmin.toggle()

            if error is CancellationError {
                hasError = true
                errorText = SharedResources.commonErrorText
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }

        stateAdmin = .idle
    }

    func delete() async {
        do {
            stateDelete = .loading

            try await repository.deleteProfile(id)

            try Task.checkCancellation()

        } catch {
            if !(error is CancellationError) {
                hasError = true
                errorText = SharedResources.commonErrorText
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }

        stateDelete = .idle
    }

    func updateStatus(_ status: Status) {
        self.status = status.title
    }
}
