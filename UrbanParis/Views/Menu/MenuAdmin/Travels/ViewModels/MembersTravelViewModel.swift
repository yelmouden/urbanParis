//
//  MembersTravelViewModel.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
import ProfileManager
import Observation
import TravelMatchesFeature
import Utils

@MainActor
@Observable
final class MembersTravelViewModel {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository)
    var travelMatchesRepository

    var state: StateView<[MemberTravelViewModel]> = .loading
    var showError = false

    private let idTravel: Int
    private let idSeason: Int

    init(idTravel: Int, idSeason: Int) {
        self.idTravel = idTravel
        self.idSeason = idSeason
    }

    func retrieveMembersTravel() async {
        state = .loading
        
        do {

            let registeredMembers = try await travelMatchesRepository.retrieveRegisteredMembers(
                idTravel: idTravel,
                idSeason: idSeason
            )

            state = .loaded(registeredMembers.map { MemberTravelViewModel(registerProfileTravel: $0) })
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
            }
        }
    }

    func addMemberToTravel(profile: Profile) async {
        do {
            state = .loading

            if let idProfile = profile.id {
                let addRegisterProfileTravelRequest = AddRegisterProfileTravelRequest(idTravel: idTravel, idSeason: idSeason, idProfile: idProfile)

                try await travelMatchesRepository.addProfileToTravel(addRegisterProfileTravelRequest)
                await retrieveMembersTravel()
            }
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
            }
        }
    }

}

