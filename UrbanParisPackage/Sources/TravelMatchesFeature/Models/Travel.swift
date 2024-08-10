//
//  File.swift
//
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import Foundation

public struct Travel: Identifiable, Equatable, Codable {
    public let id: Int
    let date: String?
    let appointmentTime: String?
    let departureTime: String?
    let timeMatch: String?
    let price: Float?
    let descriptionTravel: String?
    let descriptionBar: String?
    let report: String?
    let googleDoc: String?
    let telegram: String?
    let priceMatch: Float?
    let team: Team
    let pool: Pool?
    var hasSubscribed: Bool = false

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        appointmentTime = try container.decodeIfPresent(String.self, forKey: .appointmentTime)
        departureTime = try container.decodeIfPresent(String.self, forKey: .departureTime)
        timeMatch = try container.decodeIfPresent(String.self, forKey: .timeMatch)
        price = try container.decodeIfPresent(Float.self, forKey: .price)
        descriptionTravel = try container.decodeIfPresent(String.self, forKey: .descriptionTravel)
        descriptionBar = try container.decodeIfPresent(String.self, forKey: .descriptionBar)
        report = try container.decodeIfPresent(String.self, forKey: .report)
        team = try container.decode(Team.self, forKey: .team)
        googleDoc = try container.decodeIfPresent(String.self, forKey: .googleDoc)
        telegram = try container.decodeIfPresent(String.self, forKey: .telegram)
        priceMatch = try container.decodeIfPresent(Float.self, forKey: .priceMatch)

        pool = try container.decodeIfPresent(Pool.self, forKey: .pool)

        // Transformer la chaîne de caractères en Date
        let dateString = try container.decodeIfPresent(String.self, forKey: .date)

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateString, let dateString = inputFormatter.date(from: date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"

            self.date = outputFormatter.string(from: dateString)

        } else {
            self.date = nil
        }
    }
}


