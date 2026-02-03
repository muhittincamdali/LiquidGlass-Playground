# 🧊 LiquidGlass-Playground

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2018%20%7C%20macOS%2015-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](Package.swift)

**An interactive playground for experimenting with Liquid Glass effects in real-time.** Tweak parameters, preview instantly, and export production-ready SwiftUI code.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🎛️ **Real-time Controls** | Adjust blur, refraction, tint, and more with live sliders |
| 👁️ **Instant Preview** | See changes reflected immediately in the preview panel |
| 📚 **20+ Presets** | Start from curated presets like Frosted, Aqua, Neon, etc. |
| 📤 **Code Export** | Generate copy-paste-ready SwiftUI code from your config |
| 🎓 **Built-in Tutorials** | Step-by-step guides to learn Liquid Glass from scratch |
| 🎨 **Theme Support** | Light and dark mode adaptive previews |
| ⚡ **High Performance** | Metal-backed rendering for smooth 60fps interactions |

---

## 📸 Preview

```
┌─────────────────────────────────────────────┐
│  LiquidGlass Playground                     │
├──────────────────────┬──────────────────────┤
│                      │  Blur Radius   ━━●━  │
│                      │  Refraction    ━●━━  │
│    Live Preview      │  Tint Opacity  ━━●━  │
│    Area              │  Corner Radius ━●━━  │
│                      │  Saturation    ━━━●  │
│                      │                      │
│                      │  [Preset: Frosted ▼] │
│                      │  [Export Code]       │
├──────────────────────┴──────────────────────┤
│  Presets: Frosted │ Aqua │ Neon │ Smoke │…  │
└─────────────────────────────────────────────┘
```

---

## 📦 Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/muhittincamdali/LiquidGlass-Playground.git",
        from: "1.0.0"
    )
]
```

Or in Xcode: **File → Add Package Dependencies** → paste the repository URL.

---

## 🚀 Quick Start

### Basic Usage

```swift
import LiquidGlassPlayground

struct ContentView: View {
    var body: some View {
        PlaygroundView()
    }
}
```

### Using Presets

```swift
let preset = PresetLibrary.shared.preset(named: "Frosted")
let engine = PlaygroundEngine(preset: preset)
```

### Exporting Code

```swift
let exporter = CodeExporter()
let swiftCode = exporter.export(engine.currentConfiguration)
print(swiftCode)
```

---

## 🎛️ Parameters

The playground exposes the following configurable parameters:

| Parameter | Type | Range | Default |
|-----------|------|-------|---------|
| `blurRadius` | `CGFloat` | 0 – 50 | 20 |
| `refractionIndex` | `CGFloat` | 0 – 1 | 0.5 |
| `tintColor` | `Color` | Any | `.white` |
| `tintOpacity` | `Double` | 0 – 1 | 0.15 |
| `cornerRadius` | `CGFloat` | 0 – 40 | 16 |
| `saturation` | `Double` | 0 – 2 | 1.2 |
| `brightness` | `Double` | -0.5 – 0.5 | 0.05 |
| `shadowRadius` | `CGFloat` | 0 – 30 | 8 |
| `borderWidth` | `CGFloat` | 0 – 4 | 0.5 |
| `borderOpacity` | `Double` | 0 – 1 | 0.3 |

---

## 📚 Presets Library

20 built-in presets to get you started:

| # | Name | Style |
|---|------|-------|
| 1 | Frosted | Classic frosted glass |
| 2 | Aqua | Water-like transparency |
| 3 | Neon | Vibrant edge glow |
| 4 | Smoke | Dark translucent overlay |
| 5 | Crystal | High clarity refraction |
| 6 | Ice | Cold blue tint |
| 7 | Amber | Warm golden tone |
| 8 | Rose | Soft pink tint |
| 9 | Midnight | Deep dark glass |
| 10 | Vapor | Ultra-light blur |
| 11 | Ocean | Deep blue depth |
| 12 | Sunset | Orange gradient tint |
| 13 | Forest | Green-tinted glass |
| 14 | Lavender | Soft purple haze |
| 15 | Pearl | Iridescent white |
| 16 | Obsidian | Jet black glass |
| 17 | Copper | Metallic warm tone |
| 18 | Arctic | Bright icy blue |
| 19 | Sandstone | Earthy matte finish |
| 20 | Prism | Rainbow refraction |

---

## 🏗️ Architecture

```
Sources/LiquidGlassPlayground/
├── Core/
│   ├── PlaygroundEngine.swift      # State management
│   └── ParameterControl.swift      # Control definitions
├── Effects/
│   ├── GlassEffectPlayground.swift # Glass effect renderer
│   └── BlurPlayground.swift        # Blur configurations
├── Presets/
│   └── PresetLibrary.swift         # 20 curated presets
├── Export/
│   └── CodeExporter.swift          # Swift code generation
├── Views/
│   ├── PlaygroundView.swift        # Main container view
│   ├── ControlPanel.swift          # Parameter sliders
│   └── PreviewPanel.swift          # Live preview area
└── Tutorials/
    └── BasicGlassTutorial.swift    # Interactive tutorial
```

---

## 🎓 Tutorials

The built-in tutorial system walks you through Liquid Glass concepts:

1. **Basic Glass** — Understanding blur, tint, and refraction
2. **Layering Effects** — Combining multiple glass layers
3. **Dynamic Parameters** — Animating glass properties
4. **Export Workflow** — From playground to production

```swift
BasicGlassTutorial.steps // Returns guided tutorial steps
```

---

## 🧪 Testing

```bash
swift test
```

The test suite covers:
- Engine state management
- Preset loading and validation
- Code export correctness
- Parameter boundary enforcement

---

## 📋 Requirements

- iOS 18.0+ / macOS 15.0+
- Swift 6.0+
- Xcode 26+

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Apple's Liquid Glass design language (WWDC25)
- SwiftUI framework team
- The open-source Swift community

---

> Built with ❤️ for the SwiftUI community
