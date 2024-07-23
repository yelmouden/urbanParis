//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 26/04/2024.
//

import Foundation
import SharedResources
import SwiftUI

public struct AlertItemButton {
    let title: String
    let action: (() -> Void)?
    let asyncAction: (() async -> Bool)?
    let onDismiss: (() -> Void)?
    let isDestructive: Bool

    public init(
        title: String,
        action: (() -> Void)? = nil,
        asyncAction: (() async -> Bool)? = nil,
        onDismiss: (() -> Void)? = nil,
        isDestructive: Bool
    ) {
        self.title = title
        self.action = action
        self.asyncAction = asyncAction
        self.onDismiss = onDismiss
        self.isDestructive = isDestructive
    }
}

public extension AlertItemButton {
    static let cancel = AlertItemButton(
        title: "Annuler",
        isDestructive: false
    )
}
