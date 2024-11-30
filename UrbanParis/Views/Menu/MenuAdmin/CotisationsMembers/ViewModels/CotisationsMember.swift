//
//  CotisationMember.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 29/11/2024.
//

import ProfileManager
import SharedRepository

struct CotisationsMember: Decodable, Equatable, Identifiable {
    public let id: Int
    let firstname: String
    let lastname: String
    let cotisations: [Cotisation]

    var totalToPay: String {
        cotisations.reduce(0.0) { partialResult, cotisation in
            partialResult + cotisation.amount
        }
        .amountText
    }

    var allPaid: Bool {
        cotisations.reduce(0.0) { partialResult, cotisation in
            partialResult + cotisation.amount
        } == 0
    }
}
