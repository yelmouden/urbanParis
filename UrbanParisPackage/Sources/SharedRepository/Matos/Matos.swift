//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 05/08/2024.
//

import Database
import Foundation
import Supabase
import UIKit

public struct Matos: Decodable, Equatable, Identifiable {
    public let id: Int
    public let description: String?
    public let price: Float?
    public let limitDate: String?
    public let link: String?
    public let sizes: [Size]
    public let images: [ImageMatos]

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case price
        case limitDate
        case link
        case sizes
        case images = "images_matos"
    }
    
    public  init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Matos.CodingKeys> = try decoder.container(keyedBy: Matos.CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: Matos.CodingKeys.id)
        self.description = try container.decodeIfPresent(String.self, forKey: Matos.CodingKeys.description)
        self.price = try container.decodeIfPresent(Float.self, forKey: Matos.CodingKeys.price)
        self.link = try container.decodeIfPresent(String.self, forKey: Matos.CodingKeys.link)

        let sizes = try container.decode([Size].self, forKey: Matos.CodingKeys.sizes)
        
        self.sizes = sizes.sorted {
            $0.order < $1.order
        }

        self.images = try container.decode([ImageMatos].self, forKey: Matos.CodingKeys.images)

        // Transformer la chaîne de caractères en Date
        let dateString = try container.decodeIfPresent(String.self, forKey: .limitDate)

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateString, let dateString = inputFormatter.date(from: date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"

            self.limitDate = outputFormatter.string(from: dateString)

        } else {
            self.limitDate = nil
        }

    }

}

public extension Matos {
    func retrieveImages(width: Int, height: Int) async -> [URL] {
        let imgs = await withTaskGroup(of: (URL?, Int).self) { group -> [URL] in
            for image in images {
                group.addTask {
                    let url = try? await Database.shared.client.storage
                        .from(Database.Storage.matos.rawValue)
                        .createSignedURL(path: "img/\(image.nameImage)", expiresIn: 60, transform: .init(width: width, height: height))
                    return (url, image.order)
                }

            }

            var collected = [(URL, Int)]()

            for await value in group {
                guard let url = value.0 else { continue }
                collected.append((url, value.1))
            }

            return collected.sorted { $0.1 < $1.1 }.map(\.0)

        }
        
        return imgs
    }
}
