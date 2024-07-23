//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 15/02/2024.
//

import SwiftUI

public struct MainContainer<Content: View>: View {
    @Environment(\.colorScheme)
    var colorScheme

    let padding: CGFloat
    @ViewBuilder var content: () -> Content

    public init(padding: CGFloat = Margins.medium, @ViewBuilder content: @escaping () -> Content) {
        self.padding = padding
        self.content = content
    }

    public var body: some View {
        ZStack {
            DSColors.background.swiftUIColor
                .ignoresSafeArea()

            content()
                .padding([.leading, .trailing], padding)
                .paddingBottomScreen()


        }
    }
}

#Preview {
    MainContainer {}
}
