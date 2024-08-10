
//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 19/07/2024.
//

import DesignSystem
import FlowStacks
import ProfileManager
import SDWebImageSwiftUI
import SwiftUI
import Utils

public struct EditProfileView: View, KeyboardReadable {
    @EnvironmentObject var navigator: FlowNavigator<ProfileScreen>

    @Bindable var viewModel: EditProfileViewModel

    @State var isPresented = false

    @State var task: Task<Void, Never>?
    @State var isEditing = false
    @State var selectedImage: UIImage?
    @State var croppingImage: UIImage?

    @State var urlProfileImage: URL?

    public var body: some View {
        BackgroundImageContainerView(
            nameImages: ["susic", "rai", "pauleta", "sakho"],
            bundle: Bundle.module
        )
        {
            VStack {
                FWScrollView {
                    VStack(spacing: isEditing ? Margins.medium: Margins.extraLarge) {
                        Group {
                            if let image = viewModel.selectedImage {
                                VStack {
                                    Image(uiImage: image)
                                        .padding(.top, Margins.medium)

                                    if isEditing {
                                        FWButton(title: "Modifier la photo") {
                                            isPresented = true
                                        }
                                        .padding(.top, Margins.medium)
                                    }

                                }


                            } else {
                                if viewModel.isCreation {
                                    Button(action: {
                                        isPresented = true
                                    }, label: {
                                        ZStack {
                                            Circle()
                                                .fill(DSColors.red.swiftUIColor.opacity(0.5))
                                                .frame(width: 180, height: 180)
                                            Image(systemName: "camera.fill")
                                                .font(.largeTitle)
                                                .foregroundStyle(DSColors.background.swiftUIColor)

                                        }
                                    })
                                } else {
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
                                        VStack {
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
                                            } else {
                                                ZStack {
                                                    Circle()
                                                        .fill(DSColors.red.swiftUIColor.opacity(0.5))
                                                        .frame(width: 180, height: 180)
                                                    Image(systemName: "camera.fill")
                                                        .font(.largeTitle)
                                                        .foregroundStyle(DSColors.background.swiftUIColor)

                                                }
                                            }

                                            if isEditing {
                                                FWButton(title: "Modifier la photo") {
                                                    isPresented = true
                                                }
                                                .padding(.top, Margins.medium)

                                            }
                                        }
                                    default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                        .padding(.top, Margins.large)
                        .confirmationDialog("Séléctionner une source" ,isPresented: $isPresented) {
                            Button("Appareil Photo") {
                                navigator.presentSheet(.selectPhotoFromCamera($selectedImage))
                                isPresented = false
                            }

                            Button("Bibliothèque de photos") {
                                navigator.presentSheet(.selectPhotoFromLibrary($selectedImage))
                                isPresented = false
                            }
                        }




                        if viewModel.isCreation || isEditing {
                            FWTextField(
                                title: "Ton prenom",
                                placeholder: "Saissi ton prénom",
                                text: $viewModel.profile.firstname
                            )
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding(.top, Margins.medium)
                        } else {
                            HStack {
                                Text("Mon Prenom:")
                                    .font(DSFont.grafHeadline)
                                    .foregroundStyle(DSColors.white.swiftUIColor)

                                Spacer()

                                Text(viewModel.profile.firstname)
                                    .font(DSFont.robotoTitle3)
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                            }
                            .padding(.top, Margins.medium)

                        }

                        if viewModel.isCreation || isEditing {
                            FWTextField(
                                title: "Ton nom",
                                placeholder: "Saisis ton nom",
                                text: $viewModel.profile.lastname
                            )
                            .autocorrectionDisabled()
                        } else {
                            HStack {
                                Text("Mon nom:")
                                    .font(DSFont.grafHeadline)
                                    .foregroundStyle(DSColors.white.swiftUIColor)

                                Spacer()

                                Text(viewModel.profile.lastname)
                                    .font(DSFont.robotoTitle3)
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                            }

                        }


                        if viewModel.isCreation || isEditing{
                            FWTextField(
                                title: "Ton surnom",
                                placeholder: "Saisis ton surnom",
                                text: $viewModel.profile.nickname
                            )
                            .autocorrectionDisabled()
                        } else {
                            HStack {
                                Text("Mon surnom:")
                                    .font(DSFont.grafHeadline)
                                    .foregroundStyle(DSColors.white.swiftUIColor)

                                Spacer()

                                Text(viewModel.profile.nickname)
                                    .font(DSFont.robotoTitle3)
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                            }

                        }


                        if viewModel.isCreation || isEditing{

                            HStack {
                                VStack {
                                    Text("Ton annee d'entree dans le groupe")
                                        .font(DSFont.grafHeadline)
                                        .foregroundStyle(DSColors.white.swiftUIColor)
                                }

                                Spacer()
                            }

                            HStack {
                                Button(action: {
                                    viewModel.profile.year -= 1
                                    viewModel.profile.year = max(2017, viewModel.profile.year)
                                }, label: {
                                    Image(systemName: "chevron.left.circle.fill")
                                        .resizable()
                                        .foregroundStyle(DSColors.red.swiftUIColor)
                                        .frame(width: 30, height: 30)
                                })
                                .padding(.trailing, Margins.extraLarge)
                                .addSensoryFeedback()

                                Text(verbatim: "\(viewModel.profile.year)")
                                    .foregroundStyle(DSColors.white.swiftUIColor)

                                Button(action: {
                                    viewModel.profile.year += 1
                                    viewModel.profile.year = min(viewModel.profile.year, Date.currentYear)
                                }, label: {
                                    Image(systemName: "chevron.right.circle.fill")
                                        .resizable()
                                        .foregroundStyle(DSColors.red.swiftUIColor)
                                        .frame(width: 30, height: 30)
                                })
                                .padding(.leading, Margins.extraLarge)
                                .addSensoryFeedback()
                            }
                            .padding(.bottom, Margins.small)

                        } else {
                            
                            HStack {
                                Text("Mon annee d'entree dans le groupe:")
                                    .font(DSFont.grafHeadline)
                                    .foregroundStyle(DSColors.white.swiftUIColor)

                                Spacer()

                                Text(verbatim: "\(viewModel.profile.year)")
                                    .font(DSFont.robotoTitle3)
                                    .foregroundStyle(DSColors.white.swiftUIColor)

                            }
                        }

                        if viewModel.isCreation || isEditing {
                            HStack {
                                SelectableViews(title: "Ton type d'abonnement au Parc", items: [AboType.aboPSG, .aboCUP, .none ], selectedItem: $viewModel.profile.typeAbo)
                                    .padding(.bottom, Margins.extraLarge)

                                Spacer()
                            }

                        } else {
                            HStack {
                                Text("Mon abonnement au Parc:")
                                    .font(DSFont.grafHeadline)
                                    .foregroundStyle(DSColors.white.swiftUIColor)
                                
                                Spacer()

                                Text(viewModel.profile.typeAbo?.title ?? "")
                                    .font(DSFont.robotoTitle3)
                                    .foregroundStyle(DSColors.white.swiftUIColor)

                            }
                        }

                        if !viewModel.isCreation && !isEditing {
                            HStack {
                                Button {
                                    navigator.push(.myTravels(.init(onClose: { [navigator] in
                                        navigator.goBack()
                                    })))
                                } label: {
                                    HStack {
                                        Text("Voir mes deplacements de la saison")
                                            .font(DSFont.grafHeadline)
                                            .foregroundStyle(DSColors.white.swiftUIColor)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(DSColors.red.swiftUIColor)
                                    }

                                }
                            }
                        }
                    }
                }
                .zIndex(2)

                Spacer()

                if viewModel.isCreation || isEditing {
                    VStack {
                        FWButton(
                            title: "Valider",
                            state: viewModel.state.toFWButtonState(),
                            action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                                task = Task {
                                    let hasSaved = await viewModel.saveProfile()

                                    if isEditing, hasSaved {
                                        isEditing = false
                                    }

                                }
                            })
                        .enabled(viewModel.isFieldsAllValid)
                        .fwButtonStyle(.primary)
                        .addSensoryFeedback()
                        .padding(.bottom, Margins.small)
                    }
                }
            }
        }
        .onDisappear {
            task?.cancel()
        }
        .toolbar {
            if !viewModel.isCreation, !isEditing {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isEditing = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(DSColors.red.swiftUIColor)
                    }
                }
            }

        }
        .onChange(of: selectedImage, { oldValue, newValue in
            if let newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    navigator.presentSheet(.cropImage(newValue, $viewModel.selectedImage))
                }
            }
        })
        .task {
            await viewModel.retrieveURLProfileImage()
        }
        .animation(.smooth, value: isEditing)
        .interactiveDismissDisabled()
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(viewModel.isCreation ? "Creer ton profil": "Mon profil")
        .showBanner($viewModel.showError, text: viewModel.errorText, type: .error)
    }
}
