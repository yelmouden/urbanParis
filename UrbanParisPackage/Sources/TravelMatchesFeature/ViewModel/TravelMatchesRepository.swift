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
                .select("id, date, appointmentTime, departureTime, price, descriptionTravel, descriptionBar, report, timeMatch, googleDoc, telegram, numDay, team(id, name, logo), travels_seasons!inner(idSeason)")
                .eq("travels_seasons.idSeason", value: idSeason)
                .order("numDay")
                .execute()
                .value

            return travels
        })
    }
}

public extension DependencyValues {
  var travelMatchesRepository: TravelMatchesRepository {
    get { self[TravelMatchesRepository.self] }
    set { self[TravelMatchesRepository.self] = newValue }
  }
}
