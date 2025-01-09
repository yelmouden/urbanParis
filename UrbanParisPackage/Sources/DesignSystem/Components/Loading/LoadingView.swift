//
//  SwiftUIView.swift
//  ClubDonorsPackage
//
//  Created by Yassin El Mouden on 05/11/2024.
//

import SwiftfulLoadingIndicators
import SwiftUI

public struct LoadingViewModifier: ViewModifier {
    let isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
        }
        .overlay {
            if isLoading {
                VStack {
                    LoadingIndicator(
                        animation: .threeBallsBouncing,
                        color: DSColors.red.swiftUIColor,
                        size: .medium
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(DSColors.background.swiftUIColor.opacity(0.6))
                .ignoresSafeArea()
                .zIndex(1)
            }
        }
        .animation(.default, value: isLoading)
    }
}


public extension View {
    func showLoading(
        _ isLoading: Bool
    ) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading))
    }
}

#Preview {
    Color.white
        .showLoading(true)
}

public struct LoadingView: View {

    public init() {

    }
    public var body: some View {
        VStack {
            LoadingIndicator(
                animation: .threeBallsBouncing,
                color: DSColors.red.swiftUIColor,
                size: .medium
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DSColors.background.swiftUIColor.opacity(0.6))
        .ignoresSafeArea()
        .zIndex(1)
    }
}
