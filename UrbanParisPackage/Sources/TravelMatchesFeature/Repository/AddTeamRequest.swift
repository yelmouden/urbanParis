//
//  AddSeasonRequest 2.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 27/12/2024.
//


public struct AddTeamRequest: Encodable {
    public var name: String

    public init(name: String) {
        self.name = name
    }
}
