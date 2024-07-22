//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 22/07/2024.
//

import Foundation
import DesignSystem

enum AboType: SelectableItem {
    case aboPSG
    case aboCUP
    case none

    var title: String {
        switch self {
        case .aboPSG:
            "Abo PSG"
        case .aboCUP:
            "Abo CUP"
        case .none:
            "Aucun"
        }
    }

    var description: String? { nil }
}

