//
//  File.swift
//
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import Foundation

public struct Travel: Identifiable, Equatable, Codable {
    public let id: Int
    public let date: String?
    public let appointmentTime: String?
    public let departureTime: String?
    public let timeMatch: String?
    public let price: Float?
    public let descriptionTravel: String?
    public let descriptionBar: String?
    public let report: String?
    public let googleDoc: String?
    public let telegram: String?
    public let priceMatch: Float?
    public let team: Team
    public let pool: Pool?
    public var hasSubscribed: Bool = false

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


