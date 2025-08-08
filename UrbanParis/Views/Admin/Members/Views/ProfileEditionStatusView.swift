//
//  ProfileEditionStatusView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 17/07/2025.
//

import DesignSystem
import FlowStacks
import SharedModels
import SharedResources
import SwiftUI

struct ProfileEditionStatusView: View {
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    @Bindable var viewModel: ProfileEditionStatusViewModel

    var body: some View {
        BackgroundImageContainerView(
            nameImages: [],
            bundle: Bundle.main,
            colors: [DSColors.background.swiftUIColor]
        ) {
            VStack(spacing: Margins.medium) {
                VStack(spacing: Margins.medium) {
                    Spacer()

                    ForEach(Array(viewModel.viewDatas.enumerated()), id: \.element.title) { index, viewData in
                        Button {
                            viewModel.didSelect(index: index)
                        } label: {
                            HStack {
                                Text(viewData.title)
                                    .font(DSFont.robotoTitle3)
                                    .foregroundStyle(DSColors.white.swiftUIColor)

                                Spacer()

                                if viewData.isSelected {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(DSColors.red.swiftUIColor)
                                }
                            }
                        }
                        .addSensoryFeedback()
                    }
                }

                Spacer()

                FWButton(
                    title: "Confirmer",
                    state: viewModel.state.toFWButtonState(),
                    action: {
                        viewModel.save() { [weak navigator] in
                            navigator?.dismiss()
                        }
                    })
                .enabled(viewModel.canSave)
                //.enabled(email.isValidEmail() && !password.isEmpty)
                .fwButtonStyle(.primary)
                .addSensoryFeedback()
                .padding(.bottom, Margins.small)
            }

        }
        .showBanner($viewModel.showError, text: SharedResources.commonErrorText, type: .error)
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.visible)
    }
}
