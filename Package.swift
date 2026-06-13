// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LiquidGlassPlayground",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1)
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
