//
//  Untitled.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 26/12/2024.
//

public struct RegisterProfileTravel: Codable, Equatable, Identifiable {
    public let id: Int
    public let idSeason: Int
    public let idTravel: Int
    public let idProfile: Int
    public let profiles: RegisterProfile
    public let isValidate: Bool
}

public struct RegisterProfile: Codable, Equatable {
    public let firstname: String
    public let lastname: String
}


