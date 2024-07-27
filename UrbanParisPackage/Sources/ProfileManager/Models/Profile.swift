//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 24/07/2024.
//

import Foundation

public struct Profile: Codable {
    public let id: Int?
    public var firstname: String
    public var lastname: String
    public var nickname: String
    public var year: Int
    public var typeAbo: AboType?
    public var isLocked: Bool
    public var isAdmin: Bool

    public init() {
        id = nil
        firstname = ""
        lastname = ""
        nickname = ""
        year = Date.currentYear
        typeAbo = nil
        isLocked = false
        isAdmin = false
    }
}
