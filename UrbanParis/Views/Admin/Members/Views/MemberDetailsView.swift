//
//  SwiftUIView.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 22/11/2024.
//

import DesignSystem
import FlowStacks
import SDWebImageSwiftUI
import SharedResources
import SwiftUI
import Utils

public struct MemberDetailsView: View {
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    let viewModel: MemberDetailsViewModel

    @State var lockUnlockTask: Task<Void, Never>?
    @State var adminTask: Task<Void, Never>?
    @State var deleteTask: Task<Void, Never>?

    @State var showAlertDelete: Bool = false

    public var body: some View {
        BackgroundImageContainerView(
            nameImages: [],
            bundle: Bundle.main,
            colors: [DSColors.background.swiftUIColor]
        )
        {
            FWScrollView {
                VStack {
                    switch viewModel.stateURLImageProfile {
                    case .loading:
                        ZStack {
                            Circle()
                                .fill(DSColors.red.swiftUIColor.opacity(0.5))
                                .frame(width: 180, height: 180)
                            ProgressView()
                                .tint(DSColors.background.swiftUIColor)
                                .frame(width: 75, height: 75)

                        }
                    case .loaded(let url):
                        if let url {
                            WebImage(url: url) { image in
                                image
                                    .resizable()
                                    .frame(width: 180, height: 180)
                                    .scaledToFill()
                                    .clipShape(Circle())
                            } placeholder: {
                                ZStack {
                                    Circle()
                                        .fill(DSColors.red.swiftUIColor.opacity(0.5))
                                        .frame(width: 180, height: 180)
                                    ProgressView()
                                        .tint(DSColors.background.swiftUIColor)
                                        .frame(width: 75, height: 75)

                                }
                            }
                        }
                    default:
                        EmptyView()
                    }

                    VStack(spacing: Margins.medium) {
                        HStack {
                            Text("Prenom:")
                                .font(DSFont.grafHeadline)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(viewModel.firstname)
                                .font(DSFont.robotoTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)
                        }
                        .padding(.top, Margins.medium)

                        HStack {
                            Text("Nom:")
                                .font(DSFont.grafHeadline)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(viewModel.lastname)
                                .font(DSFont.robotoTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)
                        }


                        HStack {
                            Text("Surnom:")
                                .font(DSFont.grafHeadline)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(viewModel.nickname)
                                .font(DSFont.robotoTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)
                        }


                        HStack {
                            Text("Annee d'entree dans le groupe:")
                                .font(DSFont.grafHeadline)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(verbatim: "\(viewModel.year)")
                                .font(DSFont.robotoTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                        }

                        HStack {
                            Text("Type bonnement au Parc:")
                                .font(DSFont.grafHeadline)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(viewModel.typeAbo)
                                .font(DSFont.robotoTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                        }

                        HStack {
                            Text("Status:")
                                .font(DSFont.grafHeadline)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Spacer()

                            Text(viewModel.status)
                                .font(DSFont.robotoTitle3)
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Button {
                                let editionStatusViewModel = ProfileEditionStatusViewModel(profile: self.viewModel.profile, didUpdateStatus: { [weak viewModel] in
                                    viewModel?.updateStatus($0)
                                })
                                navigator.presentSheet(.memberEditStatus(editionStatusViewModel))
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .resizable()
                                    .foregroundStyle(DSColors.red.swiftUIColor)
                                    .frame(width: 30, height: 30)
                            }
                            .addSensoryFeedback()
                        }
                    }

                    VStack(spacing: Margins.mediumSmall) {
                        FWButton(
                            title: viewModel.textButtonBloquerUtilisateur,
                            state: viewModel.stateLocking.toFWButtonState(),
                            action: {
                                adminTask?.cancel()
                                deleteTask?.cancel()
                                lockUnlockTask = Task {
                                    await viewModel.lockUnlockProfile()
                                }
                            })

                        .fwButtonStyle(.primary)
                        .addSensoryFeedback()

                        FWButton(
                            title: viewModel.textButtonAdmin,
                            state: viewModel.stateAdmin.toFWButtonState(),
                            action: {
                                lockUnlockTask?.cancel()
                                deleteTask?.cancel()
                                adminTask = Task {
                                    await viewModel.setUnsetAdmin()
                                }
                            })

                        .fwButtonStyle(.primary)
                        .addSensoryFeedback()
                    }
                    .padding(.top, Margins.large)

                }
            }
            .padding(.top, Margins.large)
        }
        .addBackButton {
            navigator.pop()
        }
        .task {
            await viewModel.retrieveURLProfileImage()
        }
        .onDisappear {
            lockUnlockTask?.cancel()
            deleteTask?.cancel()
            adminTask?.cancel()
        }
        .navigationTitle("Membre")
        .alert("Êtes-tu sûr de vouloir supprimer ce membre", isPresented: $showAlertDelete) {
            Button("Annuler", role: .cancel) { }
            Button("Confirmer", role: .destructive) {
                Task {
                    deleteTask = Task { [weak navigator] in
                        await viewModel.delete()
                        navigator?.pop()
                    }
                }
            }
        }
    }
}
