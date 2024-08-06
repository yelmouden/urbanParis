//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 05/08/2024.
//

import DesignSystem
import FlowStacks
import SDWebImageSwiftUI
import SharedRepository
import SwiftUI

struct MatosView: View {
    @EnvironmentObject var navigator: FlowNavigator<MatosScreen>

    let matos: Matos

    @State var urlImgs: [URL] = []
    @State var width: CGFloat = 0

    @State var isLoading = false
    @State var isLoaded = false

    var body: some View {
        ZStack {
            Color.clear
                .background {
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                width = proxy.size.width
                            }
                    }
                }

            VStack {
                if urlImgs.isEmpty {
                    SkeletonLoadingView(height: 250, shapeType: .rectangle)
                        .frame(width: width, height: 250)
                } else {
                    TabView {
                        ForEach(Array(zip(urlImgs.indices, urlImgs)), id: \.0) { index, url in
                            WebImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                SkeletonLoadingView(height: 250, shapeType: .rectangle)
                                    .frame(width: width, height: 250)
                            }
                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                            .frame(width: width, height: 250)
                            .padding(.top, Margins.small)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                            .indexViewStyle(.page(backgroundDisplayMode: .automatic))
                            .frame(width: width, height: 250)

                }

                VStack {
                    if let description = matos.description {
                        HStack {
                            Text(description)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(DSFont.robotoBody)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()
                        }

                        Divider()
                            .frame(width: 100, height: 2)
                            .overlay(DSColors.white.swiftUIColor)
                            .padding(.top, Margins.small)
                            .padding(.bottom, Margins.medium)


                    }

                    if let price = matos.price {
                        HStack {
                            Text("Prix:")
                                .font(DSFont.robotoBody)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(price.amountText)
                                .font(DSFont.robotoBodyBold)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                        }
                        .padding(.bottom, Margins.medium)
                    }

                    if !matos.sizes.isEmpty {
                        HStack {
                            Text("Tailles dispo:")
                                .font(DSFont.robotoBody)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(matos.sizes.map(\.rawValue).joined(separator: ", "))
                                .font(DSFont.robotoBodyBold)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                        }
                        .padding(.bottom, Margins.medium)
                    }

                    if let date = matos.limitDate {
                        HStack {
                            Text("Date limite:")
                                .font(DSFont.robotoBody)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(date)
                                .font(DSFont.robotoBodyBold)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                        }
                        .padding(.bottom, Margins.medium)
                    }

                    if let link = matos.link {
                        FWButton(title: "Accéder au listing") {
                            navigator.presentSheet(.subscribe, withNavigation: true)
                        }
                        .fwButtonStyle(.primary)
                    }
                }
                .padding(Margins.small)

            }
        }
        .addBorder(DSColors.red.swiftUIColor, cornerRadius: 12)
        .frame(maxWidth: .infinity)
        .task {
            if !isLoading {
                isLoading = true
                self.urlImgs = await matos.retrieveImages(width: Int(width), height: 250)
            }
        }
    }
}

