//
//  MembersTravelView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import DesignSystem
import FlowStacks
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
                                    MemberTravelView(viewModel: viewModel)
                                        .padding(.bottom, Margins.medium)
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
            .navigationTitle("Membres inscrits")
            .task {
                await viewModel.retrieveMembersTravel()
            }

        }
    }
}
