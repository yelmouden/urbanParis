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
public struct MatosRepository: Sendable {
    public var retrieveMatos: @Sendable() async throws -> [Matos]
    public var isUpToDate: @Sendable() async throws -> Bool
}

extension MatosRepository: DependencyKey {
    public static var liveValue: MatosRepository {
        .init(retrieveMatos: {
            let matos: [Matos] = try await Database.shared.client
                .from(Database.Table.matos.rawValue)
                .select("*, sizes(title), images_matos(nameImage, order))")
                .order("id", ascending: false)
                .execute()
                .value

            return matos
        },
        isUpToDate: {
            guard let id = Database.shared.client.auth.currentUser?.id else {
                throw DatabaseClientError.notFoundId
            }

            let dico: [String: Bool] = try await Database.shared.client
                .from(Database.Table.matos_users.rawValue)
                .select("uptodate")
                .eq("idUser", value: id)
                .single()
                .execute()
                .value

            guard let value = dico["uptodate"] else {
                throw DatabaseClientError.valueNotFound
            }

            return value
        })
    }
}

public extension DependencyValues {
  var matosRepository: MatosRepository {
    get { self[MatosRepository.self] }
    set { self[MatosRepository.self] = newValue }
  }
}
