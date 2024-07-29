//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 28/07/2024.
//

import Foundation
import DesignSystem
import FlowStacks
import SharedResources
import SwiftUI

struct TravelMatchView: View {
    @State var image: UIImage?
    
    @State var task: Task<Void, Never>?

    @EnvironmentObject var navigator: FlowNavigator<TravelMatchesScreen>

    @Bindable var travelVM: TravelMatchViewModel

    var body: some View {
        ZStack(alignment: .top) {

            VStack {
                FWScrollView {
                    VStack {
                        Text(travelVM.travel.team.name)
                            .font(DSFont.robotoTitle3)
                            .foregroundStyle(DSColors.white.swiftUIColor)
                            .padding(.bottom, travelVM.travel.date == nil && travelVM.travel.timeMatch == nil ? Margins.large : Margins.medium)
                            .padding(.top, 40)

                        if let date = travelVM.travel.date, let time = travelVM.travel.timeMatch {
                            Text("le \(date), à \(time.formattedHour)")
                                .font(DSFont.robotoBody)
                                .foregroundStyle(DSColors.white.swiftUIColor)
                                .padding(.bottom, Margins.large)
                        }

                        getTravelInfo()
                            .padding(.bottom, Margins.large)

                        getBarInfo()
                            .padding(.bottom, Margins.large)

                        getReport()
                            .padding(.bottom, Margins.large)


                        switch travelVM.state {
                        case .loaded(let isUpToDate) where isUpToDate == true:
                            VStack {
                                if let googleDoc = travelVM.travel.googleDoc {
                                    VStack {
                                        HStack {
                                            Text("listing déplacement")
                                                .font(DSFont.grafHeadline)
                                                .underline()
                                                .foregroundStyle(DSColors.white.swiftUIColor)
                                            Spacer()
                                        }
                                        .padding(.bottom, Margins.mediumSmall)

                                        Button(googleDoc) {
                                            if let url = URL(string: googleDoc) {
                                                navigator.presentSheet(.link(url))
                                            }
                                        }
                                        .foregroundStyle(DSColors.red.swiftUIColor)
                                    }
                                    .padding(.bottom, Margins.large)

                                }

                                if let telegram = travelVM.travel.telegram {
                                    VStack {
                                        HStack {
                                            Text("Page du déplacement")
                                                .font(DSFont.grafHeadline)
                                                .underline()
                                                .foregroundStyle(DSColors.white.swiftUIColor)
                                            Spacer()
                                        }
                                        .padding(.bottom, Margins.mediumSmall)

                                        Button(telegram) {
                                            if let url = URL(string: telegram) {
                                                navigator.presentSheet(.link(url))
                                            }
                                        }
                                        .foregroundStyle(DSColors.red.swiftUIColor)
                                    }
                                }
                            }
                        default: EmptyView()
                        }

                        Spacer()
                    }
                    .padding([.leading, .trailing], Margins.small)
                }

                Spacer()

                switch travelVM.state {
                case .loaded(let isUpToDate):
                    if !isUpToDate {
                        FWButton(title: "Accéder au listing", state: travelVM.state.toFWButtonState()) {
                            task = Task {
                                await travelVM.checkIsUpToDateContribution()
                            }
                        }
                        .fwButtonStyle(.primary)
                            .onAppear {
                                PopupManager.shared.showPopup(item: .alert( .init(
                                    title: "Cotisation",
                                    description: "Ta cotisation n'a pas été payée.\nPour accéder au listing, mets toi à jour.",
                                    primaryButtonItem: .init(
                                        title: "ok",
                                        isDestructive: true
                                    ),
                                    secondaryButtonItem: nil
                                    )
                                ))
                            }
                    } else {
                        EmptyView()
                    }


                default:
                    if travelVM.travel.googleDoc != nil || travelVM.travel.telegram != nil {
                        FWButton(title: "Accéder au listing", state: travelVM.state.toFWButtonState()) {
                            task = Task {
                                await travelVM.checkIsUpToDateContribution()
                            }
                        }

                        .fwButtonStyle(.primary)
                        .padding()
                    }

                }

            }
            .frame(maxWidth: .infinity)
            .background(DSColors.background.swiftUIColor.opacity(0.2))
            .addBorder(DSColors.red.swiftUIColor, cornerRadius: 12)
            .padding(.top, 32)

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 64, height: 64)

            } else {
                Assets.fanion.swiftUIImage
                    .resizable()
                    .frame(width: 64, height: 64)
            }

        }
        .task {
            self.image = await travelVM.travel.team.retrieveIcon()
        }
        .onDisappear {
            task?.cancel()
        }
        .showBanner($travelVM.showError, text: SharedResources.commonErrorText, type: .error)

    }

    func getTravelInfo() -> some View {
        VStack {
            HStack {
                Text("Infos déplacement")
                    .font(DSFont.grafHeadline)
                    .underline()
                    .foregroundStyle(DSColors.white.swiftUIColor)
                Spacer()
            }
            .padding(.bottom, Margins.mediumSmall)

            HStack {
                Text("Heure du rendez-vous :")
                    .font(DSFont.robotoBody)
                    .underline()
                    .foregroundStyle(DSColors.white.swiftUIColor)
                Spacer()
                if let appointmentTime = travelVM.travel.appointmentTime  {
                    Text(appointmentTime.formattedHour)
                        .font(DSFont.robotoBodyBold)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                } else {
                    Text("N.C.")
                        .font(DSFont.robotoBodyBold)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                }
            }
            .padding(.bottom, Margins.mediumSmall)

            HStack {
                Text("Heure de départ :")
                    .font(DSFont.robotoBody)
                    .underline()
                    .foregroundStyle(DSColors.white.swiftUIColor)
                Spacer()

                if let departureTime = travelVM.travel.departureTime  {
                    Text(departureTime.formattedHour)
                        .font(DSFont.robotoBodyBold)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                } else {
                    Text("N.C.")
                        .font(DSFont.robotoBodyBold)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                }

            }
            .padding(.bottom, Margins.mediumSmall)

            HStack {
                Text("Prix du bus :")
                    .font(DSFont.robotoBody)
                    .underline()
                    .foregroundStyle(DSColors.white.swiftUIColor)
                Spacer()

                if let price = travelVM.travel.price  {
                    Text(price.amountText)
                        .font(DSFont.robotoBodyBold)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                } else {
                    Text("N.C.")
                        .font(DSFont.robotoBodyBold)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                }

            }
            .padding(.bottom, Margins.mediumSmall)

            if let descriptionTravel = travelVM.travel.descriptionTravel {
                HStack {
                    Text(descriptionTravel)
                        .font(DSFont.robotoBody)
                        .underline()
                        .foregroundStyle(DSColors.white.swiftUIColor)
                    Spacer()
                }
                .padding(.bottom, Margins.mediumSmall)
            }
        }
    }

    func getBarInfo() -> some View {
        VStack {
            HStack {
                Text("Infos Buvette")
                    .font(DSFont.grafHeadline)
                    .underline()
                    .foregroundStyle(DSColors.white.swiftUIColor)
                Spacer()
            }
            .padding(.bottom, Margins.mediumSmall)

            if let descriptionBar = travelVM.travel.descriptionBar {
                HStack {
                    Text(descriptionBar)
                        .font(DSFont.robotoBody)
                        .underline()
                        .foregroundStyle(DSColors.white.swiftUIColor)
                    Spacer()
                }
                .padding(.bottom, Margins.mediumSmall)
            }

            if let pool = travelVM.travel.pool {
                PoolView(pool: pool)
            }
        }
    }

    func getReport() -> some View {
        VStack {
            HStack {
                Text("Compte-Rendu")
                    .font(DSFont.grafHeadline)
                    .underline()
                    .foregroundStyle(DSColors.white.swiftUIColor)
                Spacer()
            }
            .padding(.bottom, Margins.mediumSmall)

            if let report = travelVM.travel.report {
                HStack {
                    Text(report)
                        .font(DSFont.robotoBody)
                        .underline()
                        .foregroundStyle(DSColors.white.swiftUIColor)
                    Spacer()
                }
                .padding(.bottom, Margins.mediumSmall)
            } else {
                HStack {
                    Text("Pas de compte rendu du match")
                        .font(DSFont.robotoBody)
                        .underline()
                        .foregroundStyle(DSColors.white.swiftUIColor)
                }
                .padding(.bottom, Margins.mediumSmall)
            }
        }
    }
}
