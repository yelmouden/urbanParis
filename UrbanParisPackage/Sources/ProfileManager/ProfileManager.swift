//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 23/05/2024.
//

import Combine
import CombineExt
import ConcurrencyExtras
import Foundation
import SharedModels

@MainActor
public class ProfileUpdateNotifier {
    private let subject: PassthroughSubject<Profile?, Never>

    public let publisher: AnyPublisher<Profile?, Never>

    public static let shared = ProfileUpdateNotifier()

    init() {
        self.subject = PassthroughSubject<Profile?, Never>()
        self.publisher = subject.share(replay: 1).eraseToAnyPublisher()
    }

    public func send(profile: Profile?) {
        subject.send(profile)
    }
}

