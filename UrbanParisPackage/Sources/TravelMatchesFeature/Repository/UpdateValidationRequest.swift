//
//  File.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import Foundation

public struct UpdateValidationRequest: Encodable {
    let id: Int
    let idTravel: Int
    let isValidate: Bool
    let idSeason: Int
    let idProfile: Int

    public init(
        id: Int,
        idTravel: Int,
        isValidate: Bool,
        idSeason: Int,
        idProfile: Int
    ) {
        self.id = id
        self.idTravel = idTravel
        self.isValidate = isValidate
        self.idSeason = idSeason
        self.idProfile = idProfile
    }
}
