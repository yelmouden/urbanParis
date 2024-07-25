//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 25/07/2024.
//

import Foundation

private let amountformatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.usesGroupingSeparator = false
    return formatter
}()


public extension Float {
    var amountText: String {
        let amountText = amountformatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(amountText) €"
    }

}
