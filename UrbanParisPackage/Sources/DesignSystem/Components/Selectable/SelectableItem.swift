//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 19/04/2024.
//

import Foundation

public protocol SelectableItem: Equatable {
    var title: String { get }
    var description: String? { get }
}
