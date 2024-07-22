//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 26/02/2024.
//

import AnimateText
import DesignSystem
import FlowStacks
import SharedResources
import Pow
import SwiftUI
import Utils

public struct WelcomeView: View {
    //@State var animateDisappear = false
    @EnvironmentObject var navigator: FlowNavigator<LoginScreen>

    let viewModel: WelcomeViewModel

    @State var animate = false
    @State var buttonAppear = false

    @State var text: String = ""

    public init(/*viewModel: WelcomeViewModel*/) {
        self.viewModel = .init()
    }

    public var body: some View {
        MainContainer {
            ZStack(alignment: .top) {
                VStack {
                    HStack {
                        if animate {
                            Assets.stickerParisParc.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(
                                    width: 300)
                                .offset(CGSize(width: -120, height: -50))
                                .rotationEffect(.degrees(-40))
                                .transition(.movingParts.wipe(
                                            angle: .degrees(-30),
                                            blurRadius: 50
                                          ))
                        }
                        Spacer()
                    }

                    HStack {
                        if animate {
                            Spacer()

                            Assets.sitckVA.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(
                                    width: 200)
                                .offset(CGSize(width: 125, height: 50))
                                .rotationEffect(.degrees(-100))
                                .transition(.movingParts.wipe(
                                            angle: .degrees(-30),
                                            blurRadius: 50
                                          ))
                        }
                    }


                    Spacer()

                   /* HStack {
                        if animate {
                            Assets.stickFumi.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(
                                    width: 300)
                                .offset(CGSize(width: -100, height: 70))
                                .rotationEffect(.degrees(45))
                                .transition(.movingParts.wipe(
                                            angle: .degrees(-50),
                                            blurRadius: 50
                                          ))

                        }

                        Spacer()

                    }*/



                    Spacer()
                }


                VStack {

                    ZStack {

                        VStack {
                            Spacer()

                            let image =  ConfigurationReader.isUrbanApp ? Assets.urbanHead.swiftUIImage
                            : Assets.upLetters.swiftUIImage

                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(
                                    width: ConfigurationReader.isUrbanApp ? 300 : 250,
                                    height: ConfigurationReader.isUrbanApp ? 300: 250)

                            AnimateText<ATChimeBellEffect>($text, type: .words)
                                .font(DSFont.grafTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)
                                .offset(CGSize(width: 0, height: ConfigurationReader.isUrbanApp ? -50 : -15))

                            Spacer()
                        }

                        if animate {
                            Assets.stickerUltras.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(
                                    width: 250)
                                .offset(CGSize(width: 20, height: 200))
                                .rotationEffect(.degrees(10))
                                .transition(.movingParts.wipe(
                                            angle: .degrees(-35),
                                            blurRadius: 50
                                          ))

                        }
                    }


                    Spacer()

                    if buttonAppear {
                        VStack {
                            FWButton(
                                title: "Se connecter",
                                action: {
                                    navigator.push(.signIn)
                                })
                            .fwButtonStyle(.primary)
                            .addSensoryFeedback()

                            FWButton(
                                title: "Créer un compte",
                                action: {
                                    navigator.push(.signUp)
                                })
                            .fwButtonStyle(.secondary)
                            .addSensoryFeedback()
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.smooth) {
                    text = "Urban Paris 2017"
                } completion: {
                    withAnimation(.default.delay(0.4)) {
                        buttonAppear = true
                    } completion: {
                        withAnimation(.smooth(duration: 1.5)) {
                            animate = true
                        }
                    }
                }

                withAnimation {
                }
            }
        }
    }
}
