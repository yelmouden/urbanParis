
//
//  TravelsList.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import DesignSystem
import FlowStacks
import SwiftUI

struct TravelsListView: View {
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    @State var viewModel: TravelsListViewModel

    init(idSeason: Int) {
        _viewModel = State(initialValue: .init(idSeason: idSeason))
    }

    var body: some View {
        BackgroundImageContainerView(
            nameImages: [],
            bundle: Bundle.main,
            colors: [DSColors.background.swiftUIColor]
        )
        {
            VStack {
                switch viewModel.state {
                case .loaded(let travels):
                    VStack {
                        FWScrollView {
                            LazyVStack {
                                ForEach(travels) { travel in
                                    Button(action: {
                                        navigator.push(.editTravel(idSeason: viewModel.idSeason, travel: travel, isCreation: false))
                                    }) {
                                        HStack {
                                            if let date = travel.date {
                                                Text(date)
                                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                                    .font(DSFont.robotoBodyBold)
                                                    .padding(.trailing, Margins.mediumSmall)
                                            }

                                            Text(travel.team?.name ?? "Equipe non définie")
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

                        FWButton(title: "Supprimer la saison") {
                            PopupManager.shared.showPopup(item: .alert( .init(
                                title: "Confirmation",
                                description: "Es-tu sûr de vouloir supprimer la saison ?\n\nTu risques de perdre tous les matchs de la saison",
                                primaryButtonItem: .init(
                                    title: "Valider",
                                    asyncAction: {
                                        await viewModel.deleteSeason()
                                    },
                                    onDismiss: { [navigator] in
                                        navigator.pop()
                                    },
                                    isDestructive: true
                                ),
                                secondaryButtonItem: .cancel
                                )
                            ))
                        }
                        .fwButtonStyle(.primary)
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(
                                action: {
                                    navigator.presentSheet(
                                        .editTravel(idSeason: viewModel.idSeason, travel: nil, isCreation: true) { [viewModel] in
                                            Task {
                                                await viewModel.retrieveTravels()
                                            }
                                        },
                                        withNavigation: true
                                    )
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(DSColors.red.swiftUIColor)
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
            .navigationTitle("Matches")
            .task {
                await viewModel.retrieveTravels()
            }

        }
    }
}
