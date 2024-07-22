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

public struct EditProfileView: View, KeyboardReadable {
    @EnvironmentObject var navigator: FlowNavigator<ProfileScreen>

    @State var appearMen = false
    @State var fakeState: FWButtonState = .idle

    @State var year: Int = Date.currentYear

    @State var aboType: AboType?

    public init() {}

    public var body: some View {
        BackgroundImageContainerView(
            images: [
                imageFromPDF(named: "susic", bundle: .module),
                imageFromPDF(named: "rai", bundle: .module),
                imageFromPDF(named: "pauleta", bundle: .module),
                imageFromPDF(named: "sakho", bundle: .module),

                /*Assets.susic.name
                Assets.susic.swiftUIImage,
                Assets.rai.swiftUIImage,
                Assets.pauleta.swiftUIImage,
                //Assets.pastore.swiftUIImage,
                Assets.sakho.swiftUIImage*/
            ])
        {
            VStack {
                FWScrollView {
                    VStack(spacing: Margins.medium) {
                        FWTextField(
                            title: "Ton prénom",
                            placeholder: "Saissis ton prénom",
                            text: .constant("")
                        )
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .padding(.top, Margins.medium)

                        FWTextField(
                            title: "Ton nom",
                            placeholder: "Saisis ton nom",
                            text: .constant("")
                        )
                        .autocorrectionDisabled()


                        FWTextField(
                            title: "Ton surnom",
                            placeholder: "Saisis ton surnom",
                            text: .constant("")
                        )
                        .autocorrectionDisabled()


                        HStack {
                            VStack {
                                Text("Ton année d'entrée dans le groupe")
                                    .font(DSFont.grafHeadline)
                            }

                            Spacer()
                        }

                        HStack {
                            Button(action: {
                                year -= 1
                                year = max(2017, year)
                            }, label: {
                                Image(systemName: "chevron.left.circle.fill")
                                    .resizable()
                                    .foregroundStyle(DSColors.red.swiftUIColor)
                                    .frame(width: 30, height: 30)
                            })
                            .padding(.trailing, Margins.extraLarge)
                            .addSensoryFeedback()

                            Text(verbatim: "\(year)")
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Button(action: {
                                year += 1
                                year = min(year, Date.currentYear)
                            }, label: {
                                Image(systemName: "chevron.right.circle.fill")
                                    .resizable()
                                    .foregroundStyle(DSColors.red.swiftUIColor)
                                    .frame(width: 30, height: 30)
                            })
                            .padding(.leading, Margins.extraLarge)
                            .addSensoryFeedback()

                        }

                        SelectableViews(title: "Ton type d'abonnement au Parc", items: [AboType.aboPSG, .aboCUP, .none ], selectedItem: $aboType)
                            .padding(.bottom, Margins.extraLarge)

                    }
                }
                .zIndex(2)

                Spacer()

                VStack {
                    if appearMen {
                        HStack() {
                            SmokeManView(orientation: .right)

                            Spacer()

                            SmokeManView(orientation: .left)
                        }
                        .offset(.init(width: 0, height: 21))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }


                    FWButton(
                        title: "Valider",
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
                }

            }

        }
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            withAnimation {
                appearMen = !newIsKeyboardVisible
            }
        }
        .interactiveDismissDisabled()
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Créer ton profil")
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.bouncy(duration: 0.6)) {
                    appearMen = true
                }
            }
        }
    }
}
