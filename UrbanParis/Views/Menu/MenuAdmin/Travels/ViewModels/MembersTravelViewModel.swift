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

    private let idTravel: Int
    private let idSeason: Int

    init(idTravel: Int, idSeason: Int) {
        self.idTravel = idTravel
        self.idSeason = idSeason
    }

    func retrieveMembersTravel() async {
        do {
            let registeredMembers = try await travelMatchesRepository.retrieveRegisteredMembers(
                idTravel: idTravel,
                idSeason: idSeason
            )

            state = .loaded(registeredMembers.map { MemberTravelViewModel(registerProfileTravel: $0) })
        } catch {
            print("error ", error)
        }
    }

    func addMemberToTravel(profile: Profile) async {
        do {
            if let idProfile = profile.id {
                let addRegisterProfileTravelRequest = AddRegisterProfileTravelRequest(idTravel: idTravel, idSeason: idSeason, idProfile: idProfile)

                try await travelMatchesRepository.addProfileToTravel(addRegisterProfileTravelRequest)
                await retrieveMembersTravel()
            }
        } catch {

        }
    }

}

