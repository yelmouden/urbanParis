//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import Database
import Foundation
import UIKit

public struct Team: Identifiable, Equatable, Codable {
    public let id: Int
    public let name: String
    public let logo: String?
}

extension Team {
    func retrieveURLIcon() async -> URL? {
        guard let logo = logo else { return nil }

        let url = try? await Database.shared.client.storage
            .from(Database.Storage.logos.rawValue)
            .createSignedURL(path: "img/\(logo)", expiresIn: 60)

        return url
    }
}
