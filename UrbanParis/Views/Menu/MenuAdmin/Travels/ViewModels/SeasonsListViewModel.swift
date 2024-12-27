//
//  TravelsListViewModels.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
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

    func retrieveSeasons() async {
        do {
            let seasons = try await travelMatchesRepository.retrieveSeasons()

            try Task.checkCancellation()

            state = .loaded(seasons)
        } catch {
            print("error ", error)
        }
    }

    func addSeason(_ season: String) async {
        do {
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
            print("error ", error)
        }

    }

}
