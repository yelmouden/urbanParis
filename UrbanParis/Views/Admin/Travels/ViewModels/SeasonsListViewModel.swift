//
//  TravelsListViewModels.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
import Logger
import Observation
import TravelMatchesFeature
import Utils

@MainActor
@Observable
final class SeasonsListViewModel {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository)
    var travelMatchesRepository

    var state: StateView<[Season]> = .loading

    var showError = false

    func retrieveSeasons() async {
        do {

            state = .loading

            let seasons = try await travelMatchesRepository.retrieveSeasons()

            try Task.checkCancellation()

            state = .loaded(seasons)
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }
    }

    func addSeason(_ season: String) async {
        do {
            state = .loading

            switch state {
            case .loaded(let seasons):
                if seasons.map(\.title).contains(season) {
                    return
                }
            default:
                break
            }


            let addSeasonRequest = AddSeasonRequest(title: season)
            try await travelMatchesRepository.addSeason(addSeasonRequest)

            try Task.checkCancellation()

            await retrieveSeasons()
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }

    }

}
