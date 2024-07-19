//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 26/04/2024.
//

import SwiftUI

public struct FWScrollView<Content: View>: View {
    @ViewBuilder var content: () -> Content

    public init(content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    content()
                }
                .frame(minHeight: proxy.size.height, alignment: .top)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

