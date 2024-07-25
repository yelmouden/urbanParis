//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 25/07/2024.
//

import DesignSystem
import FlowStacks
import Pow
import SwiftUI
import Utils

struct CotisationsView: View {
    @EnvironmentObject var navigator: FlowNavigator<CotisationsScreen>

    let viewModel: CotisationsViewModel

    var body: some View {
        BackgroundImageContainerView(
            nameImages: ["street"],
            bundle: Bundle.module
        )
        {
            VStack {
                FWScrollView {
                    ListStateView(
                        stateView: viewModel.state,
                        idleView: { EmptyView() },
                        loadingView: {
                            VStack {
                                Text("Montant total restant")
                                    .font(DSFont.robotoTitle)
                                    .padding(.top, Margins.large)
                                    .padding(.bottom, Margins.verySmall)

                                SkeletonLoadingView(height: 80)
                                    .frame(width: 80)
                                    .padding(.bottom, Margins.large)


                                ForEach(0..<10, id: \.self) { _ in
                                    SkeletonLoadingView(height: 20)
                                        .padding(.bottom, Margins.medium)
                                }

                            }

                        },
                        loadedView: { cotisations in
                            //ScrollView {
                            VStack {
                                Text("Montant total restant")
                                    .font(DSFont.robotoTitle)
                                    .padding(.top, Margins.large)
                                    .padding(.bottom, Margins.verySmall)

                                Text(cotisations.totalAmount.amountText)
                                    .font(DSFont.robotoExtraLargeTitle)
                                    .padding(.bottom, Margins.mediumSmall)
                                    .id(cotisations.totalAmount)
                                    .transition(
                                        .identity
                                            .animation(.linear(duration: 2).delay(2))
                                            .combined(
                                                with: .movingParts.anvil
                                            )
                                    )

                                LazyVStack {
                                    ForEach(cotisations) { cotisation in
                                        HStack {
                                            Text("Reste à payer mois de \(cotisation.titleMonth)")
                                                .font(DSFont.robotoBody)

                                            Spacer()

                                            if cotisation.isPaid {
                                                Text("Payée")
                                                    .font(DSFont.robotoBodyBold)
                                                    .foregroundStyle(DSColors.success.swiftUIColor)
                                                    .padding(Margins.small)
                                                    .addBorder(DSColors.success.swiftUIColor, cornerRadius: 8)
                                                    .transition(.blurReplace)
                                            } else {
                                                Text(cotisation.amount.amountText)
                                                    .font(DSFont.robotoBodyBold)
                                                    .foregroundStyle(DSColors.red.swiftUIColor)
                                                    .padding(Margins.small)
                                                    .addBorder(DSColors.red.swiftUIColor, cornerRadius: 8)
                                                    .transition(.blurReplace)
                                            }
                                        }
                                        .padding(.bottom, Margins.medium)
                                    }
                                }


                            }

                            //}

                        },
                        emptyView: {
                            EmptyView()
                        }
                    )
                }
                .refreshable {
                    await viewModel.retrieveCotisations()
                }
                Spacer()

                FWButton(title: "Régler ma cotisation") {
                    navigator.presentSheet(.paypal)
                }
                .fwButtonStyle(.primary)
            }


            /*.addBottomScrollContentMargin()
             .refreshable {
             onAppearTask?.cancel()
             onVisibleTask?.cancel()
             await viewModel.retrieveActivityReports(isFromResfresh: true)
             }
             .toolbarAddButton {
             navigator.presentSheet(.configuration(viewModel: .init()), embedInNavigationView: true)
             }
             .onAppear {
             onAppearTask = Task {
             await viewModel.retrieveActivityReports()
             }
             }
             .onVisibilityChange { isVisible in
             if isVisible {
             onVisibleTask = Task {
             await viewModel.retrieveActivityReports()
             }
             }
             }*/
        }
        .animation(.default, value: viewModel.state)
        .task {
            await viewModel.retrieveCotisations()
        }
        .navigationTitle("Mes cotisations")
    }
}


