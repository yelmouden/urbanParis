//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 18/04/2024.
//

import SwiftUI

public struct FWTextEditor: View {
    let placeholder: String
    @Binding var text: String

    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text(placeholder)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .opacity(0.4)
                    Spacer()
                }
            }

            VStack {
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden) // <- Hide it
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoBody)
                    .frame(minHeight: 80)
                    .addBorder(DSColors.red.swiftUIColor, cornerRadius: 12)
                    .opacity(text.isEmpty ? 0.85 : 1)
                    .frame(height: 200)
                Spacer()
            }
        }
    }
}
