//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 18/04/2024.
//

import FlowStacks
import SwiftUI
import Utils

public enum ProfileScreen: Equatable {
    case none
}

public struct ProfileCoordinator: View {
    @State var routes: Routes<ProfileScreen>


    public init(routes: Routes<ProfileScreen> = []) {
        self.routes = routes
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            EditProfileView()
        }
    }
}
