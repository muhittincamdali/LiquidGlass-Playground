<p align="center">
  <img src="Assets/logo.png" alt="Liquid Glass Playground" width="200"/>
</p>

<h1 align="center">Liquid Glass Playground</h1>

<p align="center">
  <strong>🎮 Interactive Swift Playground for exploring iOS 26's Liquid Glass effects</strong>
</p>

<p align="center">
  <a href="https://github.com/muhittincamdali/LiquidGlass-Playground/actions/workflows/ci.yml">
    <img src="https://github.com/muhittincamdali/LiquidGlass-Playground/actions/workflows/ci.yml/badge.svg" alt="CI"/>
  </a>
  <img src="https://img.shields.io/badge/iOS-26-007AFF?style=flat-square&logo=apple&logoColor=white" alt="iOS 26"/>
  <img src="https://img.shields.io/badge/Swift-6.0-FA7343?style=flat-square&logo=swift&logoColor=white" alt="Swift 6.0"/>
  <img src="https://img.shields.io/badge/Swift_Playgrounds-5.0-orange?style=flat-square&logo=swift&logoColor=white" alt="Swift Playgrounds"/>
  <img src="https://img.shields.io/badge/Xcode-18+-147EFB?style=flat-square&logo=xcode&logoColor=white" alt="Xcode 18"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License"/>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#experiments">Experiments</a> •
  <a href="#usage">Usage</a> •
  <a href="#contributing">Contributing</a>
</p>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Experiments](#experiments)
- [Usage](#usage)
- [Code Examples](#code-examples)
- [Contributing](#contributing)
- [License](#license)
- [Star History](#-star-history)

---

## Overview

**Liquid Glass Playground** is an interactive Swift Playground that lets you explore and experiment with iOS 26's revolutionary Liquid Glass design language. Perfect for designers and developers who want to understand the new glass effects before implementing them in production apps.

```swift
// Create stunning glass effects in seconds
let glass = GlassView()
    .opacity(0.3)
    .blur(20)
    .tint(.blue)
    .border(width: 1, color: .white.opacity(0.3))

// See real-time preview
PlaygroundPage.current.setLiveView(glass)
```

## Features

| Feature | Description |
|---------|-------------|
| 🧊 **Glass Opacity** | Fine-tune transparency from 0% to 100% |
| 🌫️ **Blur Intensity** | Control blur amount for depth effects |
| 🎨 **Tint Colors** | Add subtle color overlays |
| 📐 **Border Effects** | Customize glass borders and corners |
| ✨ **Animations** | Explore glass transitions and morphing |
| 🔮 **Refraction** | Simulate light bending through glass |
| 🌈 **Gradients** | Apply gradient tints to glass surfaces |
| 📱 **Live Preview** | Real-time visualization of all changes |

## Requirements

| Requirement | Version |
|-------------|---------|
| iOS SDK | 26.0+ |
| Swift | 6.0+ |
| Xcode | 18.0+ |
| Swift Playgrounds | 5.0+ |
| Hardware | Apple Silicon Mac or iPad |

## Installation

### Swift Playgrounds (iPad/Mac)

1. Download the `.swiftpm` package from [Releases](https://github.com/muhittincamdali/LiquidGlass-Playground/releases)
2. Open in Swift Playgrounds 5.0+
3. Start experimenting!

### Xcode

```bash
# Clone the repository
git clone https://github.com/muhittincamdali/LiquidGlass-Playground.git

# Open in Xcode
cd LiquidGlass-Playground
open Package.swift
```

## Experiments

The playground includes 8 interactive experiments:

### 1. Glass Opacity

Adjust the transparency of your glass view:

```swift
GlassView()
    .opacity(0.1)  // Subtle glass
    .opacity(0.5)  // Medium glass
    .opacity(0.9)  // Nearly opaque
```

### 2. Blur Intensity

Control the frosted glass effect:

```swift
GlassView()
    .blur(5)   // Light blur
    .blur(20)  // Medium blur
    .blur(50)  // Heavy blur
```

### 3. Tint Colors

Add color overlays to your glass:

```swift
GlassView()
    .tint(.blue)
    .tint(.purple.opacity(0.3))
    .tint(LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom))
```

### 4. Border Effects

Customize glass borders:

```swift
GlassView()
    .border(width: 1, color: .white.opacity(0.3))
    .border(width: 2, gradient: .linearGradient(colors: [.white, .clear]))
    .cornerRadius(20)
```

### 5. Animations

Explore glass transitions:

```swift
GlassView()
    .animation(.spring(duration: 0.5))
    .transition(.opacity.combined(with: .scale))
```

### 6. Refraction Effects

Simulate light bending:

```swift
GlassView()
    .refraction(intensity: 0.3)
    .chromaAberration(0.02)
```

### 7. Stacking Glass

Layer multiple glass views:

```swift
ZStack {
    GlassView().blur(30)
    GlassView().blur(10).offset(x: 20, y: 20)
}
```

### 8. Dynamic Island Integration

Preview how glass interacts with Dynamic Island:

```swift
DynamicIslandPreview {
    GlassView()
        .blur(20)
        .tint(.black.opacity(0.5))
}
```

## Usage

### Basic Glass View

```swift
import LiquidGlassPlayground
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.purple, .blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Glass card
            GlassView {
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                    Text("Liquid Glass")
                        .font(.title)
                    Text("iOS 26")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(32)
            }
            .blur(15)
            .opacity(0.25)
            .cornerRadius(24)
        }
    }
}

// Preview
PlaygroundPage.current.setLiveView(ContentView())
```

### Interactive Sliders

```swift
struct ExperimentView: View {
    @State private var blur: CGFloat = 20
    @State private var opacity: CGFloat = 0.3
    @State private var tintColor: Color = .white
    
    var body: some View {
        VStack {
            GlassView()
                .blur(blur)
                .opacity(opacity)
                .tint(tintColor)
                .frame(width: 200, height: 200)
            
            Slider(value: $blur, in: 0...50)
            Slider(value: $opacity, in: 0...1)
            ColorPicker("Tint", selection: $tintColor)
        }
    }
}
```

## Code Examples

### Creating a Glass Button

```swift
struct GlassButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background {
                    GlassView()
                        .blur(10)
                        .opacity(0.2)
                }
                .clipShape(Capsule())
        }
    }
}
```

### Glass Navigation Bar

```swift
struct GlassNavBar: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text("Liquid Glass")
                .font(.headline)
            Spacer()
            Button(action: {}) {
                Image(systemName: "ellipsis")
            }
        }
        .padding()
        .background {
            GlassView()
                .blur(20)
                .opacity(0.3)
        }
    }
}
```

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-experiment`)
3. Commit your changes (`git commit -m 'feat: add amazing experiment'`)
4. Push to the branch (`git push origin feature/amazing-experiment`)
5. Open a Pull Request

## License

Liquid Glass Playground is released under the MIT License. See [LICENSE](LICENSE) for details.

---

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/LiquidGlass-Playground&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/LiquidGlass-Playground&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/LiquidGlass-Playground&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/LiquidGlass-Playground&type=Date" />
 </picture>
</a>

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/muhittincamdali">Muhittin Camdali</a>
</p>
