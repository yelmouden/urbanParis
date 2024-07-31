//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 30/07/2024.
//

import DesignSystem
import SharedResources
import SwiftUI
import Utils

enum MyTravelsViewAction {
    case loadSeasons
    case loadMyTravels
}

public struct MyTravelsView: View {
    @State var viewModel: MyTravelsViewModel = .init()
    @State var action: MyTravelsViewAction = .loadSeasons

    let interModuleAction: InterModuleAction<Void>?

    public init(interModuleAction: InterModuleAction<Void>? = nil) {
        self.interModuleAction = interModuleAction
    }

    public var body: some View {
        BackgroundImageContainerView(nameImages: ["fumisMats"], bundle: .module) {
            FWScrollView {
                ListStateView(
                    stateView: viewModel.stateTravels,
                    idleView: { EmptyView() },
                    loadingView: {
                        VStack {
                            ForEach(0..<15, id: \.self) { _ in
                                SkeletonLoadingView(height: 20)
                                    .padding(.bottom, Margins.medium)
                            }
                        }
                        .padding(.top, Margins.medium)
                    },
                    loadedView: { travels in
                        VStack {
                            Text("Nombre de déplacements")
                                .foregroundStyle(DSColors.white.swiftUIColor)
                                .font(DSFont.robotoTitle)
                                .padding(.top, Margins.large)
                                .padding(.bottom, Margins.verySmall)

                            Text("\(travels.count)")
                                .foregroundStyle(DSColors.white.swiftUIColor)
                                .font(DSFont.robotoExtraLargeTitle)
                                .padding(.bottom, Margins.mediumSmall)


                            LazyVStack {
                                ForEach(travels) { travel in
                                    MyTravelView(travel: travel)
                                        .padding(.bottom, Margins.mediumSmall)

                                    Divider()
                                        .frame(height: 2)
                                        .overlay(DSColors.red.swiftUIColor)
                                        .padding(.bottom, Margins.small)
                                }
                            }
                        }
                    },
                    emptyView: {
                        VStack {
                            Spacer()

                            HStack {
                                Spacer()
                                Text("Aucun déplacements cette saison")
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .font(DSFont.robotoTitle)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }

                            Spacer()
                        }
                    }
                )
            }
        }
        .addBackButton {
            interModuleAction?.onClose?()
        }
        .task(id: action) {
            switch action {
            case .loadSeasons:
                await viewModel.retrieveSeasons()
            case .loadMyTravels:
                await viewModel.retrieveMyTravels()
            }
        }
        .onChange(of: viewModel.selectedSeason, { oldValue, newValue in
            action = .loadMyTravels
        })
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                switch viewModel.stateSeasonsView {

                case .loading:
                    ProgressView()
                        .tint(DSColors.red.swiftUIColor)
                case .loaded(let seasons):
                    if let season = viewModel.selectedSeason {
                        Button(action: {
                            PopupManager.shared.showPopup(item: .view(AnyView(
                                SeasonSelectionView(
                                    seasons: seasons,
                                    selectedSeaons: $viewModel.selectedSeason
                                )
                            )))
                        }) {
                            HStack {
                                Image(systemName: "calendar")
                                Text("\(season.title)")
                                    .font(DSFont.robotoBody)
                            }
                            .foregroundColor(DSColors.red.swiftUIColor)
                        }

                    }
                default: EmptyView()
                }
            }
        }
        .showBanner($viewModel.showError, text: SharedResources.commonErrorText, type: .error)
        .navigationTitle("Mes déplacements")
    }
}

