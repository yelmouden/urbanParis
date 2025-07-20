//
//  CotisationsMemberDetails.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 29/11/2024.
//

import DesignSystem
import FlowStacks
import SharedResources
import SwiftUI
import Utils

struct CotisationsMemberDetails: View {
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    @State var viewModel: CotisationsMemberDetailsViewModel

    init(viewModel: CotisationsMemberDetailsViewModel) {
        self._viewModel = .init(initialValue: viewModel)
    }

    var body: some View {
        BackgroundImageContainerView(
            nameImages: [],
            bundle: Bundle.main,
            colors: [DSColors.background.swiftUIColor]
        )
        {
            VStack {
                Text(viewModel.cotisationsMember.firstname)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoLargeTitle)

                Text(viewModel.cotisationsMember.lastname)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoLargeTitle)
                    .padding(.bottom, Margins.mediumSmall)

                FWScrollView {
                    VStack {
                        ForEach($viewModel.cotisations, id: \.month) { $cotisation in
                            HStack {
                                Text("Mois de \(cotisation.month)")
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .font(DSFont.robotoBody)

                                Spacer()

                                TextField("", text: $cotisation.amountText)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .frame(width: 60, height: 30, alignment: .center)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(DSColors.red.swiftUIColor, lineWidth: 1)
                                    )
                                    .keyboardType(.decimalPad)
                                    .onChange(of: cotisation.amountText) { _, newValue in
                                        var value = newValue
                                        value.formattedDecimalText()
                                        cotisation.amountText = value
                                    }
                            }
                            .padding(.bottom, Margins.medium)
                        }
                    }

                }

                Spacer()

                FWButton(title: "enregistrer") {
                    Task {
                        await viewModel.save()
                    }
                }
                .enabled(viewModel.isEnabled)
                .fwButtonStyle(.primary)
            }
        }
        .addBackButton {
            navigator.pop()
        }
        .showBanner($viewModel.showSuccess, text: "Cotisations sauvegardées", type: .success)
        .showBanner($viewModel.showError, text: "Une erreur s'est produite", type: .error)

    }
}


