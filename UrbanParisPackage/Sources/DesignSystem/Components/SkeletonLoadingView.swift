//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 11/05/2024.
//

import SkeletonUI
import SwiftUI

public struct SkeletonLoadingView: View {

    private let height: CGFloat

    public init(height: CGFloat) {
        self.height = height
    }

    public var body: some View {
        Rectangle()
             .addBorder(Color.clear, cornerRadius: 20)
             .skeleton(
                with: true,
                appearance: .gradient(
                    color: DSColors.red.swiftUIColor.opacity(0.2),
                    background: DSColors.white.swiftUIColor.opacity(0.1)
                ),
                spacing: 16)
        .frame(height: height)
    }
}
