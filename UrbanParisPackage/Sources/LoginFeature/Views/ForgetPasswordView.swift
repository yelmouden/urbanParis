//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 26/02/2024.
//

import SharedResources
import DesignSystem
import FlowStacks
import Pow
import SwiftUI
//import TrackingManager
import Utils

struct ForgetPasswordView: View {
    @EnvironmentObject var navigator: FlowNavigator<LoginScreen>
    @Bindable var viewModel: ForgetPasswordViewModel

    @State var email = ""
    @State var task: Task<Void, Never>?

    var body: some View {
        BackgroundImageContainerView(nameImages: ["blueFumis"], bundle: .module) {
            FWScrollView {
                VStack {
                    getForgottenPasswordView()
                }
            }
            .navigationTitle(String(localized: "Mot de passe oublié"))
            .navigationBarTitleDisplayMode(.large)
            .addBackButton {
                task?.cancel()

                navigator.pop()
            }
        }
        .showBanner($viewModel.showError, text: viewModel.errorText, type: .error)
        //.trackingOnAppear(screen: "Forget Password")
    }

    @ViewBuilder
    func getForgottenPasswordView() -> some View {
        VStack {
            VStack(alignment: .leading, spacing: Margins.extraLarge) {
                Text("Saisi l'adresse email utilisée lors de la création de ton compte ")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(DSFont.robotoHeadline)
                    .foregroundStyle(DSColors.gray.swiftUIColor)
                    .padding(.top, Margins.medium)

                FWTextField(
                    title: "Ton email",
                    placeholder: "Saisi ton email",
                    text: $email
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

                InfosView(text: "Tu recevras un mail t'invitant à réinitialiser ton mot de passe.\nOuvre le mail depuis ton téléphone en mettant l'appli en tâche de fond")
            }

            Spacer()

            FWButton(
                title: "Valider",
                state: viewModel.state.toFWButtonState())
            {
                task = Task {
                    await viewModel.resendPassword(email: email)
                }
            }
            .enabled(email.isValidEmail())
            .fwButtonStyle(.primary)
            .paddingBottomScreen()
            .addSensoryFeedback()
        }
    }
}
