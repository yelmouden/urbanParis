//
//  TravelDetailsViewModel.swift
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
final class EditTravelMatchViewModel {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository)
    var travelMatchesRepository

    var stateSave: StateView<EmptyResource> = .idle
    var showError = false

    private let travel: Travel?
    var team: Team?

    let idSeason: Int
    let idTravel: Int?

    var teamName: String { team?.name ?? "Equipe non définie" }
    var date: Date
    var appointmentTime: Date
    var departureTime: Date
    var matchTime: Date
    var priceBus: String
    var priceMatch: String
    var googleDoc: String
    var telegram: String
    var descriptionMatch: String
    var reportMatch: String

    init(idSeason: Int, travel: Travel?) {
        self.idSeason = idSeason
        self.idTravel = travel?.id

        self.travel = travel

        self.team = travel?.team

        if let stringDate = travel?.date,
           let date = Date.fromString(stringDate) {
            self.date = date
        } else {
            date = .now
        }

        if let stringTime = travel?.appointmentTime,
           let time = Date.timeFromString(stringTime) {
            self.appointmentTime = time
        } else {
            appointmentTime = Date.timeFromString("00:00:00") ?? .now
        }

        if let stringTime = travel?.departureTime,
           let time = Date.timeFromString(stringTime) {
            self.departureTime = time
        } else {
            departureTime = Date.timeFromString("00:00:00") ?? .now
        }

        if let stringTime = travel?.timeMatch,
           let time = Date.timeFromString(stringTime) {
            self.matchTime = time
        } else {
            matchTime = Date.timeFromString("00:00:00") ?? .now
        }

        if let price = travel?.price {
            var priceString = "\(price)"
            priceString.formattedDecimalText()
            self.priceBus = priceString
        } else {
            self.priceBus = "0"
        }

        if let price = travel?.priceMatch {
            var priceString = "\(price)"
            priceString.formattedDecimalText()
            self.priceMatch = priceString
        } else {
            self.priceMatch = "0"
        }

        self.descriptionMatch = travel?.descriptionTravel ?? ""

        self.googleDoc = travel?.googleDoc ?? ""

        self.telegram = travel?.telegram ?? ""

        self.reportMatch = travel?.report ?? ""

    }

    func saveTravel() async -> Bool {
        do {
            guard let idTeam = team?.id,
                let priceBus = Double(priceBus),
                let priceMatch = Double(priceMatch)
            else {
                return false
            }

            stateSave = .loading

            let request = UpdateTravelRequest(
                date: date,
                idTeam: idTeam,
                appointmentTime: appointmentTime.timeString(),
                departureTime: departureTime.timeString(),
                timeMatch: matchTime.timeString(),
                price: priceBus,
                priceMatch: priceMatch,
                descriptionTravel: descriptionMatch.isEmpty ? nil : descriptionMatch,
                report: reportMatch.isEmpty ? nil : reportMatch,
                googleDoc: googleDoc,
                telegram: telegram,
                idSeason: idSeason
            )

            try await travelMatchesRepository.updateTravel(request, idTravel)

            try Task.checkCancellation()

            return true

        } catch {
            if !(error is CancellationError) {
                showError = true
                stateSave = .idle
            }
            return false
        }

    }
}
