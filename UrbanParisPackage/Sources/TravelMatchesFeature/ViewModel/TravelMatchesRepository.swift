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
public struct TravelMatchesRepository: Sendable {
    var retrieveSeasons: @Sendable() async throws -> [Season]
    var retrieveTravels: @Sendable(_ idSeason: Int) async throws -> [Travel]
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
                .select("id, date, appointmentTime, departureTime, price, descriptionTravel, descriptionBar, report, timeMatch, googleDoc, telegram, team(id, name, logo), travels_seasons!inner(idSeason), pool(id,title, limitDate, isMultipleChoices, proposals!proposals_idPool_fkey(id, title), responses!responses_idPool_fkey(idProposal, idProfile, idPool))")
                .eq("travels_seasons.idSeason", value: idSeason)
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
                .value
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
