//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 10/08/2024.
//

import DesignSystem
import FlowStacks
import Photos
import SwiftUI
import Utils
import WebKit

struct TravelMatchFormView: View {
    @EnvironmentObject var navigator: FlowNavigator<TravelMatchesScreen>

    @State private var formSubmitted = false
    @State private var wkWebView: WKWebView?
    @State private var displayAlertScreenShot = false
    @State private var showLoadingScreenshot = false
    @State private var showErrorScreenshot = false
    @State private var showErrorPermission = false
    @State private var showErrorURL = false
    @State private var task: Task<Void, Never>?


    @Bindable var viewModel: TravelMatchFormViewModel
    let onSubscribeSucceeded: (() -> Void)

    var body: some View {
        BackgroundImageContainerView(nameImages: ["fumis"], bundle: .module) {
            ZStack {
                if let path = viewModel.travel.googleDoc, let url = URL(string: path) {
                    GoogleFormView(url: url, wkWebView: $wkWebView, formSubmitted: $formSubmitted)
                        .padding(.top)
                } else {
                    Color.clear
                        .onAppear {
                            showErrorURL = true
                        }
                }

                switch viewModel.state {
                case .loading:
                    CircularLoader(title: "Sauvegarde")
                default:
                    EmptyView()
                }

                if showLoadingScreenshot {
                    CircularLoader(title: "Génération du screenshot")
                }
            }
            .alert("Souhaites-tu faire un screenshot de la confirmation d'inscription", isPresented: $displayAlertScreenShot) {
                Button {
                    wkWebView?.takeSnapshot(with: .init(), completionHandler: { image, error in
                        if let image {
                            saveImageToPhotosAlbum(image: image) {
                                showErrorPermission = !$0

                                if $0 {
                                    navigator.dismiss()
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        navigator.dismiss()
                                    }
                                }
                            }

                        } else {
                            showLoadingScreenshot = false
                            showErrorScreenshot = true

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                navigator.dismiss()
                            }
                        }
                    })
                } label: {
                    Text("Oui")
                }

                Button("Non", role: .cancel) { 
                    navigator.dismiss()
                }
            }
        }
        .onChange(of: formSubmitted, { _, newValue in
            if newValue {
                task = Task {
                    if await viewModel.register() {
                        onSubscribeSucceeded()
                        self.displayAlertScreenShot = true
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.displayAlertScreenShot = true
                        }
                    }
                }
            }
        })
        .showBanner($viewModel.showError, text: viewModel.errorText, type: .error)
        .showBanner($showErrorScreenshot, text: "Impossible de générer le screenshot", type: .error)
        .showBanner($showErrorPermission, text: "Accès aux photos à été refusé", type: .error)
        .showBanner($showErrorURL, text: "Problème avec l'url du formulaire", type: .error)
        .addBackButton(isPresented: true, action: {
            task?.cancel()

            navigator.dismiss()
        })

        .navigationTitle("Inscription")
    }

    func saveImageToPhotosAlbum(image: UIImage,  callback: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                callback(true)
            case .denied, .restricted:
                callback(false)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { newStatus in
                                if newStatus == .authorized || newStatus == .limited {
                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                    callback(true)
                                } else {
                                    callback(false)

                                }
                            }
            case .limited:
                // For iOS 14 and above, when the user grants limited access
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                callback(true)
            @unknown default:
                print("Unknown status")
                callback(false)

            }
        }
    }
}
