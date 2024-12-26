//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 27/07/2024.
//

import Foundation

public struct Pool: Equatable, Codable {
    public let id: Int
    public let title: String
    public let limitDate: Date?
    public let proposals: [Proposal]
    public var responses: [Response]
    public let isMultipleChoices: Bool
    public let isActive: Bool


    enum CodingKeys: CodingKey {
        case id
        case title
        case limitDate
        case responses
        case isMultipleChoices
        case proposals
        case isActive
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Pool.CodingKeys> = try decoder.container(keyedBy: Pool.CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: Pool.CodingKeys.id)
        self.title = try container.decode(String.self, forKey: Pool.CodingKeys.title)
        let date = try container.decodeIfPresent(String.self, forKey: Pool.CodingKeys.limitDate)
        self.responses = try container.decode([Response].self, forKey: Pool.CodingKeys.responses)
        self.proposals = try container.decode([Proposal].self, forKey: Pool.CodingKeys.proposals)
        self.isMultipleChoices = try container.decode(Bool.self, forKey: Pool.CodingKeys.isMultipleChoices)
        self.isActive = try container.decode(Bool.self, forKey: Pool.CodingKeys.isActive)

        if let date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            self.limitDate = dateFormatter.date(from: date)
        } else {
            self.limitDate = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<Pool.CodingKeys> = encoder.container(keyedBy: Pool.CodingKeys.self)
        
        try container.encode(self.id, forKey: Pool.CodingKeys.id)
        try container.encode(self.title, forKey: Pool.CodingKeys.title)
        try container.encode(self.limitDate, forKey: Pool.CodingKeys.limitDate)
        try container.encode(self.responses, forKey: Pool.CodingKeys.responses)
        try container.encode(self.proposals, forKey: Pool.CodingKeys.proposals)
        try container.encode(self.isMultipleChoices, forKey: Pool.CodingKeys.isMultipleChoices)
    }
}

extension Pool {
    func hasUserAlreadyAnwsered(idProfile: Int) -> Bool {
        responses.first {
            $0.idProfile == idProfile
        } != nil
    }

    func ratioForResponse(idProposal: Int) -> Float {
        let total = responses.reduce(0) { partialResult, response in
            var total = partialResult
            if response.idProposal == idProposal {
                total += 1
            }

            return total
        }

        guard !responses.isEmpty else { return 0 }

        let ratio = Double(total) / Double(responses.count)

        return Float(round(ratio * 10) / 10.0)
    }
}
