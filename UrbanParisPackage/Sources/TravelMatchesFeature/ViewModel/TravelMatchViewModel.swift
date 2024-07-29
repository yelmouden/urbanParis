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
    @Dependency(\.cotisationsRepository) var repository

    var state: StateView<Bool> = .idle

    var travel: Travel

    var showError = false

    init(travel: Travel) {
        self.travel = travel
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

            let cotisations = try await repository.retrieveCotisations()

            try Task.checkCancellation()

            let isUpToDate = cotisations.first?.amount == 0

            await MainActor.run { [self] in
                state = .loaded(isUpToDate)
            }


            if !isUpToDate {
                await MainActor.run { [self] in
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
