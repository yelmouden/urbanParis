//
//  UrbanParisApp.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 17/07/2024.
//

import DesignSystem
import SwiftUI
import UIKit

@main
struct UrbanParisApp: App {
    init() {
        FontFamily.registerAllCustomFonts()
        UINavigationBar.setupStyle()
    }

    var body: some Scene {
        WindowGroup {
            AppView()
        }

    }
}
