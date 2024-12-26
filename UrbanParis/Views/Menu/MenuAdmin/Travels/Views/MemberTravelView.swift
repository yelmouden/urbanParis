//
//  MemberTravelView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import DesignSystem
import SwiftUI

struct MemberTravelView: View {
    var viewModel: MemberTravelViewModel

    var body: some View {
        HStack {
            Text("\(viewModel.fistname) \(viewModel.lastname)")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoBody)

            Spacer()

            if viewModel.stateView == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: DSColors.red.swiftUIColor))
                    .padding(Margins.mediumSmall)


            } else {
                if viewModel.isValidated {
                    Button(action: {
                        Task {
                            await viewModel.handleValidation()
                        }

                    }) {
                        Text("Validé")
                            .foregroundStyle(DSColors.success.swiftUIColor)
                            .padding(Margins.mediumSmall)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(DSColors.success.swiftUIColor, lineWidth: 2)
                            )
                    }
                } else {
                    Button(action: {
                        Task {
                            await viewModel.handleValidation()
                        }
                    }) {
                        Text("Non validé")
                            .foregroundStyle(DSColors.red.swiftUIColor)
                            .padding(Margins.mediumSmall)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(DSColors.red.swiftUIColor, lineWidth: 2)
                            )
                    }
                }
            }
        }
    }
}
