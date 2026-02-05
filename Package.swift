// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LiquidGlassPlayground",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "LiquidGlassPlayground",
            targets: ["LiquidGlassPlayground"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LiquidGlassPlayground",
            dependencies: [],
            path: "Sources/LiquidGlassPlayground",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("AccessLevelOnImport")
            ]
        ),
        .testTarget(
            name: "LiquidGlassPlaygroundTests",
            dependencies: ["LiquidGlassPlayground"]
        )
    ],
    swiftLanguageModes: [.v6]
)
