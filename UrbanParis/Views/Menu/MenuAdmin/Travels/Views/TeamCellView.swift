//
//  MemberTravelCellView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 27/12/2024.
//

import DesignSystem
import TravelMatchesFeature
import SwiftUI

struct TeamCellView: View {
    var viewModel: TeamCellViewModel
    let isSelected: Bool

    let didDelete: (Team) -> Void

    var body: some View {
        HStack {
            Text("\(viewModel.name)")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoBody)

            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundStyle(DSColors.success.swiftUIColor)
            }

            Spacer()

            if viewModel.stateView == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: DSColors.red.swiftUIColor))
                    .padding(Margins.mediumSmall)


            } else {
                Button(action: {
                    Task {
                        await viewModel.deleteTeam()
                        didDelete(viewModel.team)
                    }
                }) {
                    Text("supprimer")
                        .font(DSFont.robotoBody)
                        .foregroundStyle(DSColors.red.swiftUIColor)
                        .padding(Margins.small)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(DSColors.red.swiftUIColor, lineWidth: 2)
                        )
                }
            }
        }
    }
}
