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

public enum CotisationsScreen: Equatable {
    case paypal
}

@MainActor
public struct CotisationsCoordinator: View {
    @State var routes: Routes<CotisationsScreen> = []

    @State var viewModel: CotisationsViewModel = .init()
    var showMenu: Binding<Bool>

    public init(showMenu: Binding<Bool> ) {
        self.showMenu = showMenu
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            CotisationsView(viewModel: viewModel)
                .addShowMenuButton(showMenu: showMenu)
                .flowDestination(for: CotisationsScreen.self) { screen in
                    switch screen {
                    case .paypal:
                        SafariWebView(url: URL(string: "https://www.paypal.com")!)
                    }
                }
        }
    }
}
