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

    private let travel: Travel
    private let team: Team

    let idSeason: Int
    let idTravel: Int

    var teamName: String { team.name }
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

    init(idSeason: Int, travel: Travel) {
        self.idSeason = idSeason
        self.idTravel = travel.id

        self.travel = travel

        self.team = travel.team

        if let stringDate = travel.date,
           let date = Date.fromString(stringDate) {
            self.date = date
        } else {
            date = .now
        }

        if let stringTime = travel.appointmentTime,
           let time = Date.timeFromString(stringTime) {
            self.appointmentTime = time
        } else {
            appointmentTime = .now
        }

        if let stringTime = travel.departureTime,
           let time = Date.timeFromString(stringTime) {
            self.departureTime = time
        } else {
            departureTime = .now
        }

        if let stringTime = travel.timeMatch,
           let time = Date.timeFromString(stringTime) {
            self.matchTime = time
        } else {
            matchTime = .now
        }

        if let price = travel.price {
            var priceString = "\(price)"
            priceString.formattedDecimalText()
            self.priceBus = priceString
        } else {
            self.priceBus = ""
        }

        if let price = travel.priceMatch {
            var priceString = "\(price)"
            priceString.formattedDecimalText()
            self.priceMatch = priceString
        } else {
            self.priceMatch = ""
        }

        self.descriptionMatch = travel.descriptionTravel ?? ""

        self.googleDoc = travel.googleDoc ?? ""

        self.telegram = travel.telegram ?? ""

        self.reportMatch = travel.report ?? ""

    }
}
