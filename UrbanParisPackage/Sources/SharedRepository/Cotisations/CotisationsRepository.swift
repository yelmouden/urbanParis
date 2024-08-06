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

enum CotisationsRepositoryError: Error {
    case urlMalFormatted
}

@DependencyClient
public struct CotisationsRepository: Sendable {
    public var retrieveCotisations: @Sendable() async throws -> [Cotisation]
    public var isUpToDate: @Sendable() async throws -> Bool
}

extension CotisationsRepository: DependencyKey {

    static var cotisations: [Cotisation] {
        get async throws {
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
        }
    }

    public static var liveValue: CotisationsRepository {
        .init(retrieveCotisations: {
            return try await cotisations
        }, isUpToDate: {
            guard let id = Database.shared.client.auth.currentUser?.id else {
                throw DatabaseClientError.notFoundId
            }

            async let cotisationsResult: [Cotisation] = await cotisations

            let apiKey: String = ConfigurationReader.value(for: "TIMEZONE_DB_API_KEY")
            let urlString = "http://api.timezonedb.com/v2.1/get-time-zone?key=\(apiKey)&format=json&by=zone&zone=Europe/Paris"

            guard let url = URL(string: urlString) else {
                throw CotisationsRepositoryError.urlMalFormatted
            }

            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 5
            configuration.timeoutIntervalForResource = 5

            let session = URLSession(configuration: configuration)
            async let dataRequest = try await session.data(for: .init(url: url)).0

            let date: Date

            do {
                let data = try await dataRequest

                if let json = try JSONSerialization .jsonObject(with: data, options: []) as? [String: Any],
                   let timestamp = json["timestamp"] as? TimeInterval {
                    let dateFormatter = ISO8601DateFormatter()

                    date =  Date(timeIntervalSince1970: timestamp)

                } else {
                    date = Date()
                }
            } catch {
                date = Date()
            }

            let cotisations = try await cotisationsResult
            
            // on récupere le jour et le mois courant
            let calendar = Calendar.current
            

            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)

            // on check si les mois précedents sont a jour,
            // si jour > 15 du mois, on prend en compte le mois en cours

            if var index = cotisations.firstIndex(where: { $0.month == month }) {
                // on ignore la cotisation pour le mois d'août
                if index == 0 {
                    return true
                }

                var totalAmount: Float = 0

                if day < 15 {
                    index -= 1
                }

                while index >= 0 {
                    totalAmount += cotisations[index].amount
                    index -= 1
                }

                return totalAmount == 0
            } else {
                let totalAmount: Float = cotisations.reduce(0) { partialResult, cotisation in
                    var total = partialResult
                    total += cotisation.amount

                    return total
                }

                return totalAmount == 0
            }
        })
    }
}

public extension DependencyValues {
  var cotisationsRepository: CotisationsRepository {
    get { self[CotisationsRepository.self] }
    set { self[CotisationsRepository.self] = newValue }
  }
}
