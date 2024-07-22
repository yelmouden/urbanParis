//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 22/07/2024.
//

import Foundation
import SwiftUI

public extension View {
    func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S: ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }

    func applyRowStyle() -> some View {
        listRowSeparatorTint(DSColors.red.swiftUIColor)
        .listRowBackground(DSColors.background.swiftUIColor)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .alignmentGuide(.listRowSeparatorLeading) { _ in
            return 0
        }
    }
}
