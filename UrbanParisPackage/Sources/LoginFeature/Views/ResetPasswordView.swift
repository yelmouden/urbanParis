//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 29/06/2024.
//

import DesignSystem
import SharedResources
import SwiftUI
import Utils

public struct ResetPasswordView: View {
   @Bindable var viewModel: ResetPasswordViewModel

    @State var password = ""
    @State var confirmedPassword = ""
    @State var isValidPassword = false
    @State var task: Task<Void, Never>?

    @Binding var presented: Bool


    public init(presented: Binding<Bool>, viewModel: ResetPasswordViewModel) { self.viewModel = viewModel
        self._presented = presented
    }

    public var body: some View {
        NavigationStack {
            BackgroundImageContainerView(nameImages: ["parc"], bundle: .module) {
                VStack {
                    FWScrollView {
                        VStack(alignment: .leading, spacing: Margins.extraLarge) {
                            PasswordFieldView(password: $password, isValidPassword: $isValidPassword)
                                .padding(.top, Margins.medium)

                            FWTextField(
                                title: "Confirme ton mot de passe",
                                placeholder: "Resaisis à nouveau le mot de passe",
                                isSecure: true,
                                text: $confirmedPassword
                            )
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                        }
                    }
                    Spacer()

                    FWButton(
                        title: "Valider",
                        state: viewModel.state.toFWButtonState()
                    ) {
                        task = Task {
                            if await viewModel.resetPassword(password: password) {
                                presented = false

                            }
                        }
                    }
                    .enabled(isValidPassword && confirmedPassword == password)
                    .fwButtonStyle(.primary)
                    .paddingBottomScreen()
                    .addSensoryFeedback()
                }

            }

            .navigationTitle("Réinitialiser mot de passe")
            .navigationBarTitleDisplayMode(.large)
            .interactiveDismissDisabled()
            .showBanner($viewModel.showError, text: viewModel.errorText, type: .error)

        }

    }
}


