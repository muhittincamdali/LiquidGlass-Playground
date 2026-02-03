# LiquidGlass Playground 🔮

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![iOS 26+](https://img.shields.io/badge/iOS-26%2B-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-purple.svg)](https://developer.apple.com/xcode/swiftui/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

An interactive playground for exploring and experimenting with iOS 26's Liquid Glass effects in real-time.

```
╭─────────────────────────────────────────────────────────────────╮
│                                                                 │
│     ████████████████████████████████████████████████████       │
│     █                                                  █       │
│     █      🔮  Liquid Glass Playground                █       │
│     █                                                  █       │
│     █      Explore • Experiment • Export              █       │
│     █                                                  █       │
│     ████████████████████████████████████████████████████       │
│                                                                 │
╰─────────────────────────────────────────────────────────────────╯
```

## ✨ Features

### 🎛️ Interactive Parameter Control
- **Real-time preview** - See changes instantly as you adjust parameters
- **Intuitive sliders** - Fine-tune blur, tint, opacity, and more
- **Color picker** - Choose from presets or custom colors
- **Animation controls** - Add motion to your glass effects

### 🧪 10 Unique Experiments
| Experiment | Description |
|------------|-------------|
| **Basic Glass** | Learn the fundamentals of glass effects |
| **Dynamic Glass** | Create responsive, adaptive surfaces |
| **Layered Glass** | Stack multiple layers for depth |
| **Animated Glass** | Add smooth, engaging animations |
| **Colorful Glass** | Explore tints and gradients |
| **Interactive Glass** | Build touch-responsive interfaces |
| **Physics Glass** | Apply physics simulations |
| **Morphing Glass** | Create shape-shifting effects |
| **Particle Glass** | Combine particles with glass |
| **Advanced Glass** | Master pro techniques |

### 🎨 30+ Built-in Presets
- **Subtle**: Whisper, Mist, Haze
- **Bold**: Frosted, Crystal, Ice
- **Colorful**: Sunset, Ocean, Forest, Lavender, Rose
- **Modern**: Minimal, Sharp, Rounded
- **Dark**: Obsidian, Midnight
- **Animated**: Pulse, Breathe
- **Effects**: Glow, Neon

### 📤 Code Export
Generate production-ready Swift code from your experiments:

```swift
// Example exported code
RoundedRectangle(cornerRadius: 20)
    .fill(.ultraThinMaterial)
    .overlay {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.blue.opacity(0.15))
    }
    .shadow(radius: 10, y: 5)
```

## 📦 Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/LiquidGlass-Playground.git", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/muhittincamdali/LiquidGlass-Playground.git`
3. Select version and add to your target

## 🚀 Quick Start

```swift
import SwiftUI
import LiquidGlassPlayground

struct ContentView: View {
    @State private var parameters = GlassParameters()
    
    var body: some View {
        PlaygroundView()
    }
}
```

## 🏗️ Architecture

```
Sources/LiquidGlassPlayground/
├── App/
│   ├── PlaygroundApp.swift      # Main app entry point
│   ├── AppState.swift           # Central state management
│   └── ContentView.swift        # Root content view
├── Core/
│   ├── PlaygroundEngine.swift   # Core rendering engine
│   ├── ParameterControl.swift   # Parameter management
│   ├── GlassParameters.swift    # Parameter model
│   └── PlaygroundConfiguration.swift
├── Experiments/
│   ├── BasicGlassExperiment.swift
│   ├── DynamicGlassExperiment.swift
│   ├── LayeredGlassExperiment.swift
│   ├── AnimatedGlassExperiment.swift
│   ├── ColorfulGlassExperiment.swift
│   ├── InteractiveGlassExperiment.swift
│   ├── PhysicsGlassExperiment.swift
│   ├── MorphingGlassExperiment.swift
│   ├── ParticleGlassExperiment.swift
│   └── AdvancedGlassExperiment.swift
├── Components/
│   ├── GlassSlider.swift        # Custom slider
│   ├── GlassToggle.swift        # Custom toggle
│   ├── GlassMenu.swift          # Dropdown menu
│   ├── GlassCard.swift          # Card component
│   ├── GlassButton.swift        # Button styles
│   └── GlassColorPicker.swift   # Color picker
├── Views/
│   ├── PlaygroundView.swift     # Main playground
│   ├── ControlPanel.swift       # Parameter controls
│   └── PreviewPanel.swift       # Live preview
├── Presets/
│   ├── PresetLibrary.swift      # Built-in presets
│   └── PresetManager.swift      # Preset storage
├── Export/
│   └── CodeExporter.swift       # Swift code generation
└── Helpers/
    └── GlassEnvironment.swift   # Environment utilities
```

## 🎮 Using the Playground

### Basic Usage

1. **Select an Experiment** from the sidebar
2. **Adjust Parameters** using the control panel
3. **Preview Changes** in real-time
4. **Export Code** when satisfied

### Keyboard Shortcuts (macOS)

| Shortcut | Action |
|----------|--------|
| `⌘ + N` | New Experiment |
| `⌘ + P` | Toggle Preview |
| `⌘ + K` | Toggle Controls |
| `⌘ + ⇧ + E` | Export Code |
| `⌘ + ⇧ + R` | Reset to Defaults |

## 📚 Tutorials

The playground includes interactive tutorials:

- **Basic Tutorial**: Introduction to glass effects
- **Intermediate Tutorial**: Dynamic and layered effects
- **Advanced Tutorial**: Physics, particles, and pro techniques

## 🧩 Custom Components

### GlassSlider

```swift
GlassSlider(
    value: $blurRadius,
    range: 0...50,
    label: "Blur Radius",
    format: "%.0f"
)
```

### GlassToggle

```swift
GlassToggle(
    isOn: $enableAnimation,
    label: "Enable Animation"
)
```

### GlassCard

```swift
GlassCard {
    Text("Your content here")
}
```

### GlassButton

```swift
GlassButton("Submit", icon: "checkmark") {
    submitForm()
}
```

## ⚡ Performance Tips

1. **Reduce blur radius** for better performance
2. **Limit layer count** to avoid overdraw
3. **Use `drawingGroup()`** for complex compositions
4. **Avoid overlapping glass** elements

## 🎯 Requirements

- **iOS 26.0+** / **macOS 15.0+**
- **Swift 6.0+**
- **Xcode 16.0+**

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Apple's iOS 26 design team for the Liquid Glass concept
- SwiftUI community for inspiration and feedback

---

**Made with ❤️ for the iOS development community**

```
   ╱╲
  ╱  ╲     Liquid Glass
 ╱    ╲    Playground
╱──────╲   
╲      ╱   Explore the future
 ╲    ╱    of UI design
  ╲  ╱
   ╲╱
```
