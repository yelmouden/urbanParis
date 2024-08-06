//
//  File.swift
//
//
//  Created by Yassin El Mouden on 22/02/2024.
//

import Foundation
import SwiftUI

public enum DSFont {
    public static let grafExtraLargeTitle: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .extraLargeTitle
        ).pointSize
    )
    public static let grafLargeTitle: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .largeTitle
        ).pointSize
    )
    public static let grafTitle: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .title1
        ).pointSize
    )
    public static let grafTitle2: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .title2
        ).pointSize
    )
    public static let grafTitle3: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .title3
        ).pointSize
    )
    public static let grafHeadline: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .headline
        ).pointSize
    )
    public static let grafSubHeadline: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .subheadline
        ).pointSize
    )
    public static let grafBody: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .body
        ).pointSize
    )

    public static let grafBodyBold: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .body
        ).pointSize
    )

    public static let grafCaption1: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .caption1
        ).pointSize
    )

    public static let grafCaption2: SwiftUI.Font = .custom(
        FontFamily.Dreamlands.regular,
        size: UIFont.preferredFont(
            forTextStyle: .caption2
        ).pointSize
    )

    public static let robotoExtraLargeTitle: SwiftUI.Font = .custom(
        FontFamily.RobotoBlack.regular,
        size: UIFont.preferredFont(
            forTextStyle: .extraLargeTitle
        ).pointSize
    )
    public static let robotoLargeTitle: SwiftUI.Font = .custom(
        FontFamily.RobotoBlack.regular,
        size: UIFont.preferredFont(
            forTextStyle: .largeTitle
        ).pointSize
    )
    public static let robotoTitle: SwiftUI.Font = .custom(
        FontFamily.RobotoBlack.regular,
        size: UIFont.preferredFont(
            forTextStyle: .title1
        ).pointSize
    )
    public static let robotoTitle2: SwiftUI.Font = .custom(
        FontFamily.RobotoBlack.regular,
        size: UIFont.preferredFont(
            forTextStyle: .title2
        ).pointSize
    )
    public static let robotoTitle3: SwiftUI.Font = .custom(
        FontFamily.RobotoBlack.regular,
        size: UIFont.preferredFont(
            forTextStyle: .title3
        ).pointSize
    )
    public static let robotoHeadline: SwiftUI.Font = .custom(
        FontFamily.RobotoRound.regular,
        size: UIFont.preferredFont(
            forTextStyle: .headline
        ).pointSize
    )
    public static let robotoSubHeadline: SwiftUI.Font = .custom(
        FontFamily.RobotoRound.regular,
        size: UIFont.preferredFont(
            forTextStyle: .subheadline
        ).pointSize
    )
    public static let robotoBody: SwiftUI.Font = .custom(
        FontFamily.RobotoRound.regular,
        size: UIFont.preferredFont(
            forTextStyle: .body
        ).pointSize
    )

    public static let robotoBodyBold: SwiftUI.Font = .custom(
        FontFamily.Roboto.bold,
        size: UIFont.preferredFont(
            forTextStyle: .body
        ).pointSize
    )

    public static let robotoCaption1: SwiftUI.Font = .custom(
        FontFamily.RobotoRound.regular,
        size: UIFont.preferredFont(
            forTextStyle: .caption1
        ).pointSize
    )

    public static let robotoCaption2: SwiftUI.Font = .custom(
        FontFamily.RobotoRound.regular,
        size: UIFont.preferredFont(
            forTextStyle: .caption2
        ).pointSize
    )
}

