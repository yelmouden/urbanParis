
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
                    FWScrollView {
                        LazyVStack {
                            ForEach(travels) { travel in
                                Button(action: {
                                    navigator.push(.editTravel(idSeason: viewModel.idSeason, travel: travel))
                                }) {
                                    HStack {
                                        if let date = travel.date {
                                            Text(date)
                                                .foregroundStyle(DSColors.white.swiftUIColor)
                                                .font(DSFont.robotoBodyBold)
                                                .padding(.trailing, Margins.mediumSmall)
                                        }

                                        Text(travel.team.name)
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        //isEditing = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(DSColors.red.swiftUIColor)
                    }
                }

            }
            .navigationTitle("Matches")
            .task {
                await viewModel.retrieveTravels()
            }

        }
    }
}
