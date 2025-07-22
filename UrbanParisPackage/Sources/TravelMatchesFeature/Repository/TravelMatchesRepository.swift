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
    public var retrieveSeasons: @Sendable() async throws -> [Season]
    public var retrieveTravels: @Sendable(_ idSeason: Int) async throws -> [Travel]
    var subscribeToTravel: @Sendable(_ idTravel: Int, _ idSeason: Int, _ idProfile: Int) async throws -> Void
    var checkAlreadySubscribe: @Sendable(_ idTravel: Int, _ idSeason: Int, _ idProfile: Int) async throws -> Bool
    var retrieveMyTravels: @Sendable(_ idSeason: Int, _ idProfile: Int) async throws -> [Travel]
    var saveResponses: @Sendable(_ responses: [Response]) async throws -> Void
    var deleteResponses: @Sendable(_ idProfile: Int, _ idPool: Int) async throws -> Void
    public var retrieveRegisteredMembers: @Sendable(_ idTravel: Int, _ idSeason: Int) async throws -> [RegisterProfileTravel]
    public var validateTravel: @Sendable(_ updatedRequest: UpdateValidationRequest) async throws -> Void
    public var addSeason: @Sendable(_ addSeasonRequest: AddSeasonRequest) async throws -> Void
    public var deleteSeason: @Sendable(_ idSeason: Int) async throws -> Void
    public var addProfileToTravel: @Sendable(_ idSeason: AddRegisterProfileTravelRequest) async throws -> Void
    public var retrieveTeams: @Sendable() async throws -> [Team]
    public var deleteTeam: (_ idTeam: Int) async throws -> Void
    public var addTeam: (_ addTeamRequest: AddTeamRequest) async throws -> Team
    public var updateTravel: (_ updateTravelRequest: UpdateTravelRequest, _ idTravel: Int?) async throws -> Void
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
                .select("id, date, appointmentTime, departureTime, price, descriptionTravel, descriptionBar, report, priceMatch, timeMatch, googleDoc, telegram, idSeason, team(id, name, logo), pool(id,title, limitDate, isMultipleChoices, isActive, proposals!proposals_idPool_fkey(id, title), responses!responses_idPool_fkey(idProposal, idProfile, idPool))")
                .eq("idSeason", value: idSeason)
                .order("date")
                .execute()
                .value

            return travels
        },
        subscribeToTravel: { idTravel, idSeason, idProfile in
            let travelUser = TravelUser(idTravel: idTravel, idSeason: idSeason, idProfile: idProfile)

            try await Database.shared.client
                .from(Database.Table.travels_users.rawValue)
                .insert(travelUser)
                .execute()
        },
        checkAlreadySubscribe: { idTravel, idSeason, idProfile in
            let result: Int? = try await Database.shared.client
                .from(Database.Table.travels_users.rawValue)
                .select("id", head: true, count: .exact)
                .eq("idTravel", value: idTravel)
                .eq("idProfile", value: idProfile)
                .eq("idSeason", value: idSeason)
                .execute()
                .count

            guard let result else { return false }
            return result != 0
        },
        retrieveMyTravels: { idSeason, idProfile in
            let travels: [Travel] = try await Database.shared.client
                .from(Database.Table.travels.rawValue)
                .select("id, date, team(id, name, logo), travels_users!inner(idSeason)")
                .eq("travels_users.idSeason", value: idSeason)
                .eq("travels_users.isValidate", value: true)
                .eq("travels_users.idProfile", value: idProfile)
                .order("date")
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
        }, retrieveRegisteredMembers: { idTravel, idSeason in
            let result: [RegisterProfileTravel] = try await Database.shared.client
                .from(Database.Table.travels_users.rawValue)
                .select("*, profiles(firstname, lastname) ")
                .eq("idTravel", value: idTravel)
                .eq("idSeason", value: idSeason)
                .execute()
                .value

            return result
        }, validateTravel: { updatedRequest in
            try await Database.shared.client
                .from(Database.Table.travels_users.rawValue)
                .update(updatedRequest)
                .eq("id", value: updatedRequest.id)
                .execute()
        }, addSeason: { request in
            try await Database.shared.client
                .from(Database.Table.seasons.rawValue)
                .insert(request)
                .execute()
        }, deleteSeason: { id in
            try await Database.shared.client
                .from(Database.Table.seasons.rawValue)
                .delete()
                .eq("id", value: id)
                .execute()
        }, addProfileToTravel: { request in
            try await Database.shared.client
                .from(Database.Table.travels_users.rawValue)
                .insert(request)
                .execute()
        }, retrieveTeams: {
            try await Database.shared.client
                .from(Database.Table.team.rawValue)
                .select()
                .execute()
                .value
        }, deleteTeam: { idTeam in
            try await Database.shared.client
                .from(Database.Table.team.rawValue)
                .delete()
                .eq("id", value: idTeam)
                .execute()
        }, addTeam: { addTeamRequest in
            try await Database.shared.client
                .from(Database.Table.team.rawValue)
                .insert(addTeamRequest)
                .select()
                .single()
                .execute()
                .value

        }, updateTravel: { updateTravelRequest, idTravel in
            if let idTravel {
                try await Database.shared.client
                    .from(Database.Table.travels.rawValue)
                    .update(updateTravelRequest)
                    .eq("id", value: idTravel)
                    .execute()
            } else {
                try await Database.shared.client
                    .from(Database.Table.travels.rawValue)
                    .insert(updateTravelRequest)
                    .execute()
            }
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
