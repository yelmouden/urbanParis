//
//  ProfileRepository.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 17/07/2025.
//

import Database
import Dependencies
import DependenciesMacros
import Foundation
import ProfileManager
import SharedModels
import Supabase

@DependencyClient
public struct ProfileRepository: Sendable {

    public var createMyProfile: (_ createProfileRequest: CreateProfileRequest, _ profileImageData: Data?) async throws -> Profile
    public var retrieveProfile: (_ id: UUID) async throws -> Profile?
    public var retrieveProfiles: () async throws -> [Profile]
    public var updateProfile: (_ id: Int, _ updateProfileRequest: UpdateProfileRequest, _ profileImageData: Data?) async throws -> Profile?
    public var deleteProfile: @Sendable(_ id: Int) async throws -> Void

}

extension ProfileRepository: DependencyKey {

    public static var liveValue: ProfileRepository {

        return .init(
            createMyProfile: { createProfileRequest, data in
                let createdProfile: Profile = try await Database.shared.client.from(Database.Table.profiles.rawValue)
                   .insert(createProfileRequest)
                   .select()
                   .single()
                   .execute()
                   .value

                if let data {
                    let _ = try? await Database.shared.client.storage
                        .from(Database.Storage.profiles.rawValue)
                        .upload(path: "img/\(createdProfile.id).png", file: data, options: .init(upsert: true))
                }

                return createdProfile

            },
            retrieveProfile: { id in
                let profile: Profile = try await Database.shared.client.from(Database.Table.profiles.rawValue)
                    .select("*")
                    .eq("idUser", value: id)
                    .single()
                    .execute()
                    .value

                return profile
            },
            retrieveProfiles: {
                let profiles: [Profile] = try await Database.shared.client
                    .from(Database.Table.profiles.rawValue)
                    .select("*")
                    .order("lastname", ascending: true)
                    .execute()
                    .value

                return profiles
            },
            updateProfile: { id, updateProfileRequest, data in
                var profile: Profile? = nil

                if !updateProfileRequest.isEmpty {
                    profile = try await Database.shared.client.from(Database.Table.profiles.rawValue)
                       .update(updateProfileRequest)
                       .eq("id", value: id)
                       .select("*")
                       .single()
                       .execute()
                       .value
                }


                if let data {
                    try await Database.shared.client.storage
                        .from(Database.Storage.profiles.rawValue)
                        .upload(path: "img/\(id).png", file: data, options: .init(upsert: true))
                }

                return profile
            },
            deleteProfile: { id in
                try await Database.shared.client
                    .from(Database.Table.profiles.rawValue)
                    .delete()
                    .eq("id", value: id)
                    .execute()
            }
        )
    }
}

public extension DependencyValues {
  var profileRepository: ProfileRepository {
    get { self[ProfileRepository.self] }
    set { self[ProfileRepository.self] = newValue }
  }
}
