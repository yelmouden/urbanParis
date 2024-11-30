//
//  MenuView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import DesignSystem
import PDFFeature
import SwiftUI
import Utils

@MainActor
struct MenuView: View {
    @Binding var index: Int
    @State var menuViewModel = MenuViewModel()
    @Binding var showMenu: Bool

    var body: some View {
        HStack{
            ZStack(alignment: .bottom) {

                ZStack {
                    SmokeManView(orientation: .right)
                        .offset(.init(width: -40, height: 0))

                    SmokeManView(orientation: .left)
                        .offset(.init(width: 80, height: 0))
                }
                .zIndex(0)

                VStack {
                    let image =  ConfigurationReader.isUrbanApp ? Image("urbanHead")
                    : Image("letters")

                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: 80,
                            height: 80)

                    Text("Salut")
                        .foregroundStyle(DSColors.white.swiftUIColor)
                        .font(DSFont.grafTitle3)
                        .padding(.top, 10)
                        .padding(.bottom, Margins.verySmall)

                    Text(menuViewModel.nickname)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                        .font(DSFont.grafTitle3)

                    Divider()
                        .frame(width: 50)
                        .frame(height: 4)
                        .overlay(.white)
                        .padding(.bottom, Margins.extraLarge)

                    ScrollView {
                        VStack(alignment: .leading, spacing: Margins.medium) {
                            Button {
                                index = 0
                                showMenu = false
                            } label: {
                                Text("Cotisations")
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .font(DSFont.grafTitle3)
                                    .opacity(index == 0 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)

                            Button {
                                index = 1
                                showMenu = false
                            } label: {
                                Text("Deplacements")
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .font(DSFont.grafTitle3)
                                    .opacity(index == 1 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)

                            Button {
                                index = 2
                                showMenu = false
                            } label: {
                                Text("Matos")
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .font(DSFont.grafTitle3)
                                    .opacity(index == 2 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)

                            Button {
                                index = 3
                                showMenu = false
                            } label: {
                                Text("Mon profil")
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .font(DSFont.grafTitle3)
                                    .opacity(index == 3 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)


                            Button {
                                index = 4
                                showMenu = false
                            } label: {
                                Text(DocType.chart.title)
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .font(DSFont.grafTitle3)
                                    .opacity(index == 4 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)


                            Button {
                                index = 5
                                showMenu = false
                            } label: {
                                Text(DocType.organigrame.title)
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .font(DSFont.grafTitle3)
                                    .opacity(index == 5 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)

                            Button {
                                index = 6
                                showMenu = false
                            } label: {
                                Text("Parametres")
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .font(DSFont.grafTitle3)
                                    .opacity(index == 6 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)

                            if menuViewModel.shouldDisplayAdminEnty {
                                Button {
                                    index = 7
                                    showMenu = false
                                } label: {
                                    Text("Admin")
                                        .foregroundStyle(DSColors.white.swiftUIColor)
                                        .font(DSFont.grafTitle3)
                                        .opacity(index == 7 ?  1 : 0.3)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .zIndex(1)

                    Spacer(minLength: 150)
                }
            }
            .frame(maxWidth: (UIScreen.main.bounds.width / 2) - 20, alignment: .leading)

            .background(DSColors.red.swiftUIColor)
            .padding(.top,25)
            .padding(.horizontal,20)

            Spacer(minLength: 0)
        }
    }
}

