//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 19/02/2024.
//

import SwiftUI

public struct LoaderView: View {
    @State private var showSpinner: Bool = false
    @State private var degree: Int = 270
    @State private var spinnerLength = 0.6

    let color: Color

    public init(color: Color = DSColors.white.swiftUIColor) {
        self.color = color
    }

    public var body: some View {
        Circle()
            .trim(from: 0.0, to: spinnerLength)
            .stroke(
                color,
                style: StrokeStyle(
                    lineWidth: 4.0,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .animation(Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true), value: degree)
            .rotationEffect(Angle(degrees: Double(degree)))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: degree)
            .onAppear {
                degree = 270 + 360
                spinnerLength = 0
            }
    }
}

#Preview {
    LoaderView(color: DSColors.white.swiftUIColor)
        .frame(width: 60, height: 60)

}
