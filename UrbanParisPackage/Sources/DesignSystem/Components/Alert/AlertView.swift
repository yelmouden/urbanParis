//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 26/04/2024.
//

import Pow
import SwiftUI
import Utils

@MainActor
public struct FWAlertView: View {

    let title: LocalizedStringResource
    let description: LocalizedStringResource
    let primaryButton: AlertItemButton
    let secondaryButton: AlertItemButton?

    @State private var show: Bool = false
    @State var task: Task<Void, Never>?
    @State var isLoading = false
    @State var isSucceeded = false

    public init(
        title: LocalizedStringResource,
        description: LocalizedStringResource,
        primaryButton: AlertItemButton,
        secondaryButton: AlertItemButton? = nil
    ) {
        self.title = title
        self.description = description
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }

    public var body: some View {
        ZStack {
            if show {
                VStack(spacing: Margins.medium) {
                    Text(title)
                        .font(DSFont.robotoBodyBold)
                        .foregroundStyle(DSColors.white.swiftUIColor)

                    Text(description)
                        .font(DSFont.robotoBody)
                        .foregroundStyle(DSColors.white.swiftUIColor)
                        .padding(.bottom, Margins.small)

                    VStack {
                        getFWButton(for: primaryButton)
                            .fwButtonStyle(.primary)
                            .addSensoryFeedback()


                        if let secondaryButton {
                            getFWButton(for: secondaryButton)
                                .fwButtonStyle(.tertiary)
                                .addSensoryFeedback()
                        }
                    }
                }
                .padding()
                .background(DSColors.background.swiftUIColor.opacity(0.7))
                .addBorder(DSColors.red.swiftUIColor, cornerRadius: 20)
                .padding(Margins.extraLarge)
                .zIndex(2)
                .offset(y: -20)
                .ignoresSafeArea(.all)
                .transition(.movingParts.clock(blurRadius: 50))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    show = true
                }
            }
        }.onDisappear {
            task?.cancel()
        }
    }

    private func getFWButton(for itemButton: AlertItemButton) -> some View {
        FWButton(
            title: itemButton.title,
            state: isSucceeded ? .success : isLoading ? .loading : .idle,
            action: {
                if let action = itemButton.action {
                    withAnimation {
                        show = false
                    } completion: {
                        PopupManager.shared.dismiss()
                        action()
                        itemButton.onDismiss?()
                    }

                } else if let asyncAction = itemButton.asyncAction {
                    self.task?.cancel()
                    self.task = nil

                    self.isLoading = true
                    self.task = Task {
                        do {
                            let isSucceeded = await asyncAction()

                            try Task.checkCancellation()

                            if isSucceeded {
                                withAnimation {
                                    self.isSucceeded = true
                                }

                                try? await Task.sleep(for: .seconds(1))

                                try Task.checkCancellation()

                                withAnimation {
                                    show = false
                                } completion: {
                                    PopupManager.shared.dismiss()
                                    itemButton.onDismiss?()
                                }

                            } else {
                                withAnimation {
                                    show = false
                                } completion: {
                                    PopupManager.shared.dismiss()
                                }
                            }
                        } catch {

                        }
                    }
                } else {
                    withAnimation {
                        show = false
                    } completion: {
                        PopupManager.shared.dismiss()
                    }
                }
        })
    }
}
