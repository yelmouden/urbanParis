//
//  File.swift
//
//
//  Created by Yassin El Mouden on 19/02/2024.
//

import Foundation
import SwiftUI

struct SafeAreaInsetsKey: PreferenceKey {
    static let defaultValue = EdgeInsets()
    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
        value = nextValue()
    }
}

extension View {
    func getSafeAreaInsets(_ safeInsets: Binding<EdgeInsets>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
            }
            .onPreferenceChange(SafeAreaInsetsKey.self) { value in
                safeInsets.wrappedValue = value
            }
            .background(Color.clear)
        )
    }
}

struct PaddingBottomScreen: ViewModifier {
    @State var bottomSafeArea: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom,bottomSafeArea == 0 ? 16 : 0)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            self.bottomSafeArea  = proxy.safeAreaInsets.bottom
                        }
                }
            )
    }
}

struct BottomScrollContentMarginModifier: ViewModifier {
    @Environment(\.bottomContentMargin) var margin


    func body(content: Content) -> some View {
        content
            .contentMargins(.bottom, margin + 16)

    }
}

struct BottomContentMarginModifier: ViewModifier {
    @Environment(\.bottomContentMargin) var margin


    func body(content: Content) -> some View {
        content
            .padding(.bottom, margin)

    }
}

private struct BottomScrollContentMargin: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

public extension EnvironmentValues {
    var bottomContentMargin: CGFloat {
        get { self[BottomScrollContentMargin.self] }
        set { self[BottomScrollContentMargin.self] = newValue }
    }
}

public extension View {
    func paddingBottomScreen() -> some View {
        modifier(PaddingBottomScreen())
    }

    func addBottomScrollContentMargin() -> some View {
        modifier(BottomScrollContentMarginModifier())
    }

    func addBottomContentMargin() -> some View {
        modifier(BottomContentMarginModifier())
    }
}


