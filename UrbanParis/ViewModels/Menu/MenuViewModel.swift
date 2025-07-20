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

    var status: String?

    var shouldDisplayAdminEnty: Bool = false

    init() {
        ProfileUpdateNotifier.shared.publisher
            .sink { [weak self] profile in
                self?.nickname = profile?.nickname ?? ""
                self?.status = profile?.status?.title
                self?.shouldDisplayAdminEnty = profile?.isAdmin ?? false
            }
            .store(in: &cancellables)
    }
}
