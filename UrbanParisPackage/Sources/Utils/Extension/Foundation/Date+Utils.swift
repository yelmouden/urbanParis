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
}
