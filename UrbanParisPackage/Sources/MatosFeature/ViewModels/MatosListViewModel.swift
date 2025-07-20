//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 05/08/2024.
//

import Foundation
import Dependencies
import Logger
import Observation
import SharedRepository
import Utils

@Observable
@MainActor
final class MatosListViewModel {
    @ObservationIgnored
    @Dependency(\.matosRepository) var repository

    var state: StateView<[Matos]> = .loading

    var showError = false

    func retrieveMatos() async {
        do {
            let matos = try await repository.retrieveMatos()
            try Task.checkCancellation()

            state = matos.isEmpty ? .empty : .loaded(matos)
        } catch {
            if !(error is CancellationError) {
                showError = true
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }
    }
}
