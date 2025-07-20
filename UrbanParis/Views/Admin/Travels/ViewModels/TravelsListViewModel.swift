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
final class TravelsListViewModel {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository)
    var travelMatchesRepository

    var state: StateView<[Travel]> = .loading

    var showError = false

    let idSeason: Int

    init(idSeason: Int) {
        self.idSeason = idSeason
    }

    func retrieveTravels() async {
        do {
            state = .loading
            let travels = try await travelMatchesRepository.retrieveTravels(idSeason: idSeason)
            state = .loaded(travels)
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }
    }

    func deleteSeason() async -> Bool {
        do {
            try await travelMatchesRepository.deleteSeason(idSeason: idSeason)
            return true
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
            return false
        }
    }

}
