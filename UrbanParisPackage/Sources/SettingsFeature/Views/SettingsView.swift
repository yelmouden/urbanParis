//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 25/04/2024.
//

import DeviceKit
import DesignSystem
import FlowStacks
import SharedResources
import SwiftUI
import SwiftyEmail
import Utils

struct SettingsView: View {
    @EnvironmentObject var navigator: FlowNavigator<SettingsScreen>

    @Bindable var viewModel: SettingsViewModel
    @State var showAlertLogout = false
    @State private var showLogExporter = false

    var body: some View {
        BackgroundImageContainerView(nameImages: ["tenduEcharpe"], bundle: .module) {
            VStack {
                List {
                    Section {
                        itemMenu(title: "Contact", isSection: true)
                            .applyRowStyle()

                        HStack(spacing: Margins.medium) {
                            Assets.bug.swiftUIImage
                                .resizable()
                                .foregroundStyle(DSColors.red.swiftUIColor)
                                .frame(width: 20, height: 20)
                            itemMenu(title: "Signaler un bug")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .applyRowStyle()
                        .onTapGesture {
                            redirectEmailForBug()
                        }
                        .addSensoryFeedback()

                        HStack(spacing: Margins.medium) {
                            Assets.suggestion.swiftUIImage
                                .resizable()
                                .foregroundStyle(DSColors.red.swiftUIColor)
                                .frame(width: 20, height: 20)
                            itemMenu(title: "Apporter une idée d'amélioration")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .applyRowStyle()
                        .onTapGesture {
                            redirectEmailForImprovment()
                        }
                        .addSensoryFeedback()
                    }
                    .listSectionSeparator(.hidden, edges: .top)

                    Section {
                        itemMenu(title: "Mon compte", isSection: true)
                            .applyRowStyle()

                        HStack(spacing: Margins.medium) {
                            Assets.logout.swiftUIImage
                                .resizable()
                                .foregroundStyle(DSColors.red.swiftUIColor)
                                .frame(width: 20, height: 20)
                            itemMenu(title: "Se déconnecter")
                            Spacer()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                        .applyRowStyle()
                        .onTapGesture {
                            PopupManager.shared.showPopup(item: .alert( .init(
                                title: "Confirmation",
                                description: "Es-tu sûr de vouloir te déconnecter ?",
                                primaryButtonItem: .init(
                                    title: "Valider",
                                    asyncAction: { await viewModel.signOut() },
                                    isDestructive: true
                                ),
                                secondaryButtonItem: .cancel
                                )
                            ))
                        }
                        .addSensoryFeedback()

                    }

                    Section {
                        itemMenu(title: "Logs", isSection: true)
                            .applyRowStyle()

                        HStack(spacing: Margins.medium) {
                            Image(systemName: "square.and.arrow.down.fill")
                                .resizable()
                                .foregroundStyle(DSColors.red.swiftUIColor)
                                .frame(width: 20, height: 20)
                            itemMenu(title: "Télécharger les logs")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .applyRowStyle()
                        .onTapGesture {
                            showLogExporter = true
                        }
                        .addSensoryFeedback()
                    }
                }
                .listSectionSpacing(0)
                .listStyle(.plain)

            }
        }
        .sheet(isPresented: $showLogExporter) {
            if let logsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("debug.log") {
                    LogShareView(fileURL: logsURL)
                } else {
                    Text("Aucun fichier de log trouvé")
                        .foregroundStyle(DSColors.white.swiftUIColor)
                        .font(DSFont.robotoBodyBold)
                }
        }
        .navigationTitle("Parametres")
        .showBanner($viewModel.hasError, text: viewModel.errorText, type: .error)
    }

    private func itemMenu(title: String, isSection: Bool = false) -> some View {
        Text(title)
            .font(isSection ? DSFont.robotoBodyBold : DSFont.robotoBody)
            .foregroundStyle(isSection ? DSColors.red.swiftUIColor: DSColors.white.swiftUIColor)
            .padding(.top, isSection ? Margins.large : 0)
            .padding(.bottom, isSection ? Margins.medium : 0)
            .listRowBackground(Color.clear)
    }

    private func redirectEmailForBug() {

        SwiftyEmail.shared.sendEmail(
            subject: "Signaler un bug",
            body: "\n\n\n\nversion number: \(Bundle.main.versionNumber)\nbuild number: \(Bundle.main.versionNumber)\n device model: \(Device.current)",
            recipient: "urbanapp2017@gmail.com",
            completion: { _ in
            }
        )
    }

    private func redirectEmailForImprovment() {

        SwiftyEmail.shared.sendEmail(
            subject: String(localized: "Idée d'amélioration"),
            body: "",
            recipient: "urbanapp2017@gmail.com",
            completion: { _ in
            }
        )
    }
}


import SwiftUI
import UIKit

struct LogExportView: UIViewControllerRepresentable {
    let fileURL: URL

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forExporting: [fileURL])
        picker.shouldShowFileExtensions = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}
