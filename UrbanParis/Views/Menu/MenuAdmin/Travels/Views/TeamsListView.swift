//
//  TeamsListView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 27/12/2024.
//

import DesignSystem
import FlowStacks
import SharedResources
import TravelMatchesFeature
import SwiftUI

struct TeamsListView: View {
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    @State var viewModel: TeamsListViewModel

    let currentTeam: Team?
    let selectedTeam: (Team?) -> Void

    init(currentTeam: Team?, selectedTeam: @escaping (Team?) -> Void) {
        self.currentTeam = currentTeam
        self.selectedTeam = selectedTeam
        _viewModel = State(initialValue: .init())
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
                case .loaded(let teamViewModels):
                    VStack {
                        FWScrollView {
                            LazyVStack {
                                ForEach(teamViewModels) { teamViewModel in
                                    Button {
                                        selectedTeam(teamViewModel.team)
                                        navigator.pop()
                                    } label: {
                                        TeamCellView(viewModel: teamViewModel, isSelected: currentTeam == teamViewModel.team) { [viewModel, currentTeam, selectedTeam] in
                                            viewModel.removeTeam(teamId: $0.id)

                                            if currentTeam?.id == $0.id{
                                                selectedTeam(nil)
                                            }
                                        }
                                        .padding(.top, Margins.medium)
                                    }
                                }
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                PopupManager.shared.showPopup(item: .view(AnyView(AddTeamInfoInputView(
                                    tapAdd: { [viewModel] team in
                                        Task {
                                            await viewModel.addTeam(name: team)
                                        }
                                    })
                                )))
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(DSColors.red.swiftUIColor)
                            }
                            
                        }

                    }
                    .animation(.default, value: viewModel.state)
                default:
                    EmptyView()
                }

            }
            .addBackButton(isPresented: true) {
                navigator.pop()
            }
            .navigationTitle("Equipes")
            .task {
                await viewModel.retrieveTeams()
            }
            .showBanner($viewModel.showError, text: SharedResources.commonErrorText, type: .error)

        }
    }
}

