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
import SwiftSoup
import Utils

enum TravelMatchesRepositoryError: Error {
    case malFormattedURL
    case errorGoogleForm
    case errorDatabase
    case googleDocMissing
    case badHTML
    case errorParsing
}

@DependencyClient
public struct TravelMatchesRepository: Sendable {
    var retrieveSeasons: @Sendable() async throws -> [Season]
    var retrieveTravels: @Sendable(_ idSeason: Int) async throws -> [Travel]
    var subscribeToTravel: @Sendable(_ idTravel: Int, _ idSeason: Int) async throws -> Void
    var checkAlreadySubscribe: @Sendable(_ idTravel: Int, _ idSeason: Int) async throws -> Bool
    var retrieveMyTravels: @Sendable(_ idSeason: Int) async throws -> [Travel]
    var saveResponses: @Sendable(_ responses: [Response]) async throws -> Void
    var deleteResponses: @Sendable(_ idProfile: Int, _ idPool: Int) async throws -> Void


}

extension TravelMatchesRepository: DependencyKey {
    public static var liveValue: TravelMatchesRepository {
        .init(retrieveSeasons: {
            let seasons: [Season] = try await Database.shared.client
                .from(Database.Table.seasons.rawValue)
                .select()
                .execute()
                .value

            return seasons
        },
        retrieveTravels: { idSeason in
            let travels: [Travel] = try await Database.shared.client
                .from(Database.Table.travels.rawValue)
                .select("id, date, appointmentTime, departureTime, price, descriptionTravel, descriptionBar, report, priceMatch, timeMatch, googleDoc, telegram, team(id, name, logo), travels_seasons!inner(idSeason), pool(id,title, limitDate, isMultipleChoices, isActive, proposals!proposals_idPool_fkey(id, title), responses!responses_idPool_fkey(idProposal, idProfile, idPool))")
                .eq("travels_seasons.idSeason", value: idSeason)
                .order("numMatch")
                .execute()
                .value

            return travels
        },
        subscribeToTravel: { idTravel, idSeason in
            let travelUser = TravelUser(idTravel: idTravel, idSeason: idSeason)

            try await Database.shared.client
                .from(Database.Table.travels_users.rawValue)
                .insert(travelUser)
                .execute()
        },
        checkAlreadySubscribe: { idTravel, idSeason in
            guard let id = Database.shared.client.auth.currentUser?.id else {
                throw DatabaseClientError.notFoundId
            }

            let result: Int? = try await Database.shared.client
                .from(Database.Table.travels_users.rawValue)
                .select("id", head: true, count: .exact)
                .eq("idTravel", value: idTravel)
                .eq("idUser", value: id)
                .eq("idSeason", value: idSeason)
                .execute()
                .count

            guard let result else { return false }
            return result != 0
        },
        retrieveMyTravels: { idSeason in
            guard let id = Database.shared.client.auth.currentUser?.id else {
                throw DatabaseClientError.notFoundId
            }

            let travels: [Travel] = try await Database.shared.client
                .from(Database.Table.travels.rawValue)
                .select("id, date, team(id, name, logo), travels_users!inner(idSeason)")
                .eq("travels_users.idSeason", value: idSeason)
                .eq("travels_users.isValidate", value: true)
                .eq("travels_users.idUser", value: id)
                .order("numMatch")
                .execute()
                .value

            return travels
        },
              saveResponses: { responses in
            try await Database.shared.client
                .from(Database.Table.responses.rawValue)
                .insert(responses)
                .execute()
        },
              deleteResponses: { idProfile, idPool in
            try await Database.shared.client
                .from(Database.Table.responses.rawValue)
                .delete()
                .eq("idProfile", value: idProfile)
                .eq("idPool", value: idPool)
                .execute()
        }

        )
    }
}

public extension DependencyValues {
    var travelMatchesRepository: TravelMatchesRepository {
        get { self[TravelMatchesRepository.self] }
        set { self[TravelMatchesRepository.self] = newValue }
    }
}
