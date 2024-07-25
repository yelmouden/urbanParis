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
                    .font(DSFont.grafTitle3)
                    .padding(.top, 10)
                    .padding(.bottom, Margins.verySmall)

                Text(menuViewModel.nickname)
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
                                .font(DSFont.grafTitle3)
                                .opacity(index == 0 ?  1 : 0.3)
                        }
                        .buttonStyle(.plain)

                        Button {
                            index = 1
                            showMenu = false
                        } label: {
                            Text("Mon profil")
                                .font(DSFont.grafTitle3)
                                .opacity(index == 1 ?  1 : 0.3)
                        }
                        .buttonStyle(.plain)


                        Button {
                            index = 2
                            showMenu = false
                        } label: {
                            Text(DocType.chart.title)
                                .font(DSFont.grafTitle3)
                                .opacity(index == 2 ?  1 : 0.3)
                        }
                        .buttonStyle(.plain)


                        Button {
                            index = 3
                            showMenu = false
                        } label: {
                            Text(DocType.organigrame.title)
                                .font(DSFont.grafTitle3)
                                .opacity(index == 3 ?  1 : 0.3)
                        }
                        .buttonStyle(.plain)

                        Button {
                            index = 4
                            showMenu = false
                        } label: {
                            Text("Paramètres")
                                .font(DSFont.grafTitle3)
                                .opacity(index == 4 ?  1 : 0.3)
                        }
                        .buttonStyle(.plain)


                    }
                }
                .scrollBounceBehavior(.basedOnSize)
                .zIndex(2)

                Spacer()


                ZStack {
                    SmokeManView(orientation: .right)
                        .offset(.init(width: -40, height: 0))

                    SmokeManView(orientation: .left)
                        .offset(.init(width: 80, height: 0))
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

