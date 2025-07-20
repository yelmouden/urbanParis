//
//  TravelsList.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import DesignSystem
import FlowStacks
import SharedResources
import SwiftUI

struct SeasonsListView: View {
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    @State var viewModel = SeasonsListViewModel()
    @State var taskAddSeason: Task<Void, Never>?

    var body: some View {
        BackgroundImageContainerView(
            nameImages: [],
            bundle: Bundle.main,
            colors: [DSColors.background.swiftUIColor]
        )
        {
            VStack {
                switch viewModel.state {
                case .loading:
                    LoadingView()
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
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                PopupManager.shared.showPopup(item: .view(AnyView(AddSeasonInfoInputView(
                                    tapAdd: { season in
                                        taskAddSeason = Task {
                                            await viewModel.addSeason(season)
                                        }
                                    })
                                )))
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(DSColors.red.swiftUIColor)
                            }
                        }

                    }
                case .empty:
                    ZStack {
                        Spacer().containerRelativeFrame([.vertical])
                        Text("Pas de saisons pour le moment")
                            .foregroundStyle(DSColors.white.swiftUIColor)
                            .font(DSFont.robotoTitle)
                            .multilineTextAlignment(.center)
                    }
                default:
                    EmptyView()
                }

            }
            .animation(.default, value: viewModel.state)
            .addBackButton {
                taskAddSeason?.cancel()
                navigator.pop()
            }
            .navigationTitle("Saisons")
            .task {
                await viewModel.retrieveSeasons()
            }
            .showBanner($viewModel.showError, text: SharedResources.commonErrorText, type: .error)
        }
    }
}
