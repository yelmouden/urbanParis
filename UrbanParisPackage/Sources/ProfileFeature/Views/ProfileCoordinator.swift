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

public enum ProfileScreen: Equatable {
    case none
}

@MainActor
public struct ProfileCoordinator: View {
    @State var routes: Routes<ProfileScreen> = []

    @State var viewModel: EditProfileViewModel
    var showMenu: Binding<Bool>?

    public init(showMenu: Binding<Bool>? = nil) {
        self.showMenu = showMenu
        viewModel = EditProfileViewModel()
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            if let showMenu {
                EditProfileView(viewModel: viewModel)
                    .addShowMenuButton(showMenu: showMenu)
            } else {
                EditProfileView(viewModel: viewModel)
            }
        }
    }
}
