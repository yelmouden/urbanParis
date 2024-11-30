//
//  CotisationsMemberDetailsViewModel.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 29/11/2024.
//

import Dependencies
import Foundation
import SharedRepository
import Utils

struct CotisationData {
    let id: Int
    let numMonth: Int
    let month: String
    var amountText: String
    let idProfile: Int
}

@MainActor
@Observable
final class CotisationsMemberDetailsViewModel {
    @ObservationIgnored
    @Dependency(\.cotisationsMembersRepository) var repository

    let cotisationsMember: CotisationsMember

    var cotisations: [CotisationData]

    var isEnabled: Bool {
        for cotisation in cotisations {
            if cotisation.amountText.isEmpty {
                return false
            }
        }

        return true
    }

    var showError: Bool = false
    var showSuccess: Bool = false

    var state: StateView<EmptyResource> = .idle

    init(cotisationsMember: CotisationsMember) {
        self.cotisationsMember = cotisationsMember

        let sortedCotisations = cotisationsMember.cotisations.sorted { (a, b) -> Bool in
            let adjustedMonthA = (a.month + 4) % 12
            let adjustedMonthB = (b.month + 4) % 12
            return adjustedMonthA < adjustedMonthB
        }

        cotisations = sortedCotisations.map {
            var amountText = String($0.amount)
            amountText.formattedDecimalText()
            return CotisationData(id: $0.id, numMonth: $0.month, month: $0.titleMonth, amountText: amountText, idProfile: $0.id_profile)
        }
    }

    func save() async {
        do {
            state = .loading
            let updatedCotisations: [Cotisation] = cotisations.compactMap {
                return Cotisation(
                    id: $0.id,
                    month: $0.numMonth,
                    amount: $0.amountText.valueAmount ?? 0,
                    id_profile: $0.idProfile
                )
            }

            try await repository.saveCotisations(updatedCotisations, cotisationsMember.id)
            showSuccess = true

        } catch {
            showError = true
        }

        state = .idle

    }
}
