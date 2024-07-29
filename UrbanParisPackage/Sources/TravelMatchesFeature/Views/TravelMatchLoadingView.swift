//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 28/07/2024.
//

import DesignSystem
import SwiftUI

struct TravelMatchLoadingView: View {
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack {
                    ForEach(0..<12) {  i in
                        SkeletonLoadingView(height: 20)
                            .padding(.top, i == 0 ? 32 + Margins.medium : Margins.large)
                    }
                }
            }
            .scrollDisabled(true)

            .padding([.leading, .trailing], Margins.small)
            .background(DSColors.background.swiftUIColor.opacity(0.2))
            .addBorder(DSColors.red.swiftUIColor, cornerRadius: 12)
            .padding(.top, 32)

            SkeletonLoadingView(height: 64)
                .frame(width: 64)
        }

    }
}
