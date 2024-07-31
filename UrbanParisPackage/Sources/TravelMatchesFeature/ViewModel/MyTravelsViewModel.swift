//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 30/07/2024.
//

import Foundation
import Dependencies
import Observation
import Utils

@Observable
final class MyTravelsViewModel {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository) var repository

    var stateTravels: StateView<[Travel]> = .loading

    var selectedSeason: Season?

    var stateSeasonsView: StateView<[Season]> = .loading

    var showError = false

    func retrieveSeasons() async {
        do {
            let seasons = try await repository.retrieveSeasons()

            try Task.checkCancellation()

            stateSeasonsView = .loaded(seasons)
            self.selectedSeason = seasons.last
        } catch {
            if !(error is CancellationError) {
                showError = true
            }
        }
    }

    func retrieveMyTravels() async {
        do {
            guard let selectedSeason else { return }

            let items = try await repository.retrieveMyTravels(selectedSeason.id)
            
            self.stateTravels = items.isEmpty ? .empty : .loaded(items)
        } catch {
            if !(error is CancellationError) {
                showError = true
                stateTravels = .idle
            }
        }
    }
}
