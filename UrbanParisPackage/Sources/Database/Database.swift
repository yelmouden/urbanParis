//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 15/05/2024.
//

import Foundation
import Supabase
import Utils

public enum DatabaseClientError: Error {
    case notFoundId
}

final public class Database {
    public let client: SupabaseClient

    public static let shared = Database()

    init() {
        guard let path: String = ConfigurationReader.value(for: "PROJECT_URL"),
        let apiURL: URL = .init(string: "https://" + path) else {
            fatalError("URL for database not found")
        }

        let apiKey: String = ConfigurationReader.value(for: "API_KEY")
        self.client = SupabaseClient(supabaseURL: apiURL, supabaseKey: apiKey)
    }
}

public extension Database {
    // swiftlint:disable identifier_name
    enum Table: String {
        case profiles
        case cotisations
        case seasons
        case travels
        case responses
    }

    enum Storage: String {
        // swiftlint:disable identifier_name
        case logos
    }
}

