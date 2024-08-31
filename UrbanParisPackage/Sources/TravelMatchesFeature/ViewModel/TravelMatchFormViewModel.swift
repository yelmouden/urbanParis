//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 10/08/2024.
//

import Combine
import Database
import DesignSystem
import Dependencies
import Foundation
import ProfileManager
import SharedResources
import Supabase
import Utils

enum TravelMatchCarResponse: String, SelectableItem {
    var title: String { rawValue }

    var description: String? { nil}

    case Yes = "Oui"
    case No = "Non"
 }

@Observable
@MainActor
final class TravelMatchFormViewModel {

    @ObservationIgnored
    @Dependency(\.travelMatchesRepository) var repository

    var cancellables = Set<AnyCancellable>()

    var state: StateView<EmptyResource> = .idle

    let travel: Travel
    let idSeason: Int

    let user: User?

    var profile: Profile!

    var showError = false
    var errorText = ""

    var carResponse: TravelMatchCarResponse?

    init(travel: Travel, idSeason: Int) {
        self.travel = travel
        self.idSeason = idSeason

        self.user = Database.shared.client.auth.currentUser

        ProfileUpdateNotifier.shared.publisher
            .prefix(1)
            .sink { [weak self] profile in
                self?._profile = profile
            }
            .store(in: &cancellables)
    }

    func register() async -> Bool {
        do {
            state = .loading

            try await repository.subscribeToTravel(travel.id, idSeason)

            try Task.checkCancellation()

            state = .loaded(.emptyResource)

            return true

        } catch {
            if !(error is CancellationError) {
                state = .idle

                showError = true

                errorText = "Impossible de sauvegarder l'inscription"

                return false
            }
        }
        
        return true
    }
}
