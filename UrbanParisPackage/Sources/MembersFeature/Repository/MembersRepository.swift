//
//  File.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 19/11/2024.
//

import Database
import Dependencies
import DependenciesMacros
import Foundation
import ProfileManager
import Supabase
import Utils


@DependencyClient
public struct MembersRepository: Sendable {
    public var retrieveMembers: @Sendable() async throws -> [Profile]
}

extension MembersRepository: DependencyKey {
    public static var liveValue: MembersRepository {
        .init {
            let profiles: [Profile] = try await Database.shared.client
                .from(Database.Table.profiles.rawValue)
                .select()
                .order("lastname", ascending: true)
                .execute()
                .value

            return profiles
        }
    }
}

public extension DependencyValues {
    var membersRepository: MembersRepository {
        get { self[MembersRepository.self] }
        set { self[MembersRepository.self] = newValue }
    }
}
