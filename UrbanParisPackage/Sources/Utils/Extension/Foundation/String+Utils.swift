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

private let amountformatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.usesGroupingSeparator = false
    return formatter
}()

public extension String {

    mutating func formattedDecimalText(numberDigits: Int = 2) {
        let newString = self.replacingOccurrences(of: ",", with: ".")
        let components = newString.components(separatedBy: ".")

        var valideAmount = ""

        if let value = components.first {
            valideAmount = value
        }

        let separator = Locale.current.decimalSeparator ?? "."

        if components.count > 1 {
            var decimal: String

            if components[1].count < 3 {
                decimal = components[1]
            } else {
                decimal = String(components[1].prefix(numberDigits))
            }

            if decimal != "0" {
                valideAmount += "\(separator)\(decimal)"
            }
        }

        self = valideAmount
    }

    var valueAmount: Float? {
        amountformatter.number(from: self)?.floatValue
    }

    var currencySymbol: String {
        let components: [String: String] = [NSLocale.Key.countryCode.rawValue: self]

        let identifier = NSLocale.localeIdentifier(fromComponents: components)

        let locale = NSLocale(localeIdentifier: identifier)
        return locale.currencySymbol
    }

    func removeDecimalIfZero() -> String {
        if hasSuffix(".0") {
            return String(dropLast(2))
        }
        return self
    }

}
