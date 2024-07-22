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

public struct SignUpView: View, KeyboardReadable {
    @EnvironmentObject var navigator: FlowNavigator<LoginScreen>

    @State var password: String = ""
    @State var isValidPassword = false
    @State var fakeState: FWButtonState = .idle
    @State var hideSocialSigin = false

    public init() {}

    public var body: some View {
        
        ZStack(alignment: .top) {
            let bgImage = ConfigurationReader.isUrbanApp ? "graphUP" : "fumiTribune"

            BackgroundImageContainerView(images: [imageFromPDF(named: bgImage, bundle: .module)]) {
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

                            PasswordFieldView(password: $password, isValidPassword: $isValidPassword)
                                .padding(.bottom, Margins.extraLarge)
                        }
                        
                    }


                    Spacer()

                    VStack {

                        FWButton(
                            title: "Rejoindre maintenant",
                            state: fakeState,
                            action: {
                                Task {
                                   fakeState = .loading
                                    try await Task.sleep(for: .seconds(1))
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
        }
        .addBackButton {
            navigator.pop()
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
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Créer un compte")
    }
}

