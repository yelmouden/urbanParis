//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 26/04/2024.
//

import Foundation
import SwiftUI

public struct AlertItemButton: Sendable {
    let title: String
    let action: (@Sendable () -> Void)?
    let asyncAction: (@Sendable () async -> Bool)?
    let onDismiss: (@Sendable @MainActor () -> Void)?
    let isDestructive: Bool

    public init(
        title: String,
        action: (@Sendable () -> Void)? = nil,
        asyncAction: (@Sendable () async -> Bool)? = nil,
        onDismiss: (@Sendable @MainActor () -> Void)? = nil,
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
