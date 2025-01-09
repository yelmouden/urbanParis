//
//  SwiftUIView.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 19/11/2024.
//

import DesignSystem
import FlowStacks
import ProfileManager
import SharedResources
import SwiftUI
import Utils

public struct ListMembersView: View {
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    @State var viewModel: ListMembersViewModel = .init()
    @State var searchText: String = ""

    @State var task: Task<Void, Never>?

    @State var hasMadeRequest: Bool = false

    let selectedProfile: ((Profile) -> Void)?

    public init(selectedProfile: ((Profile) -> Void)? = nil) {
        self.selectedProfile = selectedProfile
    }

    public var body: some View {
        BackgroundImageContainerView(
            nameImages: [],
            bundle: Bundle.main,
            colors: [DSColors.background.swiftUIColor]
        )
        {
            VStack {
                FWScrollView {
                    ListStateView(
                        stateView: viewModel.state,
                        idleView: { EmptyView() },
                        loadingView: {
                            LoadingView()
                        },
                        loadedView: { sections in
                            //ScrollView {
                                LazyVStack {
                                    ForEach(sections, id: \.key) { section in
                                        Section(header: sectionHeader(section.key)) {
                                            ForEach(section.profiles) { member in
                                                Button(action: {
                                                    if let selectedProfile, !member.isLocked {
                                                        selectedProfile(member)
                                                        navigator.pop()
                                                    } else if selectedProfile == nil {
                                                        navigator.push(.memberDetails(.init(profile: member)))
                                                        searchText = ""
                                                    }
                                                }) {
                                                    VStack {
                                                        HStack {
                                                            Text("\(member.lastname)")
                                                                .foregroundStyle(DSColors.white.swiftUIColor)
                                                                .font(DSFont.robotoHeadline)
                                                            Text("\(member.firstname)")
                                                                .foregroundStyle(DSColors.white.swiftUIColor)
                                                                .font(DSFont.robotoHeadline)

                                                            Spacer()

                                                            if member.isAdmin {
                                                                Image(systemName: "star.fill")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .foregroundStyle(DSColors.or.swiftUIColor)
                                                                    .frame(width: 20, height: 20)
                                                            }

                                                            if member.isLocked {
                                                                Image(systemName: "lock.fill")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .foregroundStyle(DSColors.red.swiftUIColor)
                                                                    .frame(width: 20, height: 20)
                                                            }

                                                            if selectedProfile == nil {
                                                                Image(systemName: "chevron.right")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .foregroundStyle(DSColors.red.swiftUIColor)
                                                                    .frame(width: 20, height: 20)
                                                            }

                                                        }
                                                    }
                                                    .opacity(member.isLocked ? 0.3 : 1)
                                                }
                                                .padding(.bottom, Margins.medium)
                                            }
                                        }
                                    }
                                }
                                .padding(.top, Margins.mediumSmall)
                                .searchable(text: $searchText, prompt: "Rechercher un membre")
                                .onChange(of: searchText) { _, newValue in
                                    task?.cancel()

                                    task = Task.detached {
                                        do {
                                            try await Task.sleep(for: .milliseconds(300))
                                            try await viewModel.searchMembers(newValue)
                                        } catch {}

                                    }
                                }

                        },
                        emptyView: {
                            ZStack {
                                Spacer().containerRelativeFrame([.vertical])
                                Text("Aucun membre pour le moment")
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                    .font(DSFont.robotoTitle)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    )
                }
                .refreshable {
                    await viewModel.retrieveMembers()
                }
                .paddingBottomScreen()
                .animation(.default, value: viewModel.state)
                .task {
                    await viewModel.retrieveMembers()
                }
                .showBanner($viewModel.showError, text: SharedResources.commonErrorText, type: .error)
                .navigationTitle("Liste des membres")
                .addBackButton(isPresented: selectedProfile != nil) {
                    task?.cancel()
                    navigator.pop()
                }
            }
        }
    }

    func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoHeadline)
                .padding(.leading, Margins.verySmall)
                .padding(.vertical, Margins.verySmall)

            Spacer()
        }
        .background(DSColors.red.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.bottom, Margins.mediumSmall)

    }
}
