//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 30/07/2024.
//

import DesignSystem
import SwiftUI

struct MyTravelView: View {
    @State var image: UIImage?

    let travel: Travel

    var body: some View {
        HStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 34, height: 34)
                    .padding([.leading, .trailing], Margins.small)

            } else {
                Assets.fanion.swiftUIImage
                    .resizable()
                    .frame(width: 34, height: 34)
                    .padding([.leading, .trailing], Margins.small)
            }

            Text(travel.team.name)
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoBodyBold)

            Spacer()

            if let date = travel.date {
                Text(date)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoBody)
            }

        }
        .task {
            self.image = await travel.team.retrieveIcon()
        }
    }
}
