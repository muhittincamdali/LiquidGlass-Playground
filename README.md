<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-light.svg" alt="LiquidGlassKit: Liquid Glass surfaces and controls for SwiftUI."></picture></p>

<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a></p>

# LiquidGlass-Playground has moved

**This project now lives in [LiquidGlassKit](https://github.com/muhittincamdali/LiquidGlassKit).**
This repository is archived and will not change again. Its last release here is
[v1.0.0](https://github.com/muhittincamdali/LiquidGlass-Playground/releases/tag/v1.0.0).

## Where the code went

LiquidGlassKit 2.1.0 merged the useful parts of this repository, rewritten on top of its
`glassSurface` modifier and covered by tests:

| Here                    | In LiquidGlassKit                                                                                                                                                                                                     |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CodeExporter`          | [`GlassCodeExporter`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Core/GlassCodeExporter.swift): writes a tuned theme or a complete view as Swift source that uses the package |
| Parameter tuning screen | [Playground screen](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Examples/LiquidGlassDemo/Sources/PlaygroundScreen.swift) in the demo app: sliders, a live preview and the exported code               |
| Named looks             | [`GlassPreset`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Core/GlassPreset.swift): 14 ready-made themes                                                                      |

The walkthrough is the DocC article
[Tuning and Exporting a Look](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/LiquidGlassKit.docc/TuningAndExportingALook.md).
The package does not carry over every file from here; see the
[2.1.0 changelog](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/CHANGELOG.md) for the
exact scope.

## Install the new package

```swift
.package(url: "https://github.com/muhittincamdali/LiquidGlassKit.git", from: "2.1.0")
```

Then add `.product(name: "LiquidGlassKit", package: "LiquidGlassKit")` to your target. It needs
iOS 17, macOS 14, tvOS 17, watchOS 10 or visionOS 1, and Swift 6.0. Full documentation:
[LiquidGlassKit README](https://github.com/muhittincamdali/LiquidGlassKit#readme).

## License

MIT, see [LICENSE](LICENSE).
