//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 30/07/2024.
//

import Combine
import Foundation
import Dependencies
import Logger
import ProfileManager
import Observation
import Utils

@MainActor
@Observable
final class MyTravelsViewModel {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository) var repository

    var stateTravels: StateView<[Travel]> = .loading

    var selectedSeason: Season?

    var stateSeasonsView: StateView<[Season]> = .loading

    var showError = false

    var cancellables = Set<AnyCancellable>()

    var idProfile: Int?

    init() {
        ProfileUpdateNotifier.shared.publisher
            .prefix(1)
            .sink { [weak self] profile in
                self?.idProfile = profile?.id
            }
            .store(in: &cancellables)

    }

    func retrieveSeasons() async {
        do {
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

    func retrieveMyTravels() async {
        do {
            guard let selectedSeason, let idProfile else { return }

            let items = try await repository.retrieveMyTravels(selectedSeason.id, idProfile)

            self.stateTravels = items.isEmpty ? .empty : .loaded(items)

        } catch {
            if !(error is CancellationError) {
                showError = true
                stateTravels = .idle
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }
    }
}
