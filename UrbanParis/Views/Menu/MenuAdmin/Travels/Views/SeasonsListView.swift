//
//  TravelsList.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import DesignSystem
import FlowStacks
import SwiftUI

struct SeasonsListView: View {
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    @State var viewModel = SeasonsListViewModel()

    var body: some View {
        BackgroundImageContainerView(
            nameImages: [],
            bundle: Bundle.main,
            colors: [DSColors.background.swiftUIColor]
        )
        {
            VStack {
                switch viewModel.state {
                case .loaded(let seasons):
                    FWScrollView {
                        LazyVStack {
                            ForEach(seasons) { season in
                                Button(action: {
                                    navigator.push(.travels(idSeason: season.id))
                                }) {
                                    HStack {
                                        
                                        Text(season.title)
                                            .foregroundStyle(DSColors.white.swiftUIColor)
                                            .font(DSFont.robotoTitle3)
                                            .padding(.trailing, Margins.mediumSmall)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(DSColors.red.swiftUIColor)
                                            .frame(width: 20, height: 20)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.top, Margins.medium)
                            }
                        }
                    }
                default:
                    EmptyView()
                }

            }
            .addBackButton {
                navigator.pop()
            }
            .navigationTitle("Saisons")
            .task {
                await viewModel.retrieveSeasons()
            }

        }
    }
}
