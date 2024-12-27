//
//  File.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 27/12/2024.
//

import Foundation

public struct AddRegisterProfileTravelRequest: Codable {
    let idTravel: Int
    let idSeason: Int
    let idProfile: Int

    public init(
        idTravel: Int,
        idSeason: Int,
        idProfile: Int
    ) {
        self.idTravel = idTravel
        self.idSeason = idSeason
        self.idProfile = idProfile
    }
}
