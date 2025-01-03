//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 30/07/2024.
//

import DesignSystem
import SDWebImageSwiftUI
import SwiftUI

struct MyTravelView: View {
    @State var url: URL?

    let travel: Travel

    var body: some View {
        HStack {
            Assets.fanion.swiftUIImage
                .resizable()
                .frame(width: 34, height: 34)
                .padding([.leading, .trailing], Margins.small)

            Text(travel.team?.name ?? "Pas d'équipe de renseigné")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoBodyBold)

            Spacer()

            if let date = travel.date {
                Text(date)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoBody)
            }
        }
    }
}
