//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 05/08/2024.
//

import Foundation

public enum Size: String, Decodable {
    case XS
    case S
    case M
    case L
    case XL
    case XXL
    case none = ""

    enum CodingKeys: CodingKey {
        case title
    }

    public var order: Int {
        switch self {
        case .XS:
            return 0
        case .S:
            return 1
        case .M:
            return 2
        case .L:
            return 3
        case .XL:
            return 4
        case .XXL:
            return 5
        case .none:
            return -1
        }
    }

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Size.CodingKeys> = try decoder.container(keyedBy: Size.CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: Size.CodingKeys.title)
        self = .init(rawValue: title) ?? .none
    }
}
