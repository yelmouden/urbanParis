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
    var showError = false

    func retrieveTeams() async {
        do {
            state = .loading

            let teamViewModels = try await travelMatchesRepository.retrieveTeams()
                .map { TeamCellViewModel(team: $0) }
            state = .loaded(teamViewModels)
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
            }
        }
    }

    func addTeam(name: String) async {
        do {
            let previousTeams: [TeamCellViewModel]
            
            switch state {
                case .loaded(let teamViewModels):
                previousTeams = teamViewModels
            default:
                return
            }

            state = .loading

            let team =  try await travelMatchesRepository.addTeam(addTeamRequest: AddTeamRequest(name: name))

            state = .loaded(previousTeams + [TeamCellViewModel(team: team)])

        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
            }
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
