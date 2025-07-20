//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import Combine
import Foundation
import Dependencies
import Logger
import ProfileManager
import SharedRepository
import Utils

private enum TravelMatchViewModelError: Error {
    case missingDate
}

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

    var canAccessListing = false

    var onSubscribeSucceeded: (() -> Void) = {}

    var idProfile: Int?
    var cancellables = Set<AnyCancellable>()


    var isPast: Bool {
        let currentDate = Date.currentDate

        guard let currentDate, let dateString = travel.date, let dateMatch = Date.fromString(dateString) else { return false }

        return currentDate > dateMatch
    }

    var isActive: Bool {
        (travel.googleDoc != nil && travel.googleDoc?.isEmpty == false) || (travel.telegram != nil && travel.telegram?.isEmpty == false)
    }

    @MainActor
    init(travel: Travel, idSeason: Int) {
        self.travel = travel
        self.idSeason = idSeason
        
        ProfileUpdateNotifier.shared.publisher
            .prefix(1)
            .sink { [weak self] profile in
                self?.idProfile = profile?.id
            }
            .store(in: &cancellables)



        onSubscribeSucceeded = { [weak self]  in
            self?.travel.hasSubscribed = true
        }
    }

    func checkAlreadySubscribe() async {
        guard isActive, !isPast else {
            return
        }

        do {
            guard let idProfile else {
                throw NSError(domain: "Le profile id n'est pas renseigné pour checker si le user est déjà inscrit au déplacement", code: 1)
            }

            travel.hasSubscribed = try await travelsRepository.checkAlreadySubscribe(travel.id, idSeason, idProfile)
            canAccessListing = travel.hasSubscribed
            state = .idle
        } catch {
            travel.hasSubscribed = false
            state = .idle

            AppLogger.error(error.decodedOrLocalizedDescription)
        }
    }

    nonisolated func checkIsUpToDateContribution() async {
        do {
            await MainActor.run { [self] in

                state = .loading
            }

            let date = travel.date

            let isUpToDateCotisationPayment: Bool

            if let date, let idProfile  {
                isUpToDateCotisationPayment = try await cotisationsRepository.isUpToDate(idProfile: idProfile, date: date)
            } else {
                throw TravelMatchViewModelError.missingDate
            }

            try Task.checkCancellation()

            if isUpToDateCotisationPayment {
                await MainActor.run { [self] in
                    canAccessListing = isUpToDateCotisationPayment
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

                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }
    }
}
