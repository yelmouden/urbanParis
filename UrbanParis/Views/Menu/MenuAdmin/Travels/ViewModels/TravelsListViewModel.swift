//
//  TravelsListViewModels.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
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

    let idSeason: Int

    init(idSeason: Int) {
        self.idSeason = idSeason
    }

    func retrieveTravels() async {
        do {
            let travels = try await travelMatchesRepository.retrieveTravels(idSeason: idSeason)
            state = .loaded(travels)
        } catch {
            print("error ", error)
        }
    }

}
