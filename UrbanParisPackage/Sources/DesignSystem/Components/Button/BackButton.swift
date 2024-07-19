//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 29/04/2024.
//

import SwiftUI
import Utils

public struct BackButton: View {

    let isPresented: Bool
    let action: () -> Void

    public init(isPresented: Bool, action: @escaping () -> Void) {
        self.isPresented = isPresented
        self.action = action
    }

    public var body: some View {
        Button(action: action, label: {
            Image(systemName: isPresented  ? "xmark.circle.fill" : "arrow.backward.circle.fill")
                .resizable()
                .foregroundStyle(DSColors.red.swiftUIColor)
                .frame(width: 30, height: 30)
        })
        .addSensoryFeedback()
    }
}

struct BackButtonModifier: ViewModifier {
    let isPresented: Bool
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton(isPresented: isPresented, action: action)
                }
            }
    }
}

public extension View {
    func addBackButton(isPresented: Bool = false, action: @escaping () -> Void) -> some View {
        modifier(BackButtonModifier(isPresented: isPresented, action: action))
    }
}
