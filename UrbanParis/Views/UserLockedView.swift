//
//  UserLockedView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 31/07/2024.
//

import DesignSystem
import SwiftUI

struct UserLockedView: View {
    var body: some View {
        BackgroundImageContainerView(nameImages: ["apoula"], bundle: .main) {
            Text("Ton compte a été bloqué temporairement")
                .multilineTextAlignment(.center)
                .font(DSFont.robotoTitle)
                .foregroundStyle(DSColors.red.swiftUIColor)
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    UserLockedView()
}
