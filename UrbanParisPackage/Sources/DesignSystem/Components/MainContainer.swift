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

    @ViewBuilder var content: () -> Content

    public init( @ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        ZStack {
            DSColors.background.swiftUIColor
                .ignoresSafeArea()

            content()
                .padding([.leading, .trailing], Margins.medium)
                //.paddingBottomScreen()


        }
    }
}

#Preview {
    MainContainer {}
}
