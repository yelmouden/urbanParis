//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import Database
import Foundation
import UIKit

struct Team: Identifiable, Equatable, Codable {
    let id: Int
    let name: String
    let logo: String?
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
