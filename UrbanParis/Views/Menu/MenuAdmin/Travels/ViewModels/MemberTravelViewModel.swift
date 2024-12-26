//
//  MemberTravelViewModel.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import Foundation
import Dependencies
import DependenciesMacros
import TravelMatchesFeature
import Utils

@MainActor
@Observable
final class MemberTravelViewModel: Identifiable, Equatable {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository)
    var travelMatchesRepository

    let fistname: String
    let lastname: String
    var isValidated: Bool

    var stateView: StateView<EmptyResource> = .idle

    private let registerProfileTravel: RegisterProfileTravel

    init(registerProfileTravel: RegisterProfileTravel) {
        self.registerProfileTravel = registerProfileTravel
        self.fistname = registerProfileTravel.profiles.firstname
        self.lastname = registerProfileTravel.profiles.lastname
        self.isValidated = registerProfileTravel.isValidate
    }

    public nonisolated static func == (lhs: MemberTravelViewModel, rhs: MemberTravelViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func handleValidation() async {
        do {
            stateView = .loading

            let request = UpdateValidationRequest(id: registerProfileTravel.id, idTravel: registerProfileTravel.idTravel, isValidate: !isValidated, idSeason: registerProfileTravel.idSeason, idProfile: registerProfileTravel.idProfile)

            try await travelMatchesRepository.validateTravel(request)

            isValidated.toggle()

            stateView = .idle
        } catch {
            print("error ", error)
            stateView = .idle
        }

    }
}
