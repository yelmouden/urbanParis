//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 19/02/2024.
//

import Foundation
import SwiftUI

public struct FWButton<LeftView: View>: View {

    @Environment(\.fwButtonStyle)
    var style

    @Environment(\.sizeCategory)
    var sizeCategory

    @Environment(\.enabled)
    var enabled

    @State var size: CGSize = .zero

    private let title: String
    private let state: FWButtonState
    private let action: (() -> Void)
    private let leftView: () -> LeftView

    public init(
        title: String,
        state: FWButtonState = .idle,
        action: @escaping (() -> Void),
        @ViewBuilder leftView: @escaping () -> LeftView = { EmptyView() }
    ) {
        self.title = title
        self.state = state
        self.leftView = leftView
        self.action = action
    }

    public var body: some View {
        let configuration = FWButtonConfiguration(
            title: title,
            state: state,
            size: size,
            enabled: enabled,
            leftView: AnyView(leftView()),
            action: action
        )

        AnyView(style.makeBody(configuration: configuration))
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            size = proxy.size
                        }
                }
            }
    }
}

#Preview("Primary idle") {
    FWButton(title: "se connecter", state: .idle, action: {})
        .fwButtonStyle(.primary)
}

#Preview("Primary loading") {
    FWButton(title: "se connecter", state: .loading, action: {})
        .fwButtonStyle(.primary)
}

#Preview("Primary sucess") {
    FWButton(title: "se connecter", state: .success, action: {})
        .fwButtonStyle(.primary)
}

#Preview("Primary dark mode idle") {
    FWButton(title: "se connecter", state: .idle, action: {})
        .fwButtonStyle(.primary)
        .preferredColorScheme(.dark)
}

#Preview("Primary dark mode loading") {
    FWButton(title: "se connecter", state: .loading, action: {})
        .fwButtonStyle(.primary)
        .preferredColorScheme(.dark)
}

#Preview("Primary dark mode success") {
    FWButton(title: "se connecter", state: .success, action: {})
        .fwButtonStyle(.primary)
        .preferredColorScheme(.dark)
}

#Preview("secondary") {
    FWButton(title: "se connecter", state: .idle, action: {})
        .fwButtonStyle(.secondary)
}

#Preview("secondary dark") {
    FWButton(title: "se connecter", state: .idle, action: {})
        .fwButtonStyle(.secondary)
        .preferredColorScheme(.dark)
}

#Preview("default") {
    FWButton(title: "se connecter", state: .idle, action: {})
}

#Preview("default dark mode") {
    FWButton(title: "se connecter", state: .idle, action: {})
        .preferredColorScheme(.dark)
}
