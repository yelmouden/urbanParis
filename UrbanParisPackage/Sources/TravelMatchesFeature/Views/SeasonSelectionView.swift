//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 28/07/2024.
//

import Foundation
import DesignSystem
import SwiftUI

struct SeasonSelectionView: View {
    let seasons: [Season]

    @Binding var selectedSeaons: Season?

    var body: some View {
        VStack {
            Text("Séléctionnes une saison")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.grafTitle3)

            ScrollView {
                ZStack {
                    Spacer().containerRelativeFrame([.vertical])
                    ForEach(seasons) { season in
                        HStack {
                            Spacer()

                            Button(action: {
                                selectedSeaons = season
                                PopupManager.shared.dismiss()
                            }, label: {
                                Text("\(season.title)")
                                    .foregroundStyle(DSColors.red.swiftUIColor)
                            })
                            .buttonStyle(.plain)

                            Spacer()
                        }

                    }
                }

            }

            Spacer()

            FWButton(title: "Annuler") {
                PopupManager.shared.dismiss()
            }
            .fwButtonStyle(.primary)
        }
        .padding()
        .background(DSColors.background.swiftUIColor)
        .addBorder(DSColors.red.swiftUIColor, cornerRadius: 20)
        .padding(Margins.extraLarge)
        .frame(height: 300)
    }
}
