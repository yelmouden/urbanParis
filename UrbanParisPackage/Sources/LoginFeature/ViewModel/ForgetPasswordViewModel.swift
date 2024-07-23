//
//  File.swift
//
//
//  Created by Yassin El Mouden on 11/04/2024.
//

import AuthenticationManager
//import DeepLinkManager
import Foundation
import Dependencies
import Observation
import SharedResources
//import TrackingManager
import Utils

@Observable
public final class ForgetPasswordViewModel {

    @ObservationIgnored
    @Dependency(AuthenticationManager.self) var manager

    /*@ObservationIgnored
    @Dependency(TrackingManager.self) var tracking*/

    var showError: Bool = false
    var errorText: String = ""

    var state: StateView<Bool> = .idle

    private var task: Task<Void, Never>?

    public init() {}

    @MainActor
    func resendPassword(email: String) async {
        do {

            //tracking.trackEvent(event: .requestForgetPassword, parameters: [:])

            state = .loading

            try await manager.sendEmailResetPassword(email: email)
            try Task.checkCancellation()

            state = .loaded(true)

            try await Task.sleep(for: .seconds(1))
            try Task.checkCancellation()

            state = .idle
        } catch {
            if !(error is CancellationError) {
                state = .idle
                showError = true
                errorText = SharedResources.commonErrorText
            }
        }
    }


}
