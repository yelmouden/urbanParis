//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 23/07/2024.
//

import Foundation

public extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailPredicate.evaluate(with: self)
    }

    var formattedHour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"

        guard let date = dateFormatter.date(from: self) else {
            return self
        }

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH'h'mm"

        let formattedTimeString = timeFormatter.string(from: date)
        return formattedTimeString
    }
}
