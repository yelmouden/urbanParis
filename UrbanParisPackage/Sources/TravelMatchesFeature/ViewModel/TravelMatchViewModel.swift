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
final class TravelMatchViewModel {

    @ObservationIgnored
    @Dependency(\.cotisationsRepository) var repository

    var state: StateView<Bool> = .idle

    var travel: Travel

    init(travel: Travel) {
        self.travel = travel
    }

    nonisolated func checkIsUpToDateContribution() async {
        do {
            await MainActor.run { [self] in
                state = .loading
            }

            guard let date = travel.date else { return }

            let calendar = Calendar.current
            let components = calendar.dateComponents([.month], from: date)
            let month = components.month

            let cotisations = try await repository.retrieveCotisations()
            
            let isUpToDate = cotisations.first?.amount == 0

            await MainActor.run { [self] in
                state = .loaded(isUpToDate)
            }

            print("cotisaion ", cotisations.map(\.month))

            if !isUpToDate {
                await MainActor.run { [self] in
                    state = .idle
                }
            }


        } catch {
            print("Error ", error)
        }
    }
}
