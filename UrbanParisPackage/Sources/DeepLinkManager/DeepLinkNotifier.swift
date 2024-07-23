//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 29/06/2024.
//

import Combine
import Foundation
import SwiftUI

public final class DeepLinkNotifier {
    private let subject: PassthroughSubject<DeepLink, Never>

    public let publisher: AnyPublisher<DeepLink, Never>

    public static let shared = DeepLinkNotifier()

    init() {
        self.subject = PassthroughSubject<DeepLink, Never>()
        self.publisher = subject.eraseToAnyPublisher()
    }

    public func send(deepLinkType: DeepLink) {
        subject.send(deepLinkType)
    }
}
