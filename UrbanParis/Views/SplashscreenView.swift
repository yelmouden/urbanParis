//
//  SplashcreenView.swift
//  FreeWave
//
//  Created by Yassin El Mouden on 23/04/2024.
//

import AnimateText
import DesignSystem
import SwiftUI
import Utils

struct SplashcreenView: View, Animatable {
    @State var text: String = ""

    var body: some View {
        MainContainer {
            VStack {
                Spacer()

                let image =  ConfigurationReader.isUrbanApp ? Image("urbanHead")
                : Image("letters")

                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: ConfigurationReader.isUrbanApp ? 300 : 250,
                        height: ConfigurationReader.isUrbanApp ? 300: 250)

                AnimateText<ATChimeBellEffect>($text, type: .words)
                    .font(DSFont.grafTitle3)
                    .foregroundStyle(ConfigurationReader.isUrbanApp ? DSColors.or.swiftUIColor : DSColors.white.swiftUIColor)
                    .offset(CGSize(width: 0, height: ConfigurationReader.isUrbanApp ? -50 : -15))

                Spacer()

            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.smooth) {
                    text = "Urban Paris 2017"
                }
            }
        }
    }
}

