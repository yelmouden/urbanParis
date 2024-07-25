//
//  File.swift
//
//
//  Created by Yassin El Mouden on 23/07/2024.
//

import Foundation
import SwiftUI

struct MenuButtonModifier: ViewModifier {
    @Binding var showMenu: Bool


    init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        withAnimation(.spring) {
                            self.showMenu.toggle()
                        }
                    }) {
                        Image(systemName: self.showMenu ? "xmark" : "line.horizontal.3")
                            .resizable()
                            .frame(width: self.showMenu ? 18 : 22, height: 18)
                            .foregroundColor(DSColors.red.swiftUIColor)
                    }
                }
            }
    }
}

public extension View {
    func addShowMenuButton(showMenu: Binding<Bool>) -> some View {
        modifier(MenuButtonModifier(showMenu: showMenu))
    }
}
