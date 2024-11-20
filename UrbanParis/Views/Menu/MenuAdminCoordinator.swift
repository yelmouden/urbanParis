//
//  CotisationsScreen.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 19/11/2024.
//

import DesignSystem
import FlowStacks
import MembersFeature
import SwiftUI
import Utils

public enum MenuAdminScreen: Equatable {
    case members
}

@MainActor
public struct MenuAdminCoordinator: View {
    @State var routes: Routes<MenuAdminScreen> = []

    var showMenu: Binding<Bool>

    public init(showMenu: Binding<Bool> ) {
        self.showMenu = showMenu
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            AdminMenuView()
                .addShowMenuButton(showMenu: showMenu)
                .flowDestination(for: MenuAdminScreen.self) { screen in
                    switch screen {
                        case .members:
                        ListMembersView()
                            .addBackButton {
                                routes.pop()
                            }
                    }
                }
        }
    }
}
