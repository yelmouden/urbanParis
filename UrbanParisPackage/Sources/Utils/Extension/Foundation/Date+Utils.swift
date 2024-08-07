//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 20/07/2024.
//

import Foundation

public extension Date {
    static var currentYear: Int {
        let calendar = Calendar.current
        
        if let currentYear = calendar.dateComponents([.year], from: Date()).year {
            return currentYear
        }

        return 2017
    }

    static var currentDate: Date? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Paris")

        dateFormatter.dateFormat = "dd/MM/yyyy"

        let formattedDate = dateFormatter.string(from: date)

        return dateFormatter.date(from: formattedDate)
    }

    static func fromString(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Paris")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: date)
    }
}
