// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UrbanParisPackage",
    defaultLocalization: "fr",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
        .library(
            name: "LoginFeature",
            targets: ["LoginFeature"]
        ),
        .library(
            name: "ProfileFeature",
            targets: ["ProfileFeature"]
        ),
        .library(
            name: "Database",
            targets: ["Database"]
        ),
        .library(
            name: "SharedResources",
            targets: ["SharedResources"]
        ),
        .library(
            name: "Utils",
            targets: ["Utils"]
        ),
        .library(
            name: "PDFFeature",
            targets: ["PDFFeature"]
        ),
        .library(
            name: "AuthenticationManager",
            targets: ["AuthenticationManager"]
        ),
        .library(
            name: "DeepLinkManager",
            targets: ["DeepLinkManager"]
        ),
        .library(
            name: "SettingsFeature",
            targets: ["SettingsFeature"]
        ),
        .library(
            name: "ProfileManager",
            targets: ["ProfileManager"]
        ),
        .library(
            name: "CotisationsFeature",
            targets: ["CotisationsFeature"]
        ),
        .library(
            name: "TravelMatchesFeature",
            targets: ["TravelMatchesFeature"]
        ),
        .library(
            name: "SharedRepository",
            targets: ["SharedRepository"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", exact: "7.0.0"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.0"),
        .package(url: "https://github.com/johnpatrickmorgan/FlowStacks", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", branch: "main"),
        .package(url: "https://github.com/EmergeTools/Pow", from: Version(1, 0, 0)),
        .package(url: "https://github.com/CSolanaM/SkeletonUI", branch: "master"),
        .package(url: "https://github.com/supabase-community/supabase-swift.git", branch: "main"),
        .package(url: "https://github.com/jasudev/AnimateText", branch: "main"),
        .package(url: "https://github.com/MarcosAtMorais/SwiftyEmail", branch: "main"),
        .package(url: "https://github.com/devicekit/DeviceKit", branch: "master"),
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras", branch: "main"),
        .package(url: "https://github.com/CombineCommunity/CombineExt", branch: "main"),
        .package(url: "https://github.com/JWAutumn/ACarousel", branch: "main")
    ],
    targets: [
        .target(
            name: "LoginFeature",
            dependencies: [
                .product(name: "FlowStacks", package: "FlowStacks"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Pow", package: "Pow"),
                .product(name: "AnimateText", package: "AnimateText"),
                "DesignSystem",
                "SharedResources",
                "AuthenticationManager"
            ],
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .target(
            name: "ProfileFeature",
            dependencies: [
                .product(name: "FlowStacks", package: "FlowStacks"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Pow", package: "Pow"),
                "ProfileManager",
                "DesignSystem",
                "SharedResources"
            ],
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .target(
            name: "CotisationsFeature",
            dependencies: [
                .product(name: "FlowStacks", package: "FlowStacks"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Pow", package: "Pow"),
                "ProfileManager",
                "DesignSystem",
                "SharedResources",
                "SharedRepository"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "TravelMatchesFeature",
            dependencies: [
                .product(name: "FlowStacks", package: "FlowStacks"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Pow", package: "Pow"),
                .product(name: "ACarousel", package: "ACarousel"),
                "ProfileManager",
                "DesignSystem",
                "SharedResources",
                "SharedRepository"
            ],
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]
        ),
        .target(
            name: "PDFFeature",
            dependencies: [
                .product(name: "FlowStacks", package: "FlowStacks"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                "DesignSystem",
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "Pow", package: "Pow"),
                .product(name: "SkeletonUI", package: "SkeletonUI"),
                "Utils"
            ],
            resources: [.process("Fonts")],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]
        ),
        .target(
            name: "Database",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ]
        ),
        .target(
            name: "SharedResources",
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .target(
            name: "Utils"
        ),
        .target(
            name: "AuthenticationManager",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "Auth", package: "supabase-swift"),
                "Database"
            ]
        ),
        .target(
            name: "DeepLinkManager",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies")
            ]
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "DesignSystem",
                .product(name: "SwiftyEmail", package: "SwiftyEmail"),
                .product(name: "DeviceKit", package: "DeviceKit"),
                .product(name: "FlowStacks", package: "FlowStacks"),

                "AuthenticationManager",
                "SharedResources",
                //"ProfileManager",
            ],
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]
        ),
        .target(
            name: "ProfileManager",
            dependencies: [
                "Database",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
                .product(name: "CombineExt", package: "CombineExt"),
            ]
        ),
        .target(
            name: "SharedRepository",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                "Database"
            ]
        )
    ]
)
