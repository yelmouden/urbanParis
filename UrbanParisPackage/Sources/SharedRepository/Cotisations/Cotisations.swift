//
//  File 2.swift
//  
//
//  Created by Yassin El Mouden on 25/07/2024.
//

import Foundation

public struct Cotisation: Equatable, Identifiable, Decodable {
    public let id: Int
    public let month: Int
    public let amount: Float
}

public extension Cotisation {
    var titleMonth: String {
        switch month {
        case 1: return "janvier"
        case 2: return "février"
        case 3: return "mars"
        case 4: return "avril"
        case 5: return "mai"
        case 6: return "juin"
        case 7: return "juillet"
        case 8: return "août"
        case 9: return "septembre"
        case 10: return "octobre"
        case 11: return "novembre"
        case 12: return "décembre"
        default: return ""
        }
    }

    var isPaid: Bool {
        amount == 0
    }
}

public extension Array where Element == Cotisation {
    var totalAmount: Float {
        reduce(0) { $0 + $1.amount }
    }
}
