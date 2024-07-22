//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 22/07/2024.
//

import Pow
import SwiftUI
import UIKit

public struct BackgroundImageContainerView<Content: View>: View {
    @State var currentIndex = 0

    let images: [UIImage]
    @ViewBuilder var content: () -> Content

    public init(images: [UIImage], @ViewBuilder content: @escaping () -> Content) {
        self.images = images
        self.content = content
    }

    public var body: some View {
        ZStack {
             Image(uiImage: images[currentIndex])
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea(.all)
                .id(currentIndex)
                .transition(.movingParts.blur)

            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.black.opacity(0.5),
                        DSColors.background.swiftUIColor.opacity(0.9)
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)

            content()
                .padding([.leading, .trailing], Margins.medium)
        }
        .onChange(of: currentIndex, initial: true) { _, _ in
            if images.count > 1 {
                Task {
                    do {
                        try await Task.sleep(for: .seconds(4))
                        withAnimation(.smooth(duration: 1)) {
                            currentIndex = (currentIndex + 1) % images.count
                        }
                    } catch {}

                }
            }
        }
    }
}
