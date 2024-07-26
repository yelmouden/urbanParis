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

public enum TravelMatchesScreen: Equatable, Hashable {
    case link(URL)
}

@MainActor
public struct TravelMatchesCoordinator: View {
    @State var routes: Routes<TravelMatchesScreen> = []

    @State var viewModel: TravelMatchesViewModel = .init()
    var showMenu: Binding<Bool>

    public init(showMenu: Binding<Bool> ) {
        self.showMenu = showMenu
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            TravelMatchesView(viewModel: viewModel)
                .addShowMenuButton(showMenu: showMenu)
                .flowDestination(for: TravelMatchesScreen.self) { screen in
                    switch screen {
                    case .link(let url):
                        SafariWebView(url: url)
                    }
                }
        }
    }
}
