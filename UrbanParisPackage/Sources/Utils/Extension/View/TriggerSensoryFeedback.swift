//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 18/07/2024.
//

import Foundation
import SwiftUI

struct TriggerSensoryFeedback: ViewModifier {
    @State var impactMedium = true

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        impactMedium.toggle()
                    }
            )
            .sensoryFeedback(.impact(weight: .light), trigger: impactMedium)
    }
}

public extension View {
    func addSensoryFeedback() -> some View {
        modifier(TriggerSensoryFeedback())
    }
}
