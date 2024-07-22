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

        appearance.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = UIColor.clear
        appearance.tintColor = .clear

        appearance.titleTextAttributes = [
            .foregroundColor: DSColors.white.color,
            NSAttributedString.Key.font: FontFamily.DonGraffiti.regular.font(size: 32)
        ]

        appearance.largeTitleTextAttributes = [
            .foregroundColor: DSColors.white.color,
            NSAttributedString.Key.font: FontFamily.DonGraffiti.regular.font(size: 42)
        ]

        //UINavigationBar.appearance().standardAppearance = appearance
    }
}
