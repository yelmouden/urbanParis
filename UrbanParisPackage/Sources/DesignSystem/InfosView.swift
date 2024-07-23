//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 27/02/2024.
//

import SwiftUI
import Utils

public struct InfosView: View {
    let text: String
    let closable: Bool
    let onClose: (() -> Void)?

    public init(
        text: String,
        closable: Bool = false,
        onClose: (() -> Void)? = nil
    ) {
        self.text = text
        self.closable = closable
        self.onClose = onClose
    }

    public var body: some View {
        
        HStack(alignment: .top) {
            Image(systemName: "info.circle")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .padding(Margins.medium)
            Text(text)
                .multilineTextAlignment(.leading)
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoSubHeadline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(closable ? [.top, .bottom] : [.top, .bottom, .trailing], Margins.medium)

            Spacer()

            if closable {
                Button(action: {
                    onClose?()
                }, label: {
                   Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(DSColors.white.swiftUIColor)

                })
                .padding(Margins.medium)
                .addSensoryFeedback()
            }
        }
        .background(DSColors.red.swiftUIColor)
        .cornerRadius(20)

    }
}
