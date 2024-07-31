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
    @Dependency(\.travelMatchesRepository) var travelsRepository

    var state: StateView<EmptyResource> = .loading

    var travel: Travel

    let idSeason: Int

    var showError = false
    var showAlertCotisation = false

    init(travel: Travel, idSeason: Int) {
        self.travel = travel
        self.idSeason = idSeason
    }

    func checkAlreadySubscribe() async {
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

            guard let date = travel.date else { return }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"

            guard let date = dateFormatter.date(from: date) else { return }

            let calendar = Calendar.current
            let components = calendar.dateComponents([.month], from: date)
            let month = components.month

            let cotisations = try await cotisationsRepository.retrieveCotisations()

            try Task.checkCancellation()

            let isUpToDate = cotisations.first?.amount == 0

            if isUpToDate {
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
