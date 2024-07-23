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
@MainActor
struct UrbanParisApp: App {
    @State var viewModel = AppViewModel()

    init() {
        FontFamily.registerAllCustomFonts()
        UINavigationBar.setupStyle()
    }

    var body: some Scene {
        WindowGroup {
            AppView(appViewModel: viewModel)
        }

    }
}
