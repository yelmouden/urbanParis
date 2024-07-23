//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 19/07/2024.
//

import DesignSystem
import FlowStacks
import SwiftUI
import Utils

public struct SignInView: View, KeyboardReadable {
    @EnvironmentObject var navigator: FlowNavigator<LoginScreen>

    @State var email: String = ""
    @State var password: String = ""
    @State var isValidPassword = false

    @State var task: Task<Void, Never>?

    @Bindable var viewModel: SignInViewModel

    public var body: some View {
        let bgImage = ConfigurationReader.isUrbanApp ? "telesco" : "coursive"
        let colors = [DSColors.black.swiftUIColor.opacity(ConfigurationReader.isUrbanApp ? 0.4 : 0.7), DSColors.background.swiftUIColor]

        BackgroundImageContainerView(nameImages: [bgImage], bundle: Bundle.module, colors: colors) {
            VStack {
                FWScrollView {
                    VStack {

                        FWTextField(
                            title: "Ton email",
                            placeholder: "Saisis ton email",
                            text: $email
                        )
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(.top, Margins.medium)
                        .padding(.bottom, Margins.mediumSmall)


                        FWTextField(
                            title: "Ton mot de passe",
                            placeholder: "Saisis ton mot de passe",
                            isSecure: true,
                            text: $password
                        )
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(.bottom, Margins.extraLarge)

                        HStack {
                            Spacer()

                            FWButton(
                                title: "J'ai oublié mon mot de passe",
                                action: {
                                    navigator.push(.forgotPassword(.init()))
                                })
                            .addSensoryFeedback()
                        }
                        .padding(.bottom, Margins.small)

                    }
                }



                Spacer()
                
                VStack {

                    FWButton(
                        title: "Se connecter",
                        state: viewModel.state.toFWButtonState(),
                        action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                            task = Task {
                                do {
                                    try await Task.sleep(for: .seconds(0.4))
                                    await viewModel.signIn(email: email, password: password)
                                } catch {}

                            }
                        })
                    .enabled(email.isValidEmail() && !password.isEmpty)
                    .fwButtonStyle(.primary)
                    .addSensoryFeedback()
                    .padding(.bottom, Margins.small)

                }
            }
        }
        .addBackButton {
            task?.cancel()
            navigator.pop()
        }
        .showBanner($viewModel.showError, text: viewModel.errorText, type: .error)
        .navigationTitle("Se connecter")
        .navigationBarTitleDisplayMode(.large)
    }
}

