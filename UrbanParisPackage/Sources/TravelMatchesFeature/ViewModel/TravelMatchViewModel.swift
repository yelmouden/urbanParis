//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import Foundation
import Dependencies
import SharedRepository
import Utils

@Observable
final class TravelMatchViewModel: Equatable {
    
    static func == (lhs: TravelMatchViewModel, rhs: TravelMatchViewModel) -> Bool {
        lhs.travel == rhs.travel
    }

    @ObservationIgnored
    @Dependency(\.cotisationsRepository) var cotisationsRepository

    @ObservationIgnored
    @Dependency(\.matosRepository) var matosRepository

    @ObservationIgnored
    @Dependency(\.travelMatchesRepository) var travelsRepository

    var state: StateView<EmptyResource> = .loading

    var travel: Travel

    let idSeason: Int

    var showError = false
    var showAlertCotisation = false
    var showAlertMatos = false

    var isActive: Bool {
        travel.googleDoc != nil || travel.telegram != nil
    }

    init(travel: Travel, idSeason: Int) {
        self.travel = travel
        self.idSeason = idSeason
    }

    func checkAlreadySubscribe() async {
        guard isActive else {
            return
        }

        do {
            travel.hasSubscribed = try await travelsRepository.checkAlreadySubscribe(travel.id, idSeason)
            state = .idle
        } catch {
            travel.hasSubscribed = false
            state = .idle
        }
    }

    nonisolated func checkIsUpToDateContribution() async {
        do {
            await MainActor.run { [self] in
                state = .loading
            }

            // verification si le paiement du matos est à jour

            let isUpToDateMatosPayment = try await matosRepository.isUpToDate()

            try Task.checkCancellation()
            guard isUpToDateMatosPayment else {
                await MainActor.run { [self] in
                    showAlertMatos = true
                    state = .idle
                }

                return
            }

            let isUpToDateCotisationPayment = try await cotisationsRepository.isUpToDate()

            try Task.checkCancellation()

            if isUpToDateCotisationPayment {
                try await travelsRepository.subscribeToTravel(travel.id, idSeason)

                try Task.checkCancellation()

                await MainActor.run { [self] in
                    travel.hasSubscribed = true
                }
            } else {
                await MainActor.run { [self] in
                    showAlertCotisation = true
                    state = .idle
                }
            }

        } catch {
            if !(error is CancellationError) {
                await MainActor.run { [self] in
                    showError = true
                    state = .idle
                }
            }
        }
    }
}
