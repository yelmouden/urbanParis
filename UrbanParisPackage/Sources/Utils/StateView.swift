//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 23/04/2024.
//

import Foundation
import SwiftUI

public enum StateView<T: Equatable>: Equatable, Sendable where T: Sendable {
    case idle
    case loading
    case loaded(T)
    case empty
}

public struct EmptyResource: Equatable, Sendable {}

public extension EmptyResource {
    static let emptyResource = EmptyResource()
}
