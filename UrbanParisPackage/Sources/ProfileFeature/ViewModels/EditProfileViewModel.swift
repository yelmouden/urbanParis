//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 24/07/2024.
//

import Combine
import Foundation
import Dependencies
import Logger
import ProfileManager
import SharedModels
import SharedRepository
import SharedResources
import Supabase
import Observation
import UIKit
import Utils

@Observable
@MainActor
public class EditProfileViewModel {

    @ObservationIgnored
    @Dependency(\.profileRepository)
    var profileRepository

    var stateURLImageProfile: StateView<URL?> = .idle

    var cancellables = Set<AnyCancellable>()

    var state: StateView<EmptyResource> = .idle
    var showError: Bool = false
    var errorText: String = ""

    var isCreation: Bool = false

    var selectedImage: UIImage?

    var firstname: String = ""
    var lastname: String = ""
    var nickname: String = ""
    var year: Int = Date.currentYear
    var typeAbo: AboType?
    var status: String = ""

    let aboTypes = [AboType.aboPSG, .aboCUP, .none ]

    private var profile: Profile?

    init() {
        ProfileUpdateNotifier.shared.publisher
            .prefix(1)
            .sink { [weak self] profile in
                self?._isCreation = profile == nil
                self?._stateURLImageProfile = profile == nil ? .loaded(nil) : .loading

                self?.profile = profile

                if let profile {
                    self?.firstname = profile.firstname
                    self?.lastname = profile.lastname
                    self?.nickname = profile.nickname
                    self?.year = profile.year
                    self?.typeAbo = profile.typeAbo
                    self?.status = profile.status?.title ?? "Non défini"
                }
            }
            .store(in: &cancellables)

    }
    

    var isFieldsAllValid: Bool {
        return !firstname.isEmpty &&
        !lastname.isEmpty &&
        !nickname.isEmpty &&
        typeAbo != nil &&
        ((isCreation && selectedImage != nil) || !isCreation)
    }

    func retrieveURLProfileImage() async {
        stateURLImageProfile = .loaded(await profile?.urlDownloadPhoto())
    }

    func saveProfile() async -> Bool {
        do {
            state = .loading

            let data = selectedImage?.pngData()

            if isCreation {
                let createProfileRequest = CreateProfileRequest(
                    firstname: firstname,
                    lastname: lastname,
                    nickname: nickname,
                    year: year,
                    typeAbo: typeAbo ?? .none
                )

                let profile = try await profileRepository.createMyProfile(createProfileRequest, data)

                ProfileUpdateNotifier.shared.send(profile: profile)
            } else {
                var updateProfileRequest = UpdateProfileRequest()

                if firstname != profile?.firstname {
                    updateProfileRequest.firstname = firstname
                }

                if lastname != profile?.lastname {
                    updateProfileRequest.lastname = lastname
                }

                if nickname != profile?.nickname {
                    updateProfileRequest.nickname = nickname
                }

                if year != profile?.year {
                    updateProfileRequest.year = year
                }

                if typeAbo != profile?.typeAbo {
                    updateProfileRequest.typeAbo = typeAbo
                }

                guard let id = profile?.id else {
                    throw NSError(
                        domain: "User Id not found for updating profile",
                        code: 0,
                        userInfo: nil
                    )
                }

                let profile = try await profileRepository.updateProfile(
                    id,
                    updateProfileRequest,
                    selectedImage?.pngData()
                )

                if let profile {
                    self.profile = profile
                    ProfileUpdateNotifier.shared.send(profile: profile)
                }
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

                if let postgrestError = error as? PostgrestError, postgrestError.code == "23505", !postgrestError.message.contains("matos_users_pkey") {
                    errorText = "Surnom déjà utilisé"
                } else {
                    errorText = SharedResources.commonErrorText
                }

                AppLogger.error(error.decodedOrLocalizedDescription)
            }

            return false
        }
    }

}
