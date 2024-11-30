//
//  CotisationsMembersViewModel.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 28/11/2024.
//


import Foundation
import Dependencies
import Observation
import ProfileManager
import Utils

struct CotisationsMembersGroup: Equatable {
    let key: String
    var profiles: [CotisationsMember]
}

@MainActor
@Observable
final class CotisationsMembersViewModel {
    @ObservationIgnored
    @Dependency(\.cotisationsMembersRepository) var repository

    var state: StateView<[CotisationsMembersGroup]> = .loading
    var showError = false

    private var sections: [CotisationsMembersGroup] = []

    func retrieveMembers() async {
        do {
            let members = try await repository.retrieveCotisationsForMembers()

            let sections = groupProfilesByFirstLetter(members)

            try Task.checkCancellation()

            self.sections = sections
            state = .loaded(sections)
        } catch {
            if !(error is CancellationError) {
                showError = true
            }
        }
    }

    func groupProfilesByFirstLetter(_ profiles: [CotisationsMember]) -> [CotisationsMembersGroup] {
        let grouped = Dictionary(grouping: profiles) { String($0.lastname.prefix(1)).uppercased() }

        return grouped.map { (key, value) in
            CotisationsMembersGroup(key: key, profiles: value.sorted { $0.lastname < $1.lastname })
        }.sorted { $0.key < $1.key }
    }

    func searchMembers(_ query: String) async throws {
        if query.isEmpty {
            try Task.checkCancellation()
            state = .loaded(sections)
        } else {
            let filtered = try sections.map { group in
                let filteredProfiles = group.profiles.filter { profile in
                    profile.lastname.lowercased().contains(query.lowercased())
                }
                try Task.checkCancellation()

                return CotisationsMembersGroup(key: group.key, profiles: filteredProfiles)
            }.filter {
                !($0.profiles.isEmpty)
            }
            try Task.checkCancellation()

            state = .loaded(filtered)
        }
    }

    func updateProfile(_ profile: CotisationsMember) {

        // Mettre à jour le profil dans les sections
        for i in 0..<self.sections.count {
            if let index = self.sections[i].profiles.firstIndex(where: { $0.id == profile.id }) {
                self.sections[i].profiles[index] = profile
            }
        }

    }
}
