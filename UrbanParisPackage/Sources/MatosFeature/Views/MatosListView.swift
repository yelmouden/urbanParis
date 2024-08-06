//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 05/08/2024.
//

import DesignSystem
import SharedResources
import SwiftUI
import Utils

@MainActor
struct MatosListView: View {
    @Bindable var viewModel: MatosListViewModel

    var body: some View {
        BackgroundImageContainerView(nameImages: ["wall"], bundle: .module) {
            ScrollView {
                ListStateView(
                    stateView: viewModel.state,
                    idleView: { EmptyView() },
                    loadingView: {
                        VStack {

                            ForEach(0..<3, id: \.self) { _ in
                                SkeletonLoadingView(height: 300, shapeType: .rectangle)
                                    .addBorder(DSColors.red.swiftUIColor, cornerRadius: 12)
                                    .padding(.bottom, Margins.medium)
                            }
                        }
                        .padding(.top, Margins.medium)
                    },
                    loadedView: { matos in
                        LazyVStack {
                            ForEach(matos) { matos in
                                MatosView(matos: matos)
                                    .padding(.bottom, Margins.small)

                            }
                        }
                        .padding(.top, Margins.medium)

                    }, emptyView: {
                        ZStack {
                            Spacer().containerRelativeFrame([.vertical])
                            Text("Aucun matos disponible pour le moment")
                                .foregroundStyle(DSColors.white.swiftUIColor)
                                .font(DSFont.robotoTitle)
                                .multilineTextAlignment(.center)
                        }
                    }
                )
            }

        }
        .task {
            await viewModel.retrieveMatos()
        }
        .showBanner($viewModel.showError, text: SharedResources.commonErrorText, type: .error)
        .navigationTitle("Matos")
    }
}
