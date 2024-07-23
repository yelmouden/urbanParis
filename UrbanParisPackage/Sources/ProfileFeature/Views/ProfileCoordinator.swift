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

public struct ProfileCoordinator: View {
    @State var routes: Routes<ProfileScreen> = []

    @Binding var showMenu: Bool


    public init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            EditProfileView()
                .addShowMenuButton(showMenu: $showMenu)
        }
    }
}
