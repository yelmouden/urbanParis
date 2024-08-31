//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import ACarousel
import DesignSystem
import FlowStacks
import Pow
import SharedResources
import SwiftUI
import Utils

enum Action: Equatable {
    case idle
    case load
    case refresh
}

struct TravelMatchesView: View {

    @State var action: Action = .idle

    @State var task: Task<Void, Never>?

    @Bindable var viewModel: TravelMatchesViewModel

    var body: some View {
        BackgroundImageContainerView(
            nameImages: ["upPlage"],
            bundle: Bundle.module,
            padding: 0
        )
        {
            switch viewModel.stateTravelsView {
            case .loading:
                let loadingItems = (0...2).map { _ in
                    LoadingItem()
                }

                ACarousel(loadingItems, id: \.id, sidesScaling: 0.85) { travelVM in
                    TravelMatchLoadingView()
                }
                .transition(.opacity)

            case .loaded(let items):
                ACarousel(items, id: \.travel.id, index: $viewModel.currentIndex, sidesScaling: 0.85) { travelVM in
                    TravelMatchView(travelVM: travelVM)
                }
                .transition(.opacity)
            default:
                EmptyView()
            }

        }
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
                        
                        Button(action: {
                            action = .refresh
                        }) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .foregroundColor(DSColors.red.swiftUIColor)
                        }


                    }
                default: EmptyView()
                }
            }
        }
        .navigationTitle("Deplacements")
        .onAppear {
            self.task = Task {
               await viewModel.retrieveSeasons()
            }
        }
        .onDisappear {
            task?.cancel()
        }
        .task(id: action) {
            switch action {
            case .idle:
                return
            case .load, .refresh:
                if viewModel.selectedSeason != nil {
                    await viewModel.retrieveTravels()
                }

                action = .idle
            }
        }
        .onChange(of: viewModel.selectedSeason, { _, _ in
            action = .load
        })
        .animation(.default, value: viewModel.stateTravelsView)
        .showBanner($viewModel.showError, text: SharedResources.commonErrorText, type: .error)
    }
}

extension TravelMatchesView {
    struct LoadingItem: Identifiable {
        let id = UUID()
    }
}
