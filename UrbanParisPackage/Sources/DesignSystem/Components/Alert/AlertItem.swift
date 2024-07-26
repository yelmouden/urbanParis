//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 30/04/2024.
//

import Foundation

public struct AlertItem {
    public let id = UUID()
    public let title: LocalizedStringResource
    public let description: LocalizedStringResource
    public let primaryButtonItem: AlertItemButton
    public let secondaryButtonItem: AlertItemButton?

    public init(
        title: LocalizedStringResource,
        description: LocalizedStringResource,
        primaryButtonItem: AlertItemButton,
        secondaryButtonItem: AlertItemButton?
    ) {
        self.title = title
        self.description = description
        self.primaryButtonItem = primaryButtonItem
        self.secondaryButtonItem = secondaryButtonItem
    }
}
