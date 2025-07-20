//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 25/07/2024.
//

import Combine
import Dependencies
import Foundation
import SharedRepository
import Logger
import ProfileManager
import Observation
import Utils

@Observable
@MainActor
final class CotisationsViewModel {
    @ObservationIgnored
    @Dependency(\.cotisationsRepository) var repository

    var state: StateView<[Cotisation]> = .loading
    var isRequesting = false
    var showError = false

    var cancellables = Set<AnyCancellable>()

    var idProfile: Int?

    init() {
        ProfileUpdateNotifier.shared.publisher
            .prefix(1)
            .sink { [weak self] profile in
                self?.idProfile = profile?.id
            }
            .store(in: &cancellables)
    }

    @MainActor
    func retrieveCotisations(isFromResfresh: Bool = false) async {
        do {
            guard let idProfile else {
                showError = true
                return
            }

            let items = try await repository.retrieveCotisations(idProfile)

            self.state = items.isEmpty ? .empty : .loaded(items)
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
                AppLogger.error(error.decodedOrLocalizedDescription)

                printLogFileContent()
            }
        }
    }

    func printLogFileContent() {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("❌ Impossible d'accéder au dossier Documents")
            return
        }

        let logFileURL = documentsDirectory.appendingPathComponent("debug.log")

        guard fileManager.fileExists(atPath: logFileURL.path) else {
            print("❌ Le fichier debug.log n'existe pas")
            return
        }

        do {
            let logContent = try String(contentsOf: logFileURL, encoding: .utf8)
            print("📄 Contenu de debug.log :\n\(logContent)")
        } catch {
            print("❌ Erreur lors de la lecture du fichier : \(error)")
        }
    }
}
