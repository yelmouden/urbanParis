//
//  File.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 27/12/2024.
//

import Foundation

public struct UpdateTravelRequest: Encodable {
    let date: Date
    let idTeam: Int
    let appointmentTime: String?
    let departureTime: String?
    let timeMatch: String?
    let price: Double?
    let priceMatch: Double?
    let descriptionTravel: String?
    let report: String?
    let googleDoc: String?
    let telegram: String?
    let idSeason: Int

    public init(
        date: Date,
        idTeam: Int,
        appointmentTime: String?,
        departureTime: String?,
        timeMatch: String?,
        price: Double?,
        priceMatch: Double?,
        descriptionTravel: String?,
        report: String?,
        googleDoc: String?,
        telegram: String?,
        idSeason: Int
    ) {
        self.date = date
        self.appointmentTime = appointmentTime
        self.departureTime = departureTime
        self.timeMatch = timeMatch
        self.price = price
        self.priceMatch = priceMatch
        self.descriptionTravel = descriptionTravel
        self.report = report
        self.idTeam = idTeam
        self.googleDoc = googleDoc
        self.telegram = telegram
        self.idSeason = idSeason
    }
}
