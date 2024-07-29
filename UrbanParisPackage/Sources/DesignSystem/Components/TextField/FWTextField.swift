//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 19/02/2024.
//

import SwiftUI
import Utils

public struct FWTextField: View {
    @State private var sizeText: CGSize = .zero
    @State private var pathProgress = 0.0
    @State private var shouldRevealPassword: Bool
    @FocusState private var isFocus: Bool

    @Environment(\.sizeCategory)
    var sizeCategory

    let title: String
    let placeholder: String
    let isSecure: Bool
    let text: Binding<String>

    public init(
        title: String,
        placeholder: String,
        isFocus: FocusState<Bool> = .init(),
        isSecure: Bool = false,
        
        text: Binding<String>
    ) {
        self.title = title
        self.placeholder = placeholder
        self._isFocus = isFocus
        self.isSecure = isSecure
        self.text = text
        self._shouldRevealPassword = State(initialValue: !isSecure)
    }

    public var body: some View {
        ZStack {
            ZStack(alignment: .topLeading) {
                CurveShape(widthText: sizeText.width)
                    .trim(from: 0.0, to: pathProgress)
                    .stroke(isFocus ? DSColors.red.swiftUIColor : Color.clear, lineWidth: 2)
                    .frame(height: sizeCategory <= .extraExtraExtraLarge ? 50 : 100)
                    .animation(.easeOut(duration: 0.3), value: pathProgress)

                Text(title)
                    .font(DSFont.grafHeadline)
                    .foregroundStyle(isFocus ? DSColors.red.swiftUIColor : DSColors.white.swiftUIColor)
                    .font(.footnote)
                    .offset(x: isFocus ? 30 : 0, y: isFocus ? -(sizeText.height / 2) : 0)
                    .onAppear {
                        let fontAttributes = [NSAttributedString.Key.font: FontFamily.DonGraffiti.regular.font(size: 20)]
                        sizeText = title.size(withAttributes: fontAttributes)
                    }
            }

            HStack {
                ZStack {
                    SecureField("", text: text, prompt: Text(placeholder).foregroundStyle(SwiftUI.Color( DSColors.white.color.withAlphaComponent(0.6))))
                        .foregroundStyle(DSColors.white.swiftUIColor)
                        .padding([.leading, .trailing], isFocus ? 16 : 0)
                        .padding(.top, isFocus ? 0 : 12)
                        .focused($isFocus)
                        .opacity(shouldRevealPassword ? 0 : 1)

                    TextField("", text: text, prompt: Text(placeholder).foregroundStyle(SwiftUI.Color( DSColors.white.color.withAlphaComponent(0.6))))
                        .foregroundStyle(DSColors.white.swiftUIColor)
                        .padding([.leading, .trailing], isFocus ? 16 : 0)
                        .padding(.top, isFocus ? 0 : 12)
                        .focused($isFocus)
                        .opacity(shouldRevealPassword ? 1 : 0)
                }

                if isFocus && isSecure {
                    Button(action: {
                        shouldRevealPassword.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            isFocus = true

                        }
                    }, label: {
                        Image(systemName: shouldRevealPassword ? "eye.slash" : "eye")
                            .foregroundStyle(DSColors.red.swiftUIColor)
                            .padding(.trailing, Margins.mediumSmall)
                            .transition(.opacity)
                    })
                    .addSensoryFeedback()
                }
            }
        }
        .padding([.leading, .trailing], 1)
        .animation(.easeIn(duration: 0.20), value: isFocus)
        .animation(.default, value: shouldRevealPassword)
        .onChange(of: isFocus) {
            pathProgress = isFocus ? 1 : 0
        }
    }
}


private struct CurveShape: Shape {
    let widthText: CGFloat

    func path(in rect: CGRect) -> Path {
        let minX = rect.minX
        let minY = rect.minY
        let maxX = rect.maxX
        let maxY = rect.maxY

        var path = Path()
        path.move(to: CGPoint(x: 20, y: rect.minY))
        path.addLine(to: CGPoint(x: 26, y: rect.minY))

        path.move(to: CGPoint(x: 34 + widthText, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - 40, y: rect.minY))
        path.addArc(
            center: CGPoint(x: rect.maxX - 20, y: rect.minY + 20),
            radius: 20,
            startAngle: Angle(radians: 3 * .pi / 2),
            endAngle: Angle.zero,
            clockwise: false
        )

        path.addArc(
            center: CGPoint(x: maxX - 20, y: maxY - 20),
            radius: 20,
            startAngle: Angle.zero,
            endAngle: Angle(radians: .pi / 2),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: minX + 20, y: maxY))

        path.addArc(
            center: CGPoint(x: minX + 20, y: maxY - 20),
            radius: 20,
            startAngle: Angle(radians: .pi / 2),
            endAngle: Angle(radians: .pi),
            clockwise: false
        )

        path.addArc(
            center: CGPoint(x: minX + 20, y: minY + 20),
            radius: 20,
            startAngle: Angle(radians: .pi),
            endAngle: Angle(radians: 3 * .pi / 2),
            clockwise: false
        )

        return path
    }
}
