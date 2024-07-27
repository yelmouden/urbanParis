//
//  MenuViewModel.swift
//  UrbanParis
//
//  Created by Yassin El Mouden on 24/07/2024.
//

import Combine
import Foundation
import Observation
import ProfileManager
import Utils

@MainActor
final class MenuViewModel {
    var cancellables = Set<AnyCancellable>()

    var nickname: String = ""

    init() {
        ProfileUpdateNotifier.shared.publisher
            .sink { [weak self] profile in
                self?.nickname = profile?.nickname ?? ""
            }
            .store(in: &cancellables)
    }
}
