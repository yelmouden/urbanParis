import SwiftUI

public struct CircularLoader: View {
    @State private var isAnimating: Bool = false

    private let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        ZStack {
            DSColors.black.swiftUIColor
                .opacity(0.6)
            VStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 5)
                        .opacity(0.3)
                        .foregroundColor(DSColors.red.swiftUIColor)

                    Circle()
                        .trim(from: 0, to: 0.6)
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                        .foregroundColor(DSColors.red.swiftUIColor)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                }
                .frame(width: 50, height: 50)
                .padding([.top, .bottom])


                Text(title)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoBody)
                    .padding(.bottom)
            }
            .padding([.leading, .trailing])
            .background(DSColors.background.swiftUIColor.opacity(0.7))
            .addBorder(.clear, cornerRadius: 12)
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}
