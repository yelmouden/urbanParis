//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 18/04/2024.
//

import FlowStacks
import SwiftUI
import Utils

public enum LoginScreen: Equatable, Hashable {
    case signIn(SignInViewModel)
    case signUp(SignUpViewModel)
    case forgotPassword(ForgetPasswordViewModel)
    //case resetPassword(ResetPasswordViewModel, InterModuleAction<EmptyResource>)

    public static func == (lhs: LoginScreen, rhs: LoginScreen) -> Bool {
        switch (lhs, rhs) {
        /*case (.welcome, .welcome):
            return true*/
        case (.signIn(let lhsViewModel), .signIn(let rhsViewModel)):
            return lhsViewModel === rhsViewModel
        case (.signUp(let lhsViewModel), .signUp(let rhsViewModel)):
            return lhsViewModel === rhsViewModel
       case (.forgotPassword, .forgotPassword):
            return true
        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
            switch self {
            case .signIn:
                hasher.combine(1)
            case .signUp:
                hasher.combine(2)
            case .forgotPassword:
                hasher.combine(3)
            }
        }
}

public struct LoginCoordinator: View {
    @State var routes: Routes<LoginScreen>

    public init(routes: Routes<LoginScreen> = []) {
        self.routes = routes
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {

            WelcomeView()
                .flowDestination(for: LoginScreen.self) { screen in
                    switch screen {
                    case .signIn(let viewModel):
                        SignInView(viewModel: viewModel)
                    case .signUp(let viewModel):
                        SignUpView(viewModel: viewModel)
                    case .forgotPassword(let viewModel):
                        ForgetPasswordView(viewModel: viewModel)
                    }
                }
        }
    }
}
