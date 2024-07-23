//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 02/07/2024.
//

import Foundation

public extension Bundle {
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }

    var bundleName: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
