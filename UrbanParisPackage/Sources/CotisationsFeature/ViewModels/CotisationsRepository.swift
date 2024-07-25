//
//  File.swift
//
//
//  Created by Yassin El Mouden on 31/05/2024.
//

import Database
import Dependencies
import DependenciesMacros
import Foundation
import Supabase
import Utils

@DependencyClient
public struct CotisationsRepository: Sendable {
    var retrieveCotisations: @Sendable() async throws -> [Cotisation]
}

extension CotisationsRepository: DependencyKey {
    public static var liveValue: CotisationsRepository {
        .init(retrieveCotisations: {
            guard let id = Database.shared.client.auth.currentUser?.id else {
                throw DatabaseClientError.notFoundId
            }

            let cotisations: [Cotisation] = try await Database.shared.client
                .from(Database.Table.cotisations.rawValue)
                .select()
                .eq("idUser", value: id)
                .execute()
                .value

            return cotisations.sorted { (a, b) -> Bool in
                    let adjustedMonthA = (a.month + 4) % 12
                    let adjustedMonthB = (b.month + 4) % 12
                    return adjustedMonthA < adjustedMonthB
            }

            return cotisations
        })
    }
}

public extension DependencyValues {
  var cotisationsRepository: CotisationsRepository {
    get { self[CotisationsRepository.self] }
    set { self[CotisationsRepository.self] = newValue }
  }
}
