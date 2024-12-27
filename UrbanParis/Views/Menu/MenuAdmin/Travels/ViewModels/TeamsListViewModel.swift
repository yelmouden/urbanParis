//
//  TeamsListViewModel.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 27/12/2024.
//

import Foundation
import Dependencies
import DependenciesMacros
import TravelMatchesFeature
import Utils

@MainActor
@Observable
final class TeamsListViewModel {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository)
    var travelMatchesRepository

    var state: StateView<[TeamCellViewModel]> = .loading

    func retrieveTeams() async {
        do {
            let teamViewModels = try await travelMatchesRepository.retrieveTeams()
                .map { TeamCellViewModel(team: $0) }
            state = .loaded(teamViewModels)
        } catch {
            print("error ", error)
        }
    }

    func addTeam(name: String) async {
        do {
            let team =  try await travelMatchesRepository.addTeam(addTeamRequest: AddTeamRequest(name: name))

            switch state {
                case .loaded(let teamViewModels):
                state = .loaded(teamViewModels + [TeamCellViewModel(team: team)])
            default:
                break
            }

        } catch {
            print("error ", error)
        }
    }

    func removeTeam(teamId: Int) {
        switch state {
            case .loaded(var teamViewModels):
            if let index =  teamViewModels.firstIndex(where: { viewModel in
                viewModel.id == teamId
            }) {
                teamViewModels.remove(at: index)
                state = .loaded(teamViewModels)
           }
        default:
            break
        }
    }
}
