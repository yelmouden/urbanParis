//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 21/02/2024.
//

import DesignSystem
import SwiftUI
import Utils

struct LoginButton: View {

    let loginButtonType: LoginButtonButtonType
    let state: StateView<EmptyResource>
    let action: () -> Void

    var body: some View {
        FWButton(
            title: loginButtonType.title,
            state: state.toFWButtonState(),
            action: action
        ) {
            loginButtonType.image
                .resizable()
                .frame(width: 25, height: 25)
        }
        .fwButtonStyle(.secondary)
        .addSensoryFeedback()
    }
}

enum LoginButtonButtonType {
    case apple
    case google
    case facebook

    var image: Image {
        switch self {
        case .apple:
            return Assets.apple.swiftUIImage
        case .google:
            return Assets.google.swiftUIImage
        case .facebook:
            return Assets.facebook.swiftUIImage
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .apple:
            return  "Continuer avec Apple"
        case .google:
            return "Continuer avec Google"
        case .facebook:
            return "Continuer avec Facebook"
        }
    }
}
