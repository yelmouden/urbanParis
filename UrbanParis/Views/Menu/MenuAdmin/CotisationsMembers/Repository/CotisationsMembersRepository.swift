//
//  MembersRepository.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 28/11/2024.
//

import Database
import Dependencies
import DependenciesMacros
import Foundation
import ProfileManager
import SharedRepository
import Supabase
import Utils

@DependencyClient
struct CotisationsMembersRepository: Sendable {
    var retrieveCotisationsForMembers: @Sendable() async throws -> [CotisationsMember]
    var saveCotisations:  @Sendable(_ cotisations: [Cotisation], _ idProfile: Int) async throws -> Void
}

extension CotisationsMembersRepository: DependencyKey {
    static var liveValue: CotisationsMembersRepository {
        .init {
            let cotisationsMembers: [CotisationsMember] = try await Database.shared.client
                .from(Database.Table.profiles.rawValue)
                .select("id, firstname, lastname, cotisations(*)")
                .eq("cotisations.id_profile", value: 102)
                .execute()
                .value

            return cotisationsMembers
        } saveCotisations: { cotisation, idProfile in
            try await Database.shared.client
            .from(Database.Table.cotisations.rawValue)
            .upsert(cotisation, ignoreDuplicates: false)
              .execute()
        }
    }
}


extension DependencyValues {
    var cotisationsMembersRepository: CotisationsMembersRepository {
        get { self[CotisationsMembersRepository.self] }
        set { self[CotisationsMembersRepository.self] = newValue }
    }
}
