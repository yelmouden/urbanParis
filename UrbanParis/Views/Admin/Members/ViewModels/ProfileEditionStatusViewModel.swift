//
//  ProfileEditionStatusViewModel.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 17/07/2025.
//

import Dependencies
import Foundation
import Logger
import ProfileManager
import SharedModels
import SharedRepository
import Utils

@MainActor
@Observable
final class ProfileEditionStatusViewModel {

    @ObservationIgnored
    @Dependency(\.profileRepository)
    var profileRepository

    var state: StateView<[EmptyResource]> = .idle

    var showError = false

    private var selectedStatus: Status?

    private(set) var viewDatas: [ProfileEditionStatusViewData]

    private let profile: Profile
    private let didUpdateStatus: (Status) -> Void

    init(
        profile: Profile,
        didUpdateStatus: @escaping (Status) -> Void
    ) {
        self.profile = profile
        self.didUpdateStatus = didUpdateStatus

        selectedStatus = profile.status

        viewDatas = Status.allCases.map {
            .init(
                title: $0.title,
                isSelected: profile.status == $0
            )
        }
    }

    func didSelect(index: Int) {
        selectedStatus = Status.allCases[index]

        if let index = viewDatas.firstIndex { $0.isSelected } {
            viewDatas[index].isSelected = false
        }

        viewDatas[index].isSelected.toggle()
    }

    func save(onSuccess: @escaping (() -> Void)) {
        let profileId = profile.id
        let profileRepository = self.profileRepository

        Task { [weak self] in
            do {
                self?.state = .loading

                var updateProfileRequest = UpdateProfileRequest()
                updateProfileRequest.status = self?.selectedStatus

                let profile = try await profileRepository.updateProfile(
                    profileId,
                    updateProfileRequest,
                    nil
                )

                guard let status = profile?.status else {
                    throw NSError(domain: "Status not defined when updating user", code: 1)
                }
                
                self?.didUpdateStatus(status)

                onSuccess()

                ProfileUpdateNotifier.shared.send(profile: profile)

            } catch {
                self?.showError = true

                self?.state = .idle
                
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }
    }
}
