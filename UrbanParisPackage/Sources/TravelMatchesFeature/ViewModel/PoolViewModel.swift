//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 27/07/2024.
//

import Combine
import Dependencies
import Foundation
import ProfileManager
import Utils

@Observable
@MainActor
final class PoolViewModel {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository) var repository

    var cancellables = Set<AnyCancellable>()

    var idProfile: Int!

    var selectedProposal = [Proposal]()

    var pool: Pool

    var showError: Bool = false

    var hasAlreadyAnswered: Bool {
        guard let idProfile else { return false }
        return pool.hasUserAlreadyAnwsered(idProfile: idProfile)
    }

    var state: StateView<EmptyResource> = .empty

    init(pool: Pool) {
        self.pool = pool
        
        ProfileUpdateNotifier.shared.publisher
            .sink { [weak self] profile in
                self?.idProfile = profile?.id
            }
            .store(in: &cancellables)
    }

    func manageSelectedResponse(response: Proposal) {
        if let index = selectedProposal.firstIndex(of: response) {
            selectedProposal.remove(at: index)
        } else {
            selectedProposal.append(response)
        }
    }

    func isSelectedResponse(response: Proposal) -> Bool {
        return selectedProposal.contains(response)
    }

    func saveResponses() async {
        do {
            state = .loading

            let responses = selectedProposal.map { Response(idProposal: $0.id, idProfile: idProfile, idPool: pool.id)}

            try await repository.saveResponses(responses)
            
            try Task.checkCancellation()

            selectedProposal.removeAll()

            pool.responses.append(contentsOf: responses)

            state = .idle
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
            }
        }
    }

    func deleteResponses() async {
        guard let idProfile else { return }

        do {
            state = .loading

            try await repository.deleteResponses(idProfile, pool.id)

            try Task.checkCancellation()

            pool.responses.removeAll(where: { $0.idProfile == idProfile })
            state = .idle
        } catch {
            if !(error is CancellationError) {
                showError = true
                state = .idle
            }
        }
    }

    func isProposalChoosenByUser(idProposal: Int) -> Bool {
        guard let idProfile else { return false }
        
        for response in pool.responses {
            if response.idProfile == idProfile, response.idProposal == idProposal {
                return true
            }
        }

        return false
    }
}
