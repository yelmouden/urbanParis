//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 25/07/2024.
//

import Dependencies
import Foundation
import Observation
import Utils

@Observable
final class CotisationsViewModel {
    @ObservationIgnored
    @Dependency(\.cotisationsRepository) var repository

    var state: StateView<[Cotisation]> = .loading
    var isRequesting = false
    var showError = false

    @MainActor
    func retrieveCotisations(isFromResfresh: Bool = false) async {
        do {
            let items = try await repository.retrieveCotisations()

            self.state = items.isEmpty ? .empty : .loaded(items)
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
            }
        }
    }
}
