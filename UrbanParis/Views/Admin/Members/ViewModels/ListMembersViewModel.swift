//
//  File.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 19/11/2024.
//

import Foundation
import Dependencies
import Logger
import Observation
import SharedModels
import SharedRepository
import ProfileManager
import Utils

struct ProfileGroup: Equatable {
    let key: String
    var profiles: [Profile]
}

@MainActor
@Observable
final class ListMembersViewModel {
    @ObservationIgnored
    @Dependency(\.profileRepository) var repository

    var state: StateView<[ProfileGroup]> = .loading
    var showError = false

    private var sections: [ProfileGroup] = []

    func retrieveMembers() async {
        do {
            state = .loading

            let members = try await repository.retrieveProfiles()
            let sections = groupProfilesByFirstLetter(members)

            try Task.checkCancellation()

            self.sections = sections
            state = .loaded(sections)
        } catch {
            if !(error is CancellationError) {
                showError = true
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }
    }

    func groupProfilesByFirstLetter(_ profiles: [Profile]) -> [ProfileGroup] {
        let grouped = Dictionary(grouping: profiles) { String($0.lastname.prefix(1)).uppercased() }

        return grouped.map { (key, value) in
            ProfileGroup(key: key, profiles: value.sorted { $0.lastname < $1.lastname })
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

                return ProfileGroup(key: group.key, profiles: filteredProfiles)
            }.filter {
                !($0.profiles.isEmpty)
            }
            try Task.checkCancellation()

            state = .loaded(filtered)
        }
    }

    func updateProfile(_ profile: Profile) {
        for i in 0..<self.sections.count {
            if let index = self.sections[i].profiles.firstIndex(where: { $0.id == profile.id }) {
                self.sections[i].profiles[index] = profile
            }
        }

    }
}
