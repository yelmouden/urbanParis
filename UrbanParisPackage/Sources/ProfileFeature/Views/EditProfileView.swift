//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 19/07/2024.
//

import DesignSystem
import FlowStacks
import SwiftUI
import Utils

public struct EditProfileView: View, KeyboardReadable {
    @EnvironmentObject var navigator: FlowNavigator<ProfileScreen>

    @State var appearMen = false
    @State var fakeState: FWButtonState = .idle

    @State var year: Int = Date.currentYear

    @State var aboType: AboType?

    public init() {}

    public var body: some View {
        let _ = print("heee ", Bundle.module.path(forResource: "susic", ofType: "pdf"))
        BackgroundImageContainerView(
            images: [
                //UIImage(named:  Assets.susic.name, in: Bundle.module, with: nil)!,
                imageFromPDF(named: "susic")!,
                imageFromPDF(named: "rai")!,
                imageFromPDF(named: "pauleta")!,
                imageFromPDF(named: "sakho")!,

                /*Assets.susic.name
                Assets.susic.swiftUIImage,
                Assets.rai.swiftUIImage,
                Assets.pauleta.swiftUIImage,
                //Assets.pastore.swiftUIImage,
                Assets.sakho.swiftUIImage*/
            ])
        {
            VStack {
                FWScrollView {
                    VStack(spacing: Margins.medium) {
                        FWTextField(
                            title: "Ton prénom",
                            placeholder: "Saissis ton prénom",
                            text: .constant("")
                        )
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .padding(.top, Margins.medium)

                        FWTextField(
                            title: "Ton nom",
                            placeholder: "Saisis ton nom",
                            text: .constant("")
                        )
                        .autocorrectionDisabled()


                        FWTextField(
                            title: "Ton surnom",
                            placeholder: "Saisis ton surnom",
                            text: .constant("")
                        )
                        .autocorrectionDisabled()


                        HStack {
                            VStack {
                                Text("Ton année d'entrée dans le groupe")
                                    .font(DSFont.grafHeadline)
                            }

                            Spacer()
                        }

                        HStack {
                            Button(action: {
                                year -= 1
                                year = max(2017, year)
                            }, label: {
                                Image(systemName: "chevron.left.circle.fill")
                                    .resizable()
                                    .foregroundStyle(DSColors.red.swiftUIColor)
                                    .frame(width: 30, height: 30)
                            })
                            .padding(.trailing, Margins.extraLarge)
                            .addSensoryFeedback()

                            Text(verbatim: "\(year)")
                                .foregroundStyle(DSColors.white.swiftUIColor)

                            Button(action: {
                                year += 1
                                year = min(year, Date.currentYear)
                            }, label: {
                                Image(systemName: "chevron.right.circle.fill")
                                    .resizable()
                                    .foregroundStyle(DSColors.red.swiftUIColor)
                                    .frame(width: 30, height: 30)
                            })
                            .padding(.leading, Margins.extraLarge)
                            .addSensoryFeedback()

                        }

                        SelectableViews(title: "Ton type d'abonnement au Parc", items: [AboType.aboPSG, .aboCUP, .none ], selectedItem: $aboType)
                            .padding(.bottom, Margins.extraLarge)

                    }
                }
                .zIndex(2)

                Spacer()

                VStack {
                    if appearMen {
                        HStack() {
                            SmokeManView(orientation: .right)

                            Spacer()

                            SmokeManView(orientation: .left)
                        }
                        .offset(.init(width: 0, height: 21))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }


                    FWButton(
                        title: "Valider",
                        state: fakeState,
                        action: {
                            Task {
                                fakeState = .loading
                                try await Task.sleep(for: .seconds(2))
                                fakeState = .success
                                try await Task.sleep(for: .seconds(1))
                                fakeState = .idle
                            }

                            /*task?.cancel()

                             task = Task {
                             await viewModel.signUp(email: email, password: password)
                             }*/
                        })
                    //.enabled(email.isValidEmail() && isValidPassword)
                    .fwButtonStyle(.primary)
                    .addSensoryFeedback()
                    .padding(.bottom, Margins.small)
                }

            }

        }
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            withAnimation {
                appearMen = !newIsKeyboardVisible
            }
                    }
        .interactiveDismissDisabled()
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Créer ton profil")
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.bouncy(duration: 0.6)) {
                    appearMen = true
                }
            }
        }
    }
}


func imageFromPDF(named pdfName: String, pageNumber: Int = 1) -> UIImage? {
    // Obtenir l'URL du PDF dans le bundle
    guard let url = Bundle.module.url(forResource: pdfName, withExtension: "pdf"),
          let pdfDocument = CGPDFDocument(url as CFURL) else {
        print("PDF not found")
        return nil
    }

    // Vérifier si la page demandée existe
    guard let pdfPage = pdfDocument.page(at: pageNumber) else {
        print("Could not get PDF page")
        return nil
    }

    // Obtenir le rectangle de la page
    let pageRect = pdfPage.getBoxRect(.mediaBox)

    // Créer un renderer pour dessiner le PDF dans une image
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)

    // Rendre la page PDF en UIImage
    let image = renderer.image { context in
        // Préparer le contexte pour Quartz
        context.cgContext.saveGState()

        // Flip le contexte pour les coordonnées Quartz
        context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
        context.cgContext.scaleBy(x: 1.0, y: -1.0)

        // Dessiner la page PDF dans le contexte
        context.cgContext.drawPDFPage(pdfPage)

        // Restaurer l'état du contexte
        context.cgContext.restoreGState()
    }

    return image
}
