//
//  CotisationsScreen.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 19/11/2024.
//

import DesignSystem
import FlowStacks
import MembersFeature
import ProfileManager
import SwiftUI
import Utils

enum MenuAdminScreen: Equatable, Hashable {
    case members
    case memberDetails(MemberDetailsViewModel)
    case membersCotisation(CotisationsMembersViewModel)
    case memberDetailCotisation(CotisationsMember)

    public static func == (lhs: MenuAdminScreen, rhs: MenuAdminScreen) -> Bool {
        switch (lhs, rhs) {
        case (.members, .members): return true
        case (.memberDetails, .memberDetails): return true
        case (.membersCotisation, .membersCotisation): return true
        case (.memberDetailCotisation, .memberDetailCotisation): return true
        default: return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .members: hasher.combine("members")
        case .memberDetails: hasher.combine("memberDetails")
        case .membersCotisation: hasher.combine("membersCotisation")
        case .memberDetailCotisation: hasher.combine("memberDetailCotisation")
        }
    }
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
                    case .memberDetails(let viewModel):
                        MemberDetails(viewModel: viewModel)
                    case .membersCotisation(let viewModel):
                        CotisationsMembersView()
                    case .memberDetailCotisation(let cotisationsMember):
                        CotisationsMemberDetails(viewModel: .init(cotisationsMember: cotisationsMember))
                    }

                }
        }
    }
}
