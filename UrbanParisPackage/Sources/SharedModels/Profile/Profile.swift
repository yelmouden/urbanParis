//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 24/07/2024.
//

import Database
import Foundation
import Supabase
import UIKit

public struct Profile: Codable, Equatable, Sendable, Identifiable {
    public let id: Int
    public var firstname: String
    public var lastname: String
    public var nickname: String
    public var year: Int
    public var typeAbo: AboType
    public var isLocked: Bool
    public var isAdmin: Bool
    public let status: Status?

    public init(
        id: Int,
        firstname: String,
        lastname: String,
        nickname: String,
        year: Int,
        typeAbo: AboType,
        isLocked: Bool,
        isAdmin: Bool,
        status: Status?
    ) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.nickname = nickname
        self.year = year
        self.typeAbo = typeAbo
        self.isLocked = isLocked
        self.isAdmin = isAdmin
        self.status = status
    }
}


public extension Profile {
    func urlDownloadPhoto() async -> URL? {
        return try? await Database.shared.client.storage
            .from(Database.Storage.profiles.rawValue)
            .createSignedURL(path: "img/\(id).png", expiresIn: 60)
    }
}
