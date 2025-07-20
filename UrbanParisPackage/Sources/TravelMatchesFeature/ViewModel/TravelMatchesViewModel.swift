//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import Foundation
import Dependencies
import Logger
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

    var currentIndex = 0

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
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }
    }

    func retrieveTravels() async {
        do {
            if let id = selectedSeason?.id {
                let travels = try await repository.retrieveTravels(id)

                try Task.checkCancellation()

                let currentDate = Date.currentDate

                if let currentDate {
                    let index = travels.firstIndex(where: {
                        guard let date = $0.date,
                              let dateMatch = Date.fromString(date)
                        else { return false }

                        return currentDate <= dateMatch

                    })

                    if let index {
                        self.currentIndex = index
                    } else {
                        self.currentIndex = travels.count - 1
                    }
                }


                let travelsVM: [TravelMatchViewModel] = travels.map {
                    .init(travel: $0, idSeason: id)
                }

                stateTravelsView = .loaded(travelsVM)


            }
        } catch {
            if !(error is CancellationError) {
                showError = true
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }
    }
}
