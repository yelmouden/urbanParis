//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 29/04/2024.
//

import Foundation
import Observation
import SwiftUI

public enum PopupType {
    case alert(AlertItem)
    case view(AnyView)
}

@MainActor
final public class PopupManager {
    public static let shared = PopupManager()
    
    private var windows: [UIWindow] = []

    private init() {}

    public func showPopup(item: PopupType) {
        let view: AnyView

        switch item {
        case .alert(let alertItem):
            view = AnyView(
                FWAlertView(
                    title: alertItem.title,
                    description: alertItem.description,
                    primaryButton: alertItem.primaryButtonItem,
                    secondaryButton: alertItem.secondaryButtonItem
                )
            )
        case .view(let viewToPresent):
            view = AnyView(viewToPresent)
        }
        if let window = getWidow(content: view) {
            if let window = windows.last {
                UIView.animate(withDuration: 0.3) {
                    window.alpha = 0
                }
            }

            windows.append(window)
        }
    }

    public func dismiss() {
        if let displayedWindow = windows.last {
            UIView.animate(withDuration: 0.3) {
                displayedWindow.alpha = 0
            } completion: { [weak self] completion in
                if completion {
                    self?.windows.removeLast()

                    if let window = self?.windows.last {
                        UIView.animate(withDuration: 0.3) {
                            window.alpha = 1
                        }
                    }
                }
            }
        }
    }

    private func getWidow(content: AnyView) -> UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        let window = UIWindow(windowScene: scene)

        window.backgroundColor = DSColors.black.color.withAlphaComponent(0)

        window.frame = UIScreen.main.bounds

        window.rootViewController = UIHostingController(rootView: content)
        window.rootViewController?.view.backgroundColor = .clear
        window.makeKeyAndVisible()

        UIView.animate(withDuration: 0.3) {
            window.backgroundColor = DSColors.black.color.withAlphaComponent(0.6)
        }

        return window
    }
}
