//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 19/02/2024.
//

import Foundation
import SwiftUI

// MARK: - Configuration

public enum FWButtonState {
    case idle
    case loading
    case success
}

public struct FWButtonConfiguration {
    let title: String
    let state: FWButtonState
    let size: CGSize
    let enabled: Bool
    let leftView: AnyView
    let action: (() -> Void)
}

@MainActor
public protocol FWButtonStyle: Sendable {
    associatedtype Body: View

    @ViewBuilder
    func makeBody(configuration: Configuration) -> Body

    typealias Configuration = FWButtonConfiguration
}

@MainActor
struct FWButtonStyleKey: EnvironmentKey {
    static let defaultValue: any FWButtonStyle = FWButtonDefaultStyle()
}

extension EnvironmentValues {
    var fwButtonStyle: any FWButtonStyle {
        get { self[FWButtonStyleKey.self] }
        set { self[FWButtonStyleKey.self] = newValue }
    }
}

public extension View {
    func fwButtonStyle(_ style: some FWButtonStyle) -> some View {
        environment(\.fwButtonStyle, style)
    }
}

struct FWButtonEnabledKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

extension EnvironmentValues {
    var enabled: Bool {
        get { self[FWButtonEnabledKey.self] }
        set { self[FWButtonEnabledKey.self] = newValue }
    }
}

public extension FWButton {
  func enabled(_ enabled: Bool) -> some View {
    environment(\.enabled, enabled)
  }
}

public extension FWButtonStyle where Self == FWButtonPrimaryStyle {
    static var primary: Self { .init() }
}

public extension FWButtonStyle where Self == FWButtonSecondaryStyle {
    static var secondary: Self { .init() }
}

public extension FWButtonStyle where Self == FWButtonTertiaryStyle {
    static var tertiary: Self { .init() }
}

// MARK: - Styles Defined in Design System

public struct FWButtonDefaultStyle: FWButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.action()
        } label: {
            Text(configuration.title)
                .font(DSFont.robotoBody)
                .foregroundStyle(DSColors.red.swiftUIColor)
        }
        .tint(DSColors.white.swiftUIColor)
        .dynamicTypeSize(...DynamicTypeSize.large)
    }
}

extension AnyTransition {
    static var fade: AnyTransition {
        .asymmetric(
            insertion: .identity,
            removal: .opacity
        )
    }

    static var moveFade: AnyTransition {
        .asymmetric(
            insertion: .push(from: .bottom),
            removal: .scale.combined(with: .opacity)
        )
    }
}


public struct FWButtonPrimaryStyle: FWButtonStyle {
    @State var animateOpacitySuccess = false

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {

        Button(action: {
            if configuration.state == .idle && configuration.enabled {
                configuration.action()
            }

        },
               label: {
            HStack {
                if configuration.state == .loading {
                    LoaderView(color: DSColors.white.swiftUIColor)
                        .frame(width: 30, height: 30)
                        .transition(.fade)

                } else if configuration.state == .success {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .bold()
                        .animation(
                            /*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/.delay(0.25),
                                                  value: configuration.state
                        )
                        .transition(.moveFade)
                } else {
                    Spacer()
                    Text(configuration.title)
                        .font(DSFont.robotoBody)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                    Spacer()
                }

            }
        })
        .sensoryFeedback(.selection, trigger: configuration.state == .loading)
        .sensoryFeedback(.success, trigger: configuration.state == .success)
        .frame(
            maxWidth: configuration.state != .idle ? 48 : .infinity,
            minHeight: 48
        )
        .background(configuration.state == .success ? DSColors.success.swiftUIColor : DSColors.red.swiftUIColor.opacity(configuration.enabled ? 1 : 0.5))
        .cornerRadius(configuration.state != .idle ? 40 : 26)
        .animation(.easeIn, value: configuration.state)
    }
}

public struct FWButtonSecondaryStyle: FWButtonStyle {

    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        
        Button(action: {
            if configuration.state != .loading && configuration.enabled {
                configuration.action()
            }
        }, label: {
            HStack {
                Spacer()
                HStack {
                    if configuration.state != .loading {
                        configuration.leftView
                            .transition(.offset(CGSize(width: configuration.size.width / 2, height: 0)).combined(with: .opacity))
                    }

                    if configuration.state == .loading {
                        LoaderView(color: DSColors.red.swiftUIColor)
                            .frame(width: 30, height: 30)
                            .transition(.fade)

                    } else if configuration.state == .success {
                        Image(systemName: "checkmark")
                            .foregroundColor(DSColors.success.swiftUIColor)
                            .bold()
                            .animation(
                                /*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/.delay(0.25),
                                value: configuration.state
                            )
                            .transition(.moveFade)
                    } else {
                        Spacer()
                        Text(configuration.title)
                            .font(DSFont.robotoBody)
                            .foregroundStyle(DSColors.red.swiftUIColor)
                            .opacity(configuration.enabled ? 1 : 0.5)

                        Spacer()
                    }
                }

                Spacer()
            }
        })
        .sensoryFeedback(.selection, trigger: configuration.state == .loading)
        .sensoryFeedback(.success, trigger: configuration.state == .success)
        .frame(
            maxWidth: configuration.state != .idle ? 48 : .infinity,
            minHeight: 48
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(configuration.state == .success ? DSColors.success.swiftUIColor : DSColors.red.swiftUIColor, lineWidth: 1)
        )
        .dynamicTypeSize(...DynamicTypeSize.large)
        .animation(.easeIn, value: configuration.state)
    }
}

public struct FWButtonTertiaryStyle: FWButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            if configuration.enabled {
                configuration.action()
            }
        }, label: {
            HStack {
                Spacer()
                HStack {
                    configuration.leftView
                    Text(configuration.title)
                        .font(DSFont.robotoBody)
                        .foregroundStyle(DSColors.red.swiftUIColor)
                        .opacity(configuration.enabled ? 1 : 0.5)
                }

                Spacer()
            }
        })
        .sensoryFeedback(.selection, trigger: configuration.state == .idle)
        .frame(height: 48)
    }
}

