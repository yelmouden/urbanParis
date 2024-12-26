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
            state = .loaded(seasons)
        } catch {

        }
    }

}
