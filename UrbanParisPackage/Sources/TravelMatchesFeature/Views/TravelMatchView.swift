//
//  File.swift
//
//
//  Created by Yassin El Mouden on 28/07/2024.
//

import Foundation
import DesignSystem
import FlowStacks
import SDWebImageSwiftUI
import SharedResources
import SwiftUI

struct TravelMatchView: View {
    @State var url: URL?

    @State var task: Task<Void, Never>?

    @EnvironmentObject var navigator: FlowNavigator<TravelMatchesScreen>

    @Bindable var travelVM: TravelMatchViewModel

    var body: some View {
        ZStack(alignment: .top) {

            VStack {
                FWScrollView {
                    VStack {
                        Text(travelVM.travel.team?.name ?? "Equipe non définie")
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

                        if travelVM.isPast {
                            getReport()
                                .padding(.bottom, Margins.large)
                        } else {
                            getTravelInfo()
                                .padding(.bottom, Margins.large)
                        }

                        if travelVM.canAccessListing {
                            VStack {
                                VStack {
                                    HStack {
                                        Text("listing deplacement")
                                            .font(DSFont.grafHeadline)
                                            .foregroundStyle(DSColors.white.swiftUIColor)
                                        Spacer()
                                    }
                                    .padding(.bottom, Margins.mediumSmall)

                                    if travelVM.travel.hasSubscribed {
                                        HStack {
                                            Spacer()
                                            Text("Tu es inscrit pour le déplacement")
                                                .font(DSFont.robotoTitle3)
                                                .foregroundStyle(DSColors.success.swiftUIColor)
                                            Spacer()
                                        }
                                        .padding(.bottom, Margins.mediumSmall)


                                    } else if let googleDoc = travelVM.travel.googleDoc {
                                        FWButton(title: "S'inscrire") {
                                            if let url = URL(string: googleDoc) {

                                                navigator.presentSheet(.register(travel: travelVM.travel, idSeason: travelVM.idSeason, onSubscribeSucceeded: travelVM.onSubscribeSucceeded), withNavigation: true)
                                            }
                                        }
                                        .fwButtonStyle(.primary)

                                    }

                                }
                                .padding(.bottom, Margins.large)



                                if let telegram = travelVM.travel.telegram {
                                    VStack {
                                        HStack {
                                            Text("Page du deplacement")
                                                .font(DSFont.grafHeadline)
                                                .foregroundStyle(DSColors.white.swiftUIColor)
                                            Spacer()
                                        }
                                        .padding(.bottom, Margins.mediumSmall)

                                        FWButton(title: "Lien Télégram") {
                                            if let url = URL(string: telegram) {
                                                navigator.presentSheet(.link(url))
                                            }
                                        }
                                        .fwButtonStyle(.primary)
                                    }
                                }
                            }
                        }
                    }
                    .padding([.leading, .trailing], Margins.small)
                }

                Spacer()

                if !travelVM.canAccessListing, travelVM.isActive, !travelVM.isPast {
                    FWButton(title: "Accéder au listing", state: travelVM.state.toFWButtonState()) {
                        task = Task {
                            await travelVM.checkIsUpToDateContribution()
                        }
                    }

                    .fwButtonStyle(.primary)
                    .padding()
                }

            }
            .frame(maxWidth: .infinity)
            .background(DSColors.background.swiftUIColor.opacity(0.2))
            .addBorder(DSColors.red.swiftUIColor, cornerRadius: 12)
            .padding(.top, 32)

            if let url {
                WebImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 64, height: 64)
                        .scaledToFit()
                } placeholder: {
                    Assets.fanion.swiftUIImage
                        .resizable()
                        .frame(width: 64, height: 64)
                }

            } else {
                Assets.fanion.swiftUIImage
                    .resizable()
                    .frame(width: 64, height: 64)
            }

        }
        .task(id: travelVM) {
            await travelVM.checkAlreadySubscribe()
        }
        .onDisappear {
            task?.cancel()
        }
        .onChange(of: travelVM.showAlertCotisation, { _, newValue in

            if newValue {
                PopupManager.shared.showPopup(item: .alert( .init(
                    title: "Cotisation",
                    description: "Ta cotisation n'a pas été payée.\nPour accéder au listing, mets toi à jour.",
                    primaryButtonItem: .init(
                        title: "ok",
                        action: {
                            travelVM.showAlertCotisation = false
                        },
                        isDestructive: true
                    ),
                    secondaryButtonItem: nil
                )
                ))

            }
        })
        .onChange(of: travelVM.showAlertMatos, { _, newValue in

            if newValue {
                PopupManager.shared.showPopup(item: .alert( .init(
                    title: "Matos",
                    description: "Tu n'es pas à jour dans le paiement de ton matos.\nPour accéder au listing, mets toi à jour.",
                    primaryButtonItem: .init(
                        title: "ok",
                        action: {
                            travelVM.showAlertMatos = false
                        },
                        isDestructive: true
                    ),
                    secondaryButtonItem: nil
                )
                ))

            }
        })
        .showBanner($travelVM.showError, text: SharedResources.commonErrorText, type: .error)

    }

    func getTravelInfo() -> some View {
        VStack {
            HStack {
                Text("Infos deplacement")
                    .font(DSFont.grafHeadline)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                Spacer()
            }
            .padding(.bottom, Margins.mediumSmall)

            HStack {
                Text("Heure du rendez-vous :")
                    .font(DSFont.robotoBody)
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
                Text("Prix de la place :")
                    .font(DSFont.robotoBody)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                Spacer()

                if let price = travelVM.travel.priceMatch  {
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

            HStack {
                Text("Prix du bus :")
                    .font(DSFont.robotoBody)
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
                        .fixedSize(horizontal: false, vertical: true)
                        .font(DSFont.robotoBody)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                    Spacer()
                }
                .padding(.bottom, Margins.mediumSmall)
            }
        }
    }

    /*func getBarInfo() -> some View {
        VStack {
            HStack {
                Text("Infos Buvette")
                    .font(DSFont.grafHeadline)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                Spacer()
            }
            .padding(.bottom, Margins.mediumSmall)

            if let descriptionBar = travelVM.travel.descriptionBar {
                HStack {
                    Text(descriptionBar)
                        .font(DSFont.robotoBody)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                    Spacer()
                }
                .padding(.bottom, Margins.mediumSmall)
            }

            if let pool = travelVM.travel.pool, pool.isActive {
                PoolView(pool: pool)
            }
        }
    }*/

    func getReport() -> some View {
        VStack {
            HStack {
                Text("Compte-Rendu")
                    .font(DSFont.grafHeadline)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                Spacer()
            }
            .padding(.bottom, Margins.mediumSmall)

            if let report = travelVM.travel.report {
                HStack {
                    Text(report)
                        .font(DSFont.robotoBody)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                    Spacer()
                }
                .padding(.bottom, Margins.mediumSmall)
            } else {
                HStack {
                    Text("Pas de compte rendu du match")
                        .font(DSFont.robotoBody)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                }
                .padding(.bottom, Margins.mediumSmall)
            }
        }
    }
}
