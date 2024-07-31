//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 29/04/2024.
//

import Foundation
import SwiftUI

public class InterModuleAction<T> {
    public var bindingValue: Binding<T?>?
    public let onClose: (() -> Void)?

    public init(bindingValue: Binding<T?>? = nil, onClose: (() -> Void)? = nil) {
        self.bindingValue = bindingValue
        self.onClose = onClose
    }
}
