//
//  File.swift
//
//
//  Created by Yassin El Mouden on 23/04/2024.
//

import Auth
import Database
import Dependencies
import DependenciesMacros
import Foundation
import UIKit

enum AuthenticationError: Error {
    case emailNotFound
    case googleErrorConfiguration
    case appleSignInFailed
    case facebookSignInFailed
    case userIDNotFound
}

@DependencyClient
public struct AuthenticationManager {
    public var createUser: ( _ email: String, _ password: String) async throws -> Void
    public var signIn: ( _ email: String, _ password: String) async throws -> Session
    public var signOut: () async throws -> Void
    public var deleteAccount: () async throws -> Void
    public var sendEmailResetPassword: (_ email: String) async throws -> Void
    public var resetPassword: (_ password: String) async throws -> Void
    public var retrieveSession: (_ code: String) async throws -> Void

}

extension AuthenticationManager: DependencyKey {
    public static var liveValue: AuthenticationManager {
        AuthenticationManager(
            createUser: { email, password in
                try await Database.shared.client.auth.signUp(email: email, password: password)
            },
            signIn: { email, password in
                try await Database.shared.client.auth.signIn(email: email, password: password)
            },
            signOut: {
                try await Database.shared.client.auth.signOut()
            },
            deleteAccount: {
                guard let id = Database.shared.client.auth.currentUser?.id else {
                    throw AuthenticationError.userIDNotFound
                }

                try await Database.shared.client.auth.signOut()
            },
            sendEmailResetPassword: { email in
                try await Database.shared.client.auth.resetPasswordForEmail(email, redirectTo: URL(string: "up://resetPassword"))
            },
            resetPassword: { password in
                try await Database.shared.client.auth.update(user: UserAttributes(password: password))
            },
            retrieveSession: {
                let _ = try await Database.shared.client.auth.exchangeCodeForSession(authCode: $0)
            }
        )
    }
}

public extension DependencyValues {
  var authenticationManager: AuthenticationManager {
    get { self[AuthenticationManager.self] }
    set { self[AuthenticationManager.self] = newValue }
  }
}
