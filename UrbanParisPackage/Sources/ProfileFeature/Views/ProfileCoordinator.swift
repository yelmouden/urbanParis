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

public enum ProfileScreen: Equatable, Hashable {
    case myTravels(InterModuleAction<Void>)

    public static func ==(lhs: ProfileScreen, rhs: ProfileScreen) -> Bool {
        switch (lhs, rhs) {
        case (.myTravels, .myTravels):
            return true
        }
    }

    public func hash(into hasher: inout Hasher) {
            switch self {
            case .myTravels:
                hasher.combine(1)
            }
        }
}

@MainActor
public struct ProfileCoordinator: View {
    @State var routes: Routes<ProfileScreen> = []

    @State var viewModel: EditProfileViewModel
    var showMenu: Binding<Bool>?

    var getMyTravels: ((InterModuleAction<Void>) -> AnyView)?

    public init(showMenu: Binding<Bool>? = nil, getMyTravels: ((InterModuleAction<Void>) -> AnyView)? = nil) {
        self.showMenu = showMenu
        self.getMyTravels = getMyTravels
        viewModel = EditProfileViewModel()
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            if let showMenu {
                EditProfileView(viewModel: viewModel)
                    .addShowMenuButton(showMenu: showMenu)
                    .flowDestination(for: ProfileScreen.self) { screen in
                        switch screen {
                        case .myTravels(let moduleAction):
                            getMyTravels?(moduleAction) ?? AnyView(EmptyView())
                        }
                    }
            } else {
                EditProfileView(viewModel: viewModel)
            }
        }
    }
}
