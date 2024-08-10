//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 23/05/2024.
//

import Combine
import CombineExt
import ConcurrencyExtras
import Database
import Dependencies
import DependenciesMacros
import Foundation
import Supabase

@MainActor
public class ProfileUpdateNotifier {
    private let subject: PassthroughSubject<Profile?, Never>

    public let publisher: AnyPublisher<Profile?, Never>

    public static let shared = ProfileUpdateNotifier()

    init() {
        self.subject = PassthroughSubject<Profile?, Never>()
        self.publisher = subject.share(replay: 1).eraseToAnyPublisher()
    }

    public func send(profile: Profile?) {
        subject.send(profile)
    }
}

@DependencyClient
public struct ProfileManager: Sendable {

    public var createProfile: (_ profile: Profile, _ profileImageData: Data?) async throws -> Void
    public var retrieveProfile: () async throws -> Void
    public var updateProfile: (_ profile: Profile, _ profileImageData: Data?) async throws -> Void

}

extension ProfileManager: DependencyKey {

    public static var liveValue: ProfileManager {

        return .init(
            createProfile: { profile, data in
                let createdProfile: Profile = try await Database.shared.client.from(Database.Table.profiles.rawValue)
                   .upsert(profile)
                   .select()
                   .single()
                   .execute()
                   .value

                if let id = createdProfile.id, let data {
                    let _ = try? await Database.shared.client.storage
                        .from(Database.Storage.profiles.rawValue)
                        .upload(path: "img/\(id).png", file: data, options: .init(upsert: true))
                }

                await ProfileUpdateNotifier.shared.send(profile: createdProfile)

            },
            retrieveProfile: {
                guard let id = Database.shared.client.auth.currentUser?.id else {
                    throw DatabaseClientError.notFoundId
                }

                let profiles: [Profile] = try await Database.shared.client.from(Database.Table.profiles.rawValue)
                    .select()
                    .eq("idUser", value: id)
                    .limit(1)
                    .execute()
                    .value

                await ProfileUpdateNotifier.shared.send(profile: profiles.first)

            },

            updateProfile: { profile, data in
                guard let id = profile.id else {
                    throw DatabaseClientError.notFoundId
                }

                try await Database.shared.client.from(Database.Table.profiles.rawValue)
                   .update(profile)
                   .eq("id", value: id)
                   .execute()

                if let data {
                    try await Database.shared.client.storage
                        .from(Database.Storage.profiles.rawValue)
                        .upload(path: "img/\(id).png", file: data, options: .init(upsert: true))
                }


               await ProfileUpdateNotifier.shared.send(profile: profile)
            }
        )
    }
}

public extension DependencyValues {
  var profileManager: ProfileManager {
    get { self[ProfileManager.self] }
    set { self[ProfileManager.self] = newValue }
  }
}
