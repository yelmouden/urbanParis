//
//  AddSeasonInfoInputView 2.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 27/12/2024.
//

import DesignSystem
import SwiftUI

struct AddTeamInfoInputView: View {
    @State var team = ""
    public var tapAdd: (String) -> Void
    @FocusState private var focused: Bool

    var body: some View {
        VStack {
            FWTextField(
                title: "Ajouter une equipe",
                placeholder: "nom équipe",
                isFocus: _focused,
                text: $team
            )
            .keyboardType(.numberPad)
            .padding(.bottom, Margins.large)
            FWButton(title: "Valider") {
                PopupManager.shared.dismiss()
                tapAdd(team)
            }
            .enabled(!team.isEmpty)
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
}
