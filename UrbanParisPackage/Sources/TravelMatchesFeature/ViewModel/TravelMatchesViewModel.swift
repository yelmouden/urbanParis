//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import Foundation
import Dependencies
import Utils

@Observable
@MainActor
final class TravelMatchesViewModel {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository) var repository

    var selectedSeason: Season?
    
    var stateSeasonsView: StateView<[Season]> = .loading

    var stateTravelsView: StateView<[TravelMatchViewModel]> = .loading

    var showError = false

    func retrieveSeasons() async {
        do {
            try await Task.sleep(for: .milliseconds(200))
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

    func retrieveTravels() async {
        do {
            if let id = selectedSeason?.id {
                let travels = try await repository.retrieveTravels(id)

                try Task.checkCancellation()
                
                let travelsVM: [TravelMatchViewModel] = travels.map {
                    .init(travel: $0, idSeason: id)
                }

                stateTravelsView = .loaded(travelsVM)
            }
        } catch {
            if !(error is CancellationError) {
                showError = true
            }
        }
    }
}
