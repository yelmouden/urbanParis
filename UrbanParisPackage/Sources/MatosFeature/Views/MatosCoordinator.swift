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

public enum MatosScreen: Equatable {
    case subscribe
}

@MainActor
public struct MatosCoordinator: View {
    @State var routes: Routes<MatosScreen> = []

    @State var viewModel: MatosListViewModel = .init()
    var showMenu: Binding<Bool>

    public init(showMenu: Binding<Bool> ) {
        self.showMenu = showMenu
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            MatosListView(viewModel: viewModel)
                .addShowMenuButton(showMenu: showMenu)
                .flowDestination(for: MatosScreen.self) { screen in
                    switch screen {
                    case .subscribe:
                        SafariWebView(url: URL(string: "https://www.google.com")!)
                    }
                }
        }
    }
}
