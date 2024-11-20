//
//  AdminMenuView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 19/11/2024.
//

import DesignSystem
import FlowStacks
import SharedResources
import SwiftUI
import Utils

struct AdminMenuView: View {
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    var body: some View {
        BackgroundImageContainerView(
            nameImages: [],
            bundle: Bundle.main,
            colors: [DSColors.background.swiftUIColor]
        )
        {
            VStack(alignment: .leading, spacing: Margins.extraLarge) {
                Button(action: {
                    navigator.push(.members)
                }) {
                    HStack {
                        Text("Gestion des membres")
                            .foregroundStyle(DSColors.white.swiftUIColor)
                            .font(DSFont.robotoTitle3)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(DSColors.red.swiftUIColor)
                            .frame(width: 20, height: 20)
                    }
                }

                Button(action: {

                }) {
                    HStack {
                        Text("Gestion des cotisations")
                            .foregroundStyle(DSColors.white.swiftUIColor)
                            .font(DSFont.robotoTitle3)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(DSColors.red.swiftUIColor)
                            .frame(width: 20, height: 20)
                    }
                }

                Button(action: {

                }) {
                    HStack {
                        Text("Gestion des déplacements")
                            .foregroundStyle(DSColors.white.swiftUIColor)
                            .font(DSFont.robotoTitle3)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(DSColors.red.swiftUIColor)
                            .frame(width: 20, height: 20)
                    }
                }

                Button(action: {

                }) {
                    HStack {
                        Text("Gestion du matos")
                            .foregroundStyle(DSColors.white.swiftUIColor)
                            .font(DSFont.robotoTitle3)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(DSColors.red.swiftUIColor)
                            .frame(width: 20, height: 20)
                    }
                }

                Spacer()
            }
            .padding(.top, Margins.extraLarge)
        }
        .navigationTitle("Menu Admin")
    }
}

#Preview {
    AdminMenuView()
}
