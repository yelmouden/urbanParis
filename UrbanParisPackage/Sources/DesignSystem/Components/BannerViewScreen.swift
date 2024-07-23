//
//  File.swift
//
//
//  Created by Yassin El Mouden on 27/02/2024.
//

import Pow
import SwiftUI
import Utils

struct BannerViewScreen: ViewModifier {

    @Binding var show: Bool

    let text: String
    let bannerType: BannerType
    let shouldAddBottomExtraPadding: Bool

    init(
        show: Binding<Bool>,
        text: String,
        bannerType: BannerType,
        shouldAddBottomExtraPadding: Bool = false
    ) {
        self._show = show
        self.text = text
        self.bannerType = bannerType
        self.shouldAddBottomExtraPadding = shouldAddBottomExtraPadding
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            if show {
                bannerType.color
                    .frame(height: 50)
                    .overlay {
                        HStack {
                            Spacer()
                            Text(text)
                                .foregroundStyle(DSColors.white.swiftUIColor)
                                .font(DSFont.robotoBodyBold)
                                .padding()
                            Spacer()
                    }

                }
                .transition(.movingParts.blinds)
                .zIndex(2)
            }
        }
        .animation(.bouncy, value: show)
        .onChange(of: show) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    show = false
                }
            }
        }

    }
}

public extension View {
    func showBanner(_ binding: Binding<Bool>, text: String, type: BannerType, shouldAddBottomExtraPadding: Bool = false) -> some View {
        modifier(BannerViewScreen(show: binding, text: text, bannerType: type, shouldAddBottomExtraPadding: shouldAddBottomExtraPadding))

    }
}

public enum BannerType {
    case success
    case error

    var color: Color {
        switch self {
        case .success: return DSColors.success.swiftUIColor
        case .error: return DSColors.error.swiftUIColor
        }
    }
}
