//
//  MembersTravelView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import DesignSystem
import FlowStacks
import SharedResources
import SwiftUI

struct MembersTravelView: View {
    @State var viewModel: MembersTravelViewModel
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    init(idTravel: Int, idSeason: Int) {
        _viewModel = .init(initialValue: MembersTravelViewModel(idTravel: idTravel, idSeason: idSeason))
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
                case .loading:
                    LoadingView()
                case .loaded(let viewModels):
                    VStack {
                        HStack {
                            Text("\(viewModels.count) inscrit(s)")
                                .foregroundStyle(DSColors.white.swiftUIColor)
                                .font(DSFont.robotoTitle2)

                            Spacer()
                        }
                        .padding(.vertical, Margins.medium)


                        FWScrollView {
                            LazyVStack {
                                ForEach(viewModels) { viewModel in
                                    MemberTravelCellView(viewModel: viewModel)
                                        .padding(.bottom, Margins.medium)
                                }
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {
                                    navigator.presentSheet(
                                        .members { profile in
                                            Task {
                                                await viewModel.addMemberToTravel(profile: profile)
                                            }
                                        },
                                        withNavigation: true)
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .foregroundStyle(DSColors.red.swiftUIColor)
                                        .frame(width: 30, height: 30)
                                }
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

            .navigationTitle("Membres inscrits")
            .task {
                await viewModel.retrieveMembersTravel()
            }
            .showBanner($viewModel.showError, text: SharedResources.commonErrorText, type: .error)

        }
    }
}
