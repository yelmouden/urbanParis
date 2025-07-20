//
//  AddInfoInputView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 27/12/2024.
//

import DesignSystem
import SwiftUI

struct AddSeasonInfoInputView: View {
    @State var season = ""
    public var tapAdd: (String) -> Void
    @FocusState private var focused: Bool
    @State var isValideSeason: Bool = false

    var body: some View {
        VStack {
            FWTextField(
                title: "Ajouter une saison",
                placeholder: "(format : YYYY/YYYY)",
                isFocus: _focused,
                text: $season
            )
            .autocorrectionDisabled()
            .keyboardType(.numbersAndPunctuation)
            .padding(.bottom, Margins.large)
            .onChange(of: season) { _, newValue in
                validateSeasonFormat()
            }

            FWButton(title: "Valider") {
                PopupManager.shared.dismiss()
                tapAdd(season)
            }
            .enabled(isValideSeason)
            .fwButtonStyle(.primary)

            FWButton(title: "Annuler") {
                PopupManager.shared.dismiss()

            }
            .fwButtonStyle(.secondary)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                focused = true
            }
        }
        .padding()
        .background(DSColors.background.swiftUIColor)
        .addBorder(DSColors.red.swiftUIColor, cornerRadius: 20)
        .padding(Margins.extraLarge)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .zIndex(2)
    }

    /// Validate that the season is in the correct format YYYY/YYYY
    private func validateSeasonFormat() {
        let components = season.split(separator: "/")

        if components.count == 2,
           components[0].count == 4,
           components[1].count == 4,
           let startYear = Int(components[0]),
           let endYear = Int(components[1]),
           startYear + 1 == endYear {
            isValideSeason = true
        } else {
            isValideSeason = false
        }
    }
}
