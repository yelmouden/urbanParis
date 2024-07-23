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
        ZStack(alignment: .bottom) {
            if orientation == .left {
                LottieView(animation: .named("fumiBlueAnimation"))
                    .playing(loopMode: .loop)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-45))
                    .offset(.init(width: -25, height: -45))

                Image("manFumiRight")
                     .resizable()
                     .scaledToFill()
                     .frame(width: 80, height: 78)
            } else {
                LottieView(animation: .named("fumiRedAnimation"))
                    .playing(loopMode: .loop)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(45))
                    .offset(.init(width: 30, height: -45))

                Image("manFumiLeft")
                     .resizable()
                     .scaledToFill()
                     .frame(width: 80, height: 78)
            }

        }
    }
}
