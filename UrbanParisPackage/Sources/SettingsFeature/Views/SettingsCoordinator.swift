//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 18/04/2024.
//

import DesignSystem
import FlowStacks
import SwiftUI
import Utils

public enum SettingsScreen {
    case none
}

public struct SettingsCoordinator: View {
    @State var routes: Routes<SettingsScreen> = []

    @State var viewModel = SettingsViewModel()

    @Binding var showMenu: Bool

    public init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            SettingsView(viewModel: viewModel)
                .addShowMenuButton(showMenu: $showMenu)
        }
    }
}
