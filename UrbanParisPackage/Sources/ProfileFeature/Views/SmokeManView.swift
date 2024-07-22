//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 20/07/2024.
//

import Lottie
import SwiftUI

enum Orientation {
    case left
    case right
}

struct SmokeManView: View {

    let orientation: Orientation

    var body: some View {
        ZStack {
            if orientation == .left {
                LottieView(animation: .named("fumiBlueAnimation", bundle: Bundle.module))
                    .playing(loopMode: .loop)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-45))
                    .offset(.init(width: -14, height: -100))

                Assets.manFumiRight.swiftUIImage
                     .resizable()
                     .scaledToFit()
                     .frame(width: 125)
            } else {
                LottieView(animation: .named("fumiRedAnimation", bundle: Bundle.module))
                    .playing(loopMode: .loop)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(45))
                    .offset(.init(width: 16, height: -100))

                Assets.manFumiLeft.swiftUIImage
                     .resizable()
                     .scaledToFit()
                     .frame(width: 125)
            }

        }
    }
}
