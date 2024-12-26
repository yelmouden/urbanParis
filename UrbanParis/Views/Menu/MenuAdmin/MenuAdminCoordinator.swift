//
//  CotisationsScreen.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 19/11/2024.
//

import DesignSystem
import FlowStacks
import ProfileManager
import SwiftUI
import TravelMatchesFeature
import Utils

enum MenuAdminScreen: Equatable, Hashable {
    case members
    case memberDetails(MemberDetailsViewModel)
    case membersCotisation(CotisationsMembersViewModel)
    case memberDetailCotisation(CotisationsMember)
    case seasonsList
    case travels(idSeason: Int)
    case editTravel(idSeason: Int, travel: Travel)
    case showMembersTravel(idTravel: Int, idSeason: Int)


    public static func == (lhs: MenuAdminScreen, rhs: MenuAdminScreen) -> Bool {
        switch (lhs, rhs) {
        case (.members, .members): return true
        case (.memberDetails, .memberDetails): return true
        case (.membersCotisation, .membersCotisation): return true
        case (.memberDetailCotisation, .memberDetailCotisation): return true
        case (.seasonsList, .seasonsList): return true
        case (.travels, .travels): return true
        case (.editTravel, .editTravel): return true
        case (.showMembersTravel, .showMembersTravel): return true
        default: return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .members: hasher.combine("members")
        case .memberDetails: hasher.combine("memberDetails")
        case .membersCotisation: hasher.combine("membersCotisation")
        case .memberDetailCotisation: hasher.combine("memberDetailCotisation")
        case .seasonsList: hasher.combine("seasonsList")
        case .travels: hasher.combine("travels")
        case .editTravel: hasher.combine("editTravel")
        case .showMembersTravel: hasher.combine("showMembersTravel")
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
                    case .seasonsList:
                        SeasonsListView()
                    case .travels(let idSeason):
                        TravelsListView(idSeason: idSeason)
                    case .editTravel(let idSeason, let travel):
                        EditTravelMatchView(idSeason: idSeason, travel: travel)
                    case .showMembersTravel(let idTravel, let idSeason):
                        MembersTravelView(idTravel: idTravel, idSeason: idSeason)
                    }

                }
        }
    }
}
