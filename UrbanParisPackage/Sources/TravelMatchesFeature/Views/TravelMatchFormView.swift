//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 10/08/2024.
//

import DesignSystem
import FlowStacks
import SwiftUI
import Utils

struct TravelMatchFormView: View {
    @EnvironmentObject var navigator: FlowNavigator<TravelMatchesScreen>

    @State var task: Task<Void, Never>?

    @Bindable var viewModel: TravelMatchFormViewModel

    let onSubscribeSucceeded: () -> Void

    var body: some View {
        BackgroundImageContainerView(nameImages: ["fumis"], bundle: .module) {
            VStack {
                HStack {
                    Spacer()
                    Text("Déplacement \(viewModel.travel.team.name)")
                        .foregroundStyle(DSColors.white.swiftUIColor)
                        .font(DSFont.robotoTitle)
                        .padding(.top, Margins.large)
                        .padding(.bottom, Margins.medium)
                    Spacer()

                }

                FWScrollView {
                    VStack(alignment: .leading, spacing: Margins.extraLarge) {
                        HStack {
                            Text("Prenom:")
                                .font(DSFont.grafHeadline)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(viewModel.profile.firstname)
                                .font(DSFont.robotoTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)
                        }
                        .padding(.top, Margins.medium)

                        HStack {
                            Text("Nom:")
                                .font(DSFont.grafHeadline)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(viewModel.profile.lastname)
                                .font(DSFont.robotoTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)
                        }

                        HStack {
                            Text("Email:")
                                .font(DSFont.grafHeadline)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(viewModel.user?.email ?? "")
                                .font(DSFont.robotoTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)
                        }

                        HStack {
                            Text("Groupe:")
                                .font(DSFont.grafHeadline)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text("Urban")
                                .font(DSFont.robotoTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)
                        }

                        HStack {
                            SelectableViews(title: "Deplacement en bus", items: [TravelMatchCarResponse.No, TravelMatchCarResponse.Yes], selectedItem: $viewModel.carResponse)
                                .padding(.bottom, Margins.extraLarge)

                            Spacer()
                        }
                        
                    }
                }

                Spacer()

                FWButton(title: "Valider", state: viewModel.state.toFWButtonState()) {
                    task = Task {
                        if await viewModel.register() {
                            onSubscribeSucceeded()
                            
                            do {
                                try await Task.sleep(for: .milliseconds(600))
                                navigator.dismiss()
                            } catch {

                            }
                        }

                    }
                }
                .enabled(viewModel.carResponse != nil)
                .fwButtonStyle(.primary)
            }
            .addBackButton(isPresented: true) {
                navigator.dismiss()
            }
        }
        .onDisappear {
            task?.cancel()
        }
        .showBanner($viewModel.showError, text: viewModel.errorText, type: .error)
        .navigationTitle("Inscription")
    }
}
