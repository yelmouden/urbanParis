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

    @State private var email = ""
    @State var password: String = ""
    @State var isValidPassword = false

    @State private var task: Task<Void, Never>?

    @Bindable private var  viewModel: SignUpViewModel

    public init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        
        ZStack(alignment: .top) {
            let bgImage = ConfigurationReader.isUrbanApp ? "graphUP" : "fumiTribune"

            BackgroundImageContainerView(nameImages: [bgImage], bundle: Bundle.module) {
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

                            PasswordFieldView(password: $password, isValidPassword: $isValidPassword)
                                .padding(.bottom, Margins.extraLarge)
                        }
                        
                    }


                    Spacer()

                    VStack {

                        FWButton(
                            title: "Rejoindre maintenant",
                            state: viewModel.signUpState.toFWButtonState(),
                            action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                                task = Task {
                                    do {
                                        try await Task.sleep(for: .seconds(0.4))
                                        await viewModel.signUp(email: email, password: password)
                                    } catch {}

                                }
                                
                            })
                        .enabled(email.isValidEmail() && isValidPassword)
                        .fwButtonStyle(.primary)
                        .addSensoryFeedback()
                        .padding(.bottom, Margins.small)
                    }
                }

            }
        }
        .addBackButton {
            task?.cancel()

            navigator.pop()
        }
        .showBanner($viewModel.showError, text: viewModel.errorText, type: .error)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Creer un compte")
    }
}

