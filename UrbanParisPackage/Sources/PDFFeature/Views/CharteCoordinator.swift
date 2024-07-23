//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 18/04/2024.
//

import DesignSystem
import FlowStacks
import SwiftUI

public enum CharteScreen: Equatable {
    case none
}

public enum DocType {
    case chart
    case organigrame

    public var nameFile: String {
        switch self {
        case .chart:
            return "charte"
        case .organigrame:
            return "organigramme"
        }
    }

    public var title: String {
        switch self {
        case .chart:
            return "Charte Urban"
        case .organigrame:
            return "Organigramme Urban"
        }
    }
}

public struct PDFCoordinator: View {
    @State var routes: Routes<CharteScreen> = []

    @Binding var showMenu: Bool

    let docType: DocType

    public init(showMenu: Binding<Bool>, docType: DocType) {
        self.docType = docType
        self._showMenu = showMenu
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            PDFDocView(docType: docType)
                .addShowMenuButton(showMenu: $showMenu)
        }
    }
}
