//
//  UrbanParisApp.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 17/07/2024.
//

import DesignSystem
import SwiftUI

@main
struct UrbanParisApp: App {
    init() {
        FontFamily.registerAllCustomFonts()
    }

    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
