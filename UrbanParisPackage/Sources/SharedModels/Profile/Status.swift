//
//  File.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 17/07/2025.
//

import Foundation

public enum Status: String, Codable, Sendable, CaseIterable {
    case sympath = "sympath"
    case aspi = "aspi"
    case urban = "urban"
    case noyau = "noyau"
    case leader = "leader"

    public var title: String {
        switch self {
        case .sympath:
            return "Sympathisant"
        case .aspi:
            return "Aspirant"
        case .urban:
            return "Urban"
        case .noyau:
            return "Noyau"
        case .leader:
            return "Leader"
        }
    }
}
