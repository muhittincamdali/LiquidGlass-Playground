// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "LiquidGlassPlayground",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
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
            path: "Sources/LiquidGlassPlayground"
        ),
        .testTarget(
            name: "LiquidGlassPlaygroundTests",
            dependencies: ["LiquidGlassPlayground"]
        )
    ]
)
