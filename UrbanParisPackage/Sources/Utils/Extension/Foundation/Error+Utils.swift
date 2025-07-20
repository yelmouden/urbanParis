//
//  File.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 20/07/2025.
//

import Foundation

public extension Error {
    var decodedOrLocalizedDescription: String {
        if let decodingError = self as? DecodingError {
            switch decodingError {
            case .typeMismatch(_, let context),
                 .valueNotFound(_, let context),
                 .keyNotFound(_, let context),
                 .dataCorrupted(let context):
                return context.debugDescription
            @unknown default:
                return decodingError.localizedDescription
            }
        } else {
            return self.localizedDescription
        }
    }
}
