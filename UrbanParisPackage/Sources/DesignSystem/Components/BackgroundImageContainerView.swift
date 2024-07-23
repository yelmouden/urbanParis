//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 22/07/2024.
//

import Pow
import SwiftUI
import UIKit
import Utils

public struct BackgroundImageContainerView<Content: View>: View {
    @State var currentIndex: Int?

    let nameImages: [String]
    let bundle: Bundle
    let colors: [Color]

    @State private var images: [UIImage] = []

    @State private var isLoadingImages = false

    @State private var task: Task<Void, Never>?

    @ViewBuilder var content: () -> Content

    public init(
        nameImages: [String],
        bundle: Bundle,
        colors: [Color] = [DSColors.black.swiftUIColor.opacity(0.8), DSColors.background.swiftUIColor],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.nameImages = nameImages
        self.bundle = bundle
        self.colors = colors
        self.content = content
    }

    public var body: some View {
        ZStack {
            if !images.isEmpty, let currentIndex {
                Image(uiImage: images[currentIndex])
                   .resizable()
                   .scaledToFill()
                   .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                   .clipped()
                   .ignoresSafeArea(.all)
                   .id(currentIndex)
                   .transition(.movingParts.blur)
            }


            LinearGradient(
                gradient: Gradient(
                    colors: colors
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)

            content()
                .padding([.leading, .trailing], Margins.medium)
        }
        .onChange(of: currentIndex, initial: true) { _, _ in
            if images.count > 1, let currentIndex {
                Task {
                    do {
                        try await Task.sleep(for: .seconds(4))
                        withAnimation(.smooth(duration: 1)) {
                            self.currentIndex = (currentIndex + 1) % images.count
                        }
                    } catch {}

                }
            }
        }
        .onAppear {
            if !isLoadingImages {
                isLoadingImages = true

                self.task = Task.detached {
                    do {
                        var imgs = [UIImage]()

                        for name in nameImages {
                            let img = imageFromPDF(named: name, bundle: bundle)
                            try Task.checkCancellation()
                            imgs.append(img)
                        }

                        await MainActor.run { [imgs] in
                            currentIndex = 0
                            images = imgs
                        }
                    } catch {
                        isLoadingImages = false
                    }

                }
            }
        }
        .onDisappear {
            task?.cancel()
        }
        .animation(.smooth, value: images)
    }
}
