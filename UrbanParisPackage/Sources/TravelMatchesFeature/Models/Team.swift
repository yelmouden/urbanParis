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
    func retrieveIcon() async -> UIImage? {
        guard let logo = logo else { return nil }

        guard let data = try? await Database.shared.client.storage
            .from(Database.Storage.logos.rawValue)
            .download(path: "img/\(logo).png")
        else { return nil }

        return UIImage(data: data)
    }
}
