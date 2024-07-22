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

    @State var password: String = ""
    @State var isValidPassword = false
    @State var fakeState: FWButtonState = .idle
    @State var hideSocialSigin = false

    public init() {}

    public var body: some View {
        let bgImage = ConfigurationReader.isUrbanApp ? "telesco" : "coursive"
        let colors = [DSColors.black.swiftUIColor.opacity(ConfigurationReader.isUrbanApp ? 0.4 : 0.7), DSColors.background.swiftUIColor]

        BackgroundImageContainerView(images: [imageFromPDF(named: bgImage, bundle: .module)], colors: colors) {
            VStack {

                FWScrollView {
                    VStack {

                        FWTextField(
                            title: "Ton email",
                            placeholder: "Saisis ton email",
                            text: .constant("")
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

                    }
                }

                Spacer()
                
                VStack {

                    FWButton(
                        title: "Se connecter",
                        state: fakeState,
                        action: {
                            Task {
                                fakeState = .loading
                                try await Task.sleep(for: .seconds(2))
                                fakeState = .success
                                try await Task.sleep(for: .seconds(1))
                                fakeState = .idle

                            }

                            /*task?.cancel()

                            task = Task {
                                await viewModel.signUp(email: email, password: password)
                            }*/
                        })
                    //.enabled(email.isValidEmail() && isValidPassword)
                    .fwButtonStyle(.primary)
                    .addSensoryFeedback()
                    .padding(.bottom, Margins.small)

                    if !hideSocialSigin {
                        HStack {
                            Rectangle()
                                .fill(DSColors.white.swiftUIColor)
                                .frame(height: 1)

                            Text("ou")
                                .font(DSFont.grafBody)

                            Rectangle()
                                .fill(DSColors.white.swiftUIColor)
                                .frame(height: 1)
                        }
                        .foregroundStyle(DSColors.white.swiftUIColor)
                        .padding(.bottom, Margins.medium)

                        LoginButton(loginButtonType: .apple, state: .idle/*viewModel.signWithAppleState*/) {
                            /*task?.cancel()

                            task = Task {
                                await viewModel.signInWithApple()
                            }*/
                        }

                        LoginButton(loginButtonType: .google, state: .idle /*viewModel.signWithGoogleState*/) {
                            /*task?.cancel()

                            task = Task {
                                await viewModel.signInWithGoogle()
                            }*/
                        }
                    }

                }
            }
        }
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            if newIsKeyboardVisible {
                hideSocialSigin = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        hideSocialSigin = newIsKeyboardVisible
                    }
                }
            }

        }
        .addBackButton {
            navigator.pop()
        }
        .navigationTitle("Se connecter")
        .navigationBarTitleDisplayMode(.large)
    }
}

