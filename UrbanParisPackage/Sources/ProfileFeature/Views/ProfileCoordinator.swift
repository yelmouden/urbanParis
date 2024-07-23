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
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {

                            withAnimation(.spring) {

                                self.showMenu.toggle()
                            }

                        }) {

                            // close Button...

                            Image(systemName: self.showMenu ? "xmark" : "line.horizontal.3")
                                .resizable()
                                .frame(width: self.showMenu ? 18 : 22, height: 18)
                                .foregroundColor(DSColors.white.swiftUIColor)
                        }
                    }
                }
        }
    }
}
