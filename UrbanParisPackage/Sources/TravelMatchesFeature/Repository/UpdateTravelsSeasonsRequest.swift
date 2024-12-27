//
//  UpdateTravelRequest 2.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 27/12/2024.
//


public struct UpdateTravelsSeasonsRequest: Encodable {
    let idTravel: Int
    let idSeason: Int

    public init(idTravel: Int, idSeason: Int) {
        self.idTravel = idTravel
        self.idSeason = idSeason
    }
}
