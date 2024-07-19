//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 23/04/2024.
//

import Foundation

public class ConfigurationReader {
    public static func value<T>(for member: String) -> T {
        guard let value = Bundle.main.infoDictionary?[member] as? T else {
            fatalError("Invalid or missing Info.plist key: \(member)")
        }
        return value
    }
}

public extension ConfigurationReader {
    static var isUrbanApp: Bool {
        let isValid: String = ConfigurationReader.value(for: "IS_VALID")
        return isValid == "1"
    }
}

