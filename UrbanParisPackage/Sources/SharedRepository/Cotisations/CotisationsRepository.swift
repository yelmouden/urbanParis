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
    case errorDate
}

@DependencyClient
public struct CotisationsRepository: Sendable {
    public var retrieveCotisations: @Sendable(_ idProfile: Int) async throws -> [Cotisation]
    public var isUpToDate: @Sendable(_ idProfile: Int, _ date: String) async throws -> Bool
}

extension CotisationsRepository: DependencyKey {

    static func getCotisations(idProfile: Int) async throws -> [Cotisation] {
        let cotisations: [Cotisation] = try await Database.shared.client
            .from(Database.Table.cotisations.rawValue)
            .select()
            .eq("id_profile", value: idProfile)
            .execute()
            .value

        return cotisations.sorted { (a, b) -> Bool in
                let adjustedMonthA = (a.month + 4) % 12
                let adjustedMonthB = (b.month + 4) % 12
                return adjustedMonthA < adjustedMonthB
        }

        return cotisations
    }

    public static var liveValue: CotisationsRepository {
        .init(retrieveCotisations: { idProfile in
            return try await CotisationsRepository.getCotisations(idProfile: idProfile)
        }, isUpToDate: { idProfile, dateString in
            async let cotisationsResult: [Cotisation] = await CotisationsRepository.getCotisations(idProfile: idProfile)

            guard let date = Date.fromString(dateString) else {
                throw CotisationsRepositoryError.errorDate
            }

            let cotisations = try await cotisationsResult
            
            // on récupere le jour et le mois courant
            let calendar = Calendar.current
            

            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)

            // on check si les mois précedents sont a jour,
            // si jour > 15 du mois, on prend en compte le mois en cours

            if var index = cotisations.firstIndex(where: { $0.month == month }) {


                if day < 15 {
                    index -= 1
                }

                // on ignore la cotisation pour le mois d'août
                if index == 0 {
                    return true
                }

                // Nombre de mois à comptabiliser pour le montant total déjà payé à vérifier
                let nbMonth = index + 1

                var totalAmount: Float = 0
                while index >= 0 {
                    totalAmount += cotisations[index].amount
                    index -= 1
                }

                return (Float(totalAmount)) >= Float(((nbMonth) * 15))
            } else {
                let totalAmount: Float = cotisations.reduce(0) { partialResult, cotisation in
                    var total = partialResult
                    total += cotisation.amount

                    return total
                }

                return totalAmount >= 150
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
