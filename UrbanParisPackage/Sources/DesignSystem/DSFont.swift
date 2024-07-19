//
//  File.swift
//
//
//  Created by Yassin El Mouden on 22/02/2024.
//

import Foundation
import SwiftUI

public enum DSFont {
    public static let extraLargeTitle: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.regular,
        size: UIFont.preferredFont(
            forTextStyle: .extraLargeTitle
        ).pointSize
    )
    public static let largeTitle: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.regular,
        size: 45
    )
    public static let title: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.regular,
        size: UIFont.preferredFont(
            forTextStyle: .title1
        ).pointSize
    )
    public static let title2: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.regular,
        size: UIFont.preferredFont(
            forTextStyle: .title2
        ).pointSize
    )
    public static let title3: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.regular,
        size: UIFont.preferredFont(
            forTextStyle: .title3
        ).pointSize
    )
    public static let headline: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.regular,
        size: 20
    )
    public static let subHeadline: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.regular,
        size: UIFont.preferredFont(
            forTextStyle: .subheadline
        ).pointSize
    )
    public static let body: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.regular,
        size: UIFont.preferredFont(
            forTextStyle: .body
        ).pointSize
    )

    /*public static let bodyBold: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.bold,
        size: UIFont.preferredFont(
            forTextStyle: .body
        ).pointSize
    )*/

    public static let caption1: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.regular,
        size: 15
    )

    public static let caption2: SwiftUI.Font = .custom(
        FontFamily.DonGraffiti.regular,
        size: UIFont.preferredFont(
            forTextStyle: .caption2
        ).pointSize
    )

}
