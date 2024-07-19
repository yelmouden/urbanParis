//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 23/04/2024.
//

import Foundation
import Utils

public extension StateView {
    func toFWButtonState() -> FWButtonState {
        switch self {
        case .idle, .empty:
            return .idle
        case .loading:
            return .loading
        case .loaded:
            return .success
        }
    }
}
