//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 22/07/2024.
//

import Foundation
import DesignSystem
import ProfileManager

extension AboType: SelectableItem {
    public var title: String {
        switch self {
        case .aboPSG:
            "Abo PSG"
        case .aboCUP:
            "Abo CUP"
        case .none:
            "Pas d'abo"
        }
    }

    public var description: String? { nil }
}

