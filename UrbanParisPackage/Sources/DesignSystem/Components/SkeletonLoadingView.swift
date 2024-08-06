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
    private let shapeType: ShapeType

    public init(height: CGFloat, shapeType: ShapeType = .capsule) {
        self.height = height
        self.shapeType = shapeType
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
                shape: shapeType,
                spacing: 16)
        .frame(height: height)
    }
}
