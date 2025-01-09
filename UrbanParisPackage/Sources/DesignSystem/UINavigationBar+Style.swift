//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 22/07/2024.
//

import Foundation
import UIKit

public extension UINavigationBar {
    static func setupStyle() {
        let appearance = UINavigationBar.appearance()

        appearance.backgroundColor = UIColor.clear
        appearance.tintColor = .clear

        appearance.titleTextAttributes = [
            .foregroundColor: DSColors.white.color,
            NSAttributedString.Key.font: FontFamily.Dreamlands.regular.font(size: 25)
        ]

        appearance.largeTitleTextAttributes = [
            .foregroundColor: DSColors.white.color,
            NSAttributedString.Key.font: FontFamily.Dreamlands.regular.font(size: 35)
        ]

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = DSColors.red.color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = DSColors.white.color

        UISearchBar.appearance().tintColor = DSColors.red.color

        appearance.shadowImage = UIImage()
        appearance.setBackgroundImage(UIImage(), for: .default)
    }
}
