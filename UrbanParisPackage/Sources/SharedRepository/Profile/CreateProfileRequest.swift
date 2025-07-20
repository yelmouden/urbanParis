//
//  File.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 17/07/2025.
//

import Foundation
import SharedModels

public struct CreateProfileRequest: Encodable, Sendable {
    let firstname: String
    let lastname: String
    let nickname: String
    let year: Int
    let typeAbo: AboType

    public init(
        firstname: String,
        lastname: String,
        nickname: String,
        year: Int,
        typeAbo: AboType
    ) {
        self.firstname = firstname
        self.lastname = lastname
        self.nickname = nickname
        self.year = year
        self.typeAbo = typeAbo
    }
}
