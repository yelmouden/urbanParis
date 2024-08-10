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
    case register(travel: Travel, idSeason: Int, onSubscribeSucceeded: (() -> Void))

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .link:
            hasher.combine(1)
        case .register:
            hasher.combine(2)
        }
    }

    public static func == (lhs: TravelMatchesScreen, rhs: TravelMatchesScreen) -> Bool {
            switch (lhs, rhs) {
            case (.link(let url1), .link(let url2)):
                return url1 == url2

            case (.register(let travel1, let idSeason1, _), .register(let travel2, let idSeason2, _)):
                return travel1 == travel2 && idSeason1 == idSeason2

            default:
                return false
            }
        }
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
                    case .register(let travel, let idSeason, let onSubscribeSucceeded):
                        TravelMatchFormView(viewModel: .init(travel: travel, idSeason: idSeason), onSubscribeSucceeded: onSubscribeSucceeded)
                    }
                }
        }
    }
}
