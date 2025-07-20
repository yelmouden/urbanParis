//
//  CreateProfileRequest.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 17/07/2025.
//

import Foundation
import SharedModels

public struct UpdateProfileRequest: Encodable, Sendable {
    public var firstname: String?
    public var lastname: String?
    public var nickname: String?
    public var year: Int?
    public var typeAbo: AboType?
    public var isLocked: Bool?
    public var isAdmin: Bool?
    public var status: Status?

    public init() {}
}

extension UpdateProfileRequest {
    var isEmpty: Bool {
        firstname == nil &&
        lastname == nil &&
        nickname == nil &&
        year == nil &&
        typeAbo == nil
    }
}

