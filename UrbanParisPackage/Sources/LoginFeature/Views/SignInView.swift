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

public struct SignInView: View {
    @EnvironmentObject var navigator: FlowNavigator<LoginScreen>

    @State var password: String = ""
    @State var isValidPassword = false
    @State var fakeState: FWButtonState = .idle

    public init() {}

    public var body: some View {
        ZStack(alignment: .top) {
            let bgImage = ConfigurationReader.isUrbanApp ? Assets.telesco.swiftUIImage : Assets.fumiTribune.swiftUIImage

            bgImage
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea(.all)

            LinearGradient(
                gradient: Gradient(
                    colors: [
                        DSColors.background.swiftUIColor.opacity(0.3),
                        DSColors.background.swiftUIColor
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)

            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        BackButton(isPresented: false) {
                            navigator.pop()
                        }
                        .padding(.bottom)

                        Text("Connection")
                            .font(DSFont.largeTitle)
                            .foregroundStyle(DSColors.white.swiftUIColor)
                    }

                    Spacer()
                }

                Spacer()

                FWScrollView {
                    VStack {

                        FWTextField(
                            title: "Ton email",
                            placeholder: "Saissis ton email",
                            text: .constant("")
                        )
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(.top, Margins.medium)
                        .padding(.bottom, Margins.mediumSmall)

                        FWTextField(
                            title: "Ton mot de passe",
                            placeholder: "Saissis ton mot de passe",
                            isSecure: true,
                            text: $password
                        )
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

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

                            HStack {
                                Rectangle()
                                    .fill(DSColors.white.swiftUIColor)
                                    .frame(height: 1)

                                Text("ou")
                                    .font(DSFont.body)

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
            .padding([.top, .leading, .trailing])
        }
        .background(DSColors.background.swiftUIColor)
        .navigationBarHidden(true)
    }
}

