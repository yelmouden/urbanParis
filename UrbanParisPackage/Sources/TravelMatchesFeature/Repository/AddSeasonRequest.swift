//
//  File.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 27/12/2024.
//

import Foundation


public struct AddSeasonRequest: Encodable {
    public var title: String

    public init(title: String) {
        self.title = title
    }
}
