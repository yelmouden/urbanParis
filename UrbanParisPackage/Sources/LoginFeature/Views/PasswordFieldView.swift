//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 29/06/2024.
//

import DesignSystem
import SwiftUI

struct PasswordFieldView: View {
    @State var passwordValidations: [PasswordValidation] = []
    @Binding var password: String
    @Binding var isValidPassword: Bool

    var body: some View {
        VStack {
            FWTextField(
                title: "Ton mot de passe",
                placeholder: "Saisi ton mot de passe",
                isSecure: true,
                text: $password
            )
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.bottom, Margins.small)

            ForEach(PasswordValidation.allCases) { item in
                HStack {
                    if passwordValidations.contains(item) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(DSFont.robotoCaption1)
                            .foregroundStyle(DSColors.success.swiftUIColor)
                            .transition(.movingParts.flip)
                    } else {
                        Image(systemName: "checkmark.circle")
                            .font(DSFont.robotoCaption1)
                            .foregroundStyle(DSColors.white.swiftUIColor)
                            .transition(.movingParts.flip)
                    }

                    Text(item.title)
                        .font(DSFont.robotoCaption1)
                        .foregroundStyle(passwordValidations.contains(item) ? DSColors.success.swiftUIColor : DSColors.white.swiftUIColor)
                    Spacer()
                }
            }
        }
        .animation(.default, value: passwordValidations)
        .onChange(of: password, { _, newValue in
            passwordValidations = newValue.hasValidPassword()
            isValidPassword = passwordValidations.count == PasswordValidation.allCases.count
        })

    }
}
