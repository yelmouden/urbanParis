//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 13/05/2024.
//

import SwiftUI

public struct ListStateView<IdleView: View, LoadingView: View, LoadedView: View, EmptyView: View, T: Equatable&Sendable>: View {
    let stateView: StateView<T>

    let idleView: () -> IdleView
    let loadingView: () -> LoadingView
    let loadedView: (T) -> LoadedView
    let emptyView: () -> EmptyView

    public init(
        stateView: StateView<T>,
        @ViewBuilder idleView: @escaping () -> IdleView = { SwiftUI.EmptyView() },
        @ViewBuilder loadingView: @escaping () -> LoadingView = { SwiftUI.EmptyView() },
        @ViewBuilder loadedView: @escaping (T) -> LoadedView = { (_: T) in SwiftUI.EmptyView() },
        @ViewBuilder emptyView: @escaping () -> EmptyView = { SwiftUI.EmptyView() }
    ) {
        self.stateView = stateView
        self.idleView = idleView
        self.loadingView = loadingView
        self.loadedView = loadedView
        self.emptyView = emptyView
    }


    public var body: some View {
        VStack {
            switch stateView {
            case .idle:
                idleView()
                    .transition(.opacity)
            case .loading:
                loadingView()
                    .transition(.opacity)
            case .loaded(let t):
                loadedView(t)
                    .transition(.opacity)
            case .empty:
                emptyView()
                    .transition(.opacity)
            }
        }
        .animation(.default, value: stateView)
    }
}
