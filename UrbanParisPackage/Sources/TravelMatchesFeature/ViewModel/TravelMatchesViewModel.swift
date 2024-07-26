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

    var seasons: [Season] = []

    var selectedSeason: Season?
    
    var travelsVM: [TravelMatchViewModel] = []

    func retrieveSeasons() async {
        do {
            self.seasons = try await repository.retrieveSeasons()
            self.selectedSeason = seasons.last
        } catch {
            print("Error ", error)
        }
    }

    func retrieveTravels() async {
        do {
            if let id = selectedSeason?.id {
                let travels = try await repository.retrieveTravels(id)
                self.travelsVM = travels.map {
                    .init(travel: $0)
                }
            }
        } catch {
            print("Error ", error)
        }
    }
}
