//
//  TravelDetailsView.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 26/12/2024.
//

import DesignSystem
import FlowStacks
import SharedResources
import SwiftUI
import TravelMatchesFeature

struct EditTravelMatchView: View {
    @State var viewModel: EditTravelMatchViewModel
    @EnvironmentObject var navigator: FlowNavigator<MenuAdminScreen>

    let isCreation: Bool
    let didUpdate: (() -> Void)?

    init(
        idSeason: Int,
        travel: Travel?,
        isCreation: Bool,
        didUpdate: (() -> Void)? = nil
    ) {
        self.isCreation = isCreation
        self.didUpdate = didUpdate
        _viewModel = .init(
            initialValue: EditTravelMatchViewModel(
                idSeason: idSeason,
                travel: travel
            )
        )
    }

    var body: some View {
        BackgroundImageContainerView(
            nameImages: [],
            bundle: Bundle.main,
            colors: [DSColors.background.swiftUIColor]
        )
        {
            VStack {
                FWScrollView {
                    VStack(spacing: Margins.veryLarge) {
                        teamView
                        dateView
                        hourAppointmentView
                        hourDepartureView
                        hourMatchView
                        priceBusView
                        priceMatchView
                        googleLinkView
                        telegramLinkView
                        trackingLinkView
                        descriptionMatchView
                        reportMatchView
                    }
                    .padding(.top, Margins.medium)
                }

                Spacer()

                FWButton(
                    title: "Sauvegarder",
                    state: viewModel.stateSave.toFWButtonState()
                ) {
                    Task {
                        if await viewModel.saveTravel() {
                            didUpdate?()
                            navigator.pop()
                        }
                    }
                }
                .enabled(viewModel.team != nil)
                .fwButtonStyle(.primary)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if let idTravel = viewModel.idTravel {
                        Button(
                            action: {
                                navigator.push(
                                    MenuAdminScreen.showMembersTravel(
                                        idTravel: idTravel,
                                        idSeason: viewModel.idSeason
                                    )
                                )
                        }) {
                            Image(systemName: "person.3.fill")
                                .foregroundColor(DSColors.red.swiftUIColor)
                        }
                    }

                }

            }
            .addBackButton(isPresented: isCreation) {
                navigator.pop()
            }
        }
        .navigationTitle(isCreation ? "Nouveau deplacement" :"Edition")
        .showBanner($viewModel.showError, text: SharedResources.commonErrorText, type: .error)
    }

    var teamView: some View {
        Button {

            navigator.presentSheet(.teams(currentTeam: viewModel.team, selectedTeam: { [viewModel] in
                viewModel.team = $0
            }), withNavigation: true)
        } label: {
            HStack {
                Text("Equipe: ")
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoBody)
                    .padding(.trailing, Margins.mediumSmall)

                Spacer()

                Text(viewModel.teamName)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoTitle3)
                    .padding(.trailing, Margins.mediumSmall)


                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(DSColors.red.swiftUIColor)
                    .frame(width: 20, height: 20)
            }
        }
    }

    var dateView: some View {
        HStack {
            Text("Date: ")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoBody)
                .padding(.trailing, Margins.mediumSmall)

            Spacer()

            DatePicker(selection: $viewModel.date, displayedComponents: .date) {
                Text("date:")

            }
            .labelsHidden()
            .colorMultiply(DSColors.white.swiftUIColor)
            .environment(\.colorScheme, .dark)

        }
    }

    var hourAppointmentView: some View {
        HStack {
            Text("Heure rendez-vous:")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoBody)
                .padding(.trailing, Margins.mediumSmall)

            Spacer()

            DatePicker(selection: $viewModel.appointmentTime, displayedComponents: .hourAndMinute) {
                Text("date:")

            }
            .environment(\.timeZone, TimeZone(identifier: "Europe/Paris")!)
            .labelsHidden()
            .colorMultiply(DSColors.white.swiftUIColor)
            .environment(\.colorScheme, .dark)

        }
    }

    var hourDepartureView: some View {
        HStack {
            Text("Heure de départ:")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoBody)
                .padding(.trailing, Margins.mediumSmall)

            Spacer()

            DatePicker(selection: $viewModel.departureTime, displayedComponents: .hourAndMinute) {
                Text("date:")

            }
            .environment(\.timeZone, TimeZone(identifier: "Europe/Paris")!)
            .labelsHidden()
            .colorMultiply(DSColors.white.swiftUIColor)
            .environment(\.colorScheme, .dark)

        }
    }

    var hourMatchView: some View {
        HStack {
            Text("Heure de du match:")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoBody)
                .padding(.trailing, Margins.mediumSmall)

            Spacer()

            DatePicker(selection: $viewModel.matchTime, displayedComponents: .hourAndMinute) {
                Text("date:")

            }
            .environment(\.timeZone, TimeZone(identifier: "Europe/Paris")!)
            .labelsHidden()
            .colorMultiply(DSColors.white.swiftUIColor)
            .environment(\.colorScheme, .dark)

        }
    }

    var priceBusView: some View {
        HStack {
            Text("Prix du bus:")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoBody)

            Spacer()

            HStack {
                TextField("", text: $viewModel.priceBus)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .frame(width: 60, height: 30, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(DSColors.red.swiftUIColor, lineWidth: 1)
                    )
                    .keyboardType(.decimalPad)
                    .onChange(of: viewModel.priceBus) { _, newValue in
                        var value = newValue
                        value.formattedDecimalText()
                        viewModel.priceBus = value
                    }

                Text("€")
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoBody)
            }

        }
    }

    var priceMatchView: some View {
        HStack {
            Text("Prix du match:")
                .foregroundStyle(DSColors.white.swiftUIColor)
                .font(DSFont.robotoBody)

            Spacer()

            HStack {
                TextField("", text: $viewModel.priceMatch)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .frame(width: 60, height: 30, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(DSColors.red.swiftUIColor, lineWidth: 1)
                    )
                    .keyboardType(.decimalPad)
                    .onChange(of: viewModel.priceMatch) { _, newValue in
                        var value = newValue
                        value.formattedDecimalText()
                        viewModel.priceMatch = value
                    }

                Text("€")
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoBody)
            }

        }
    }

    var descriptionMatchView: some View {
        VStack {
            HStack {
                Text("Description du déplacement:")
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoBody)
                    .padding(.trailing, Margins.mediumSmall)

                Spacer()
            }

            FWTextEditor(placeholder: "Saisir le texte", text: $viewModel.descriptionMatch)

        }
    }

    var googleLinkView: some View {
        FWTextField(
            title: "Lien google doc",
            placeholder: "saisir le lien google",
            text: $viewModel.googleDoc
        )
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
    }

    var telegramLinkView: some View {
        FWTextField(
            title: "Lien groupe Telegram",
            placeholder: "saisir le lien du groupe Télégram",
            text: $viewModel.telegram
        )
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
    }

    var trackingLinkView: some View {
        HStack {
            FWTextField(
                title: "Lien de suivi",
                placeholder: "saisir le lien de suivi",
                text: $viewModel.trackingLink
            )
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            Spacer()

            if viewModel.trackingLink.isOpenableURL,
               let url = URL(string: viewModel.trackingLink) {
                Button(action: {
                    navigator.presentSheet(MenuAdminScreen.openWebView(url: url))
                }, label: {
                   Image(systemName: "arrow.right.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(DSColors.red.swiftUIColor)
                        .frame(width: 32, height: 32)

                })
                .addSensoryFeedback()
                .padding(.leading, Margins.mediumSmall)
            }

        }

    }

    var reportMatchView: some View {
        VStack {
            HStack {
                Text("CR du déplacement:")
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.robotoBody)
                    .padding(.trailing, Margins.mediumSmall)

                Spacer()
            }

            FWTextEditor(placeholder: "Saisir le CR", text: $viewModel.reportMatch)

        }
    }
}


