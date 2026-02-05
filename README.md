<h1 align="center">🧊 Liquid Glass Playground</h1>

<p align="center">
  <strong>🎮 Interactive Swift Playground for exploring iOS 26's Liquid Glass effects</strong>
</p>

<p align="center">
  <em>Learn the real iOS 26 Liquid Glass API with 10 hands-on experiments</em>
</p>

<p align="center">
  <a href="https://github.com/muhittincamdali/LiquidGlass-Playground/actions/workflows/ci.yml">
    <img src="https://github.com/muhittincamdali/LiquidGlass-Playground/actions/workflows/ci.yml/badge.svg" alt="CI"/>
  </a>
  <img src="https://img.shields.io/badge/Platform-iOS_26-007AFF?style=flat-square&logo=apple&logoColor=white" alt="iOS 26"/>
  <img src="https://img.shields.io/badge/Swift-6.0-FA7343?style=flat-square&logo=swift&logoColor=white" alt="Swift 6.0"/>
  <img src="https://img.shields.io/badge/Xcode-26+-147EFB?style=flat-square&logo=xcode&logoColor=white" alt="Xcode 26"/>
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

> ⚠️ **Note**: This playground uses **real iOS 26 APIs** like `.glassEffect()`, `GlassEffectContainer`, and `.buttonStyle(.glass)`. It requires Xcode 26+ and iOS 26 SDK.

```swift
// Native iOS 26 Liquid Glass API
import SwiftUI

struct GlassCard: View {
    @Namespace private var namespace
    
    var body: some View {
        GlassEffectContainer {
            VStack(spacing: 16) {
                Text("Liquid Glass")
                    .font(.title.bold())
                
                Button("Interactive") { }
                    .buttonStyle(.glassProminent)
                    .glassEffectID("button", in: namespace)
            }
            .padding()
            .glassEffect(.regular.tint(.blue.opacity(0.2)), in: RoundedRectangle(cornerRadius: 24))
        }
    }
}
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
| iOS SDK | **26.0+** |
| macOS SDK | **26.0+** |
| visionOS SDK | **2.0+** |
| Swift | **6.0+** |
| Xcode | **26.0+** |
| Hardware | Apple Silicon Mac or iPad |

## Native iOS 26 APIs Used

This playground teaches you the **real** iOS 26 Liquid Glass APIs:

| API | Description |
|-----|-------------|
| `.glassEffect()` | Apply Liquid Glass material to any view |
| `.glassEffect(.regular)` | Standard glass appearance |
| `.glassEffect(.regular.interactive())` | Touch-responsive glass |
| `.glassEffect(.regular.tint(.color))` | Tinted glass effect |
| `GlassEffectContainer` | Container for morphable glass elements |
| `.glassEffectID(_:in:)` | Identity for morphing transitions |
| `.buttonStyle(.glass)` | Translucent glass button style |
| `.buttonStyle(.glassProminent)` | Opaque prominent glass button |

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

## 🧪 10 Interactive Experiments

The playground includes **10 hands-on experiments** using native iOS 26 APIs:

### 1. Basic Glass Effect ✅
Learn the fundamentals of `.glassEffect()` modifier:

```swift
Text("Hello, Glass!")
    .padding()
    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
```

### 2. Interactive Glass ✅
Touch-responsive glass with `.interactive()`:

```swift
Button("Tap Me") { }
    .buttonStyle(.glass)
    .buttonBorderShape(.capsule)
```

### 3. Morphing Glass ✅
Fluid transitions with `GlassEffectContainer`:

```swift
@Namespace private var namespace

GlassEffectContainer(spacing: 12) {
    Button { } label: {
        Image(systemName: isExpanded ? "xmark" : "plus")
    }
    .buttonStyle(.glassProminent)
    .glassEffectID("main", in: namespace)
    
    if isExpanded {
        // More buttons that morph from/to main
    }
}
```

### 4. Glass with Blur ✅
Understand how glass interacts with blur and materials:

```swift
ZStack {
    Image("background")
        .blur(radius: 10)
    
    Text("Overlay")
        .glassEffect(.regular, in: .capsule)
}
```

### 5. Glass with Tint ✅
Add color personality to your glass:

```swift
Text("Tinted Glass")
    .padding()
    .glassEffect(
        .regular.tint(.purple.opacity(0.3)),
        in: RoundedRectangle(cornerRadius: 16)
    )
```

### 6. Glass Navigation Bar ✅
Build beautiful navigation components:

```swift
GlassEffectContainer {
    HStack {
        Button { } label: {
            Image(systemName: "chevron.left")
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        
        Spacer()
        Text("Title")
        Spacer()
    }
    .padding()
    .glassEffect(.regular, in: Rectangle())
}
```

### 7. Glass Tab Bar ✅
Create stunning tab bars with morphing:

```swift
GlassEffectContainer(spacing: 0) {
    HStack(spacing: 0) {
        ForEach(tabs) { tab in
            TabButton(tab: tab, isSelected: selectedTab == tab.id)
                .glassEffectID(tab.id, in: namespace)
        }
    }
    .glassEffect(.regular, in: Capsule())
}
```

### 8. Glass Card ✅
Design beautiful content containers:

```swift
VStack(alignment: .leading, spacing: 12) {
    Text("Card Title")
        .font(.title2.bold())
    
    Text("Card content here...")
        .foregroundStyle(.secondary)
}
.padding(20)
.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
```

### 9. Glass Button ✅
Master all button styles and configurations:

```swift
// Translucent
Button("Glass") { }
    .buttonStyle(.glass)

// Prominent (opaque)
Button("Prominent") { }
    .buttonStyle(.glassProminent)

// Tinted
Button("Tinted") { }
    .buttonStyle(.glass)
    .tint(.purple)
```

### 10. Glass Modal ✅
Sheets, alerts, and popup menus:

```swift
.sheet(isPresented: $showSheet) {
    SheetContent()
        .presentationBackground(.ultraThinMaterial)
        .presentationDetents([.medium, .large])
}
```

## Usage

### Quick Start

```swift
import SwiftUI
import LiquidGlassPlayground

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            // Launch the experiments index
            LiquidGlassPlayground.mainView
        }
    }
}
```

### Basic Glass Card

```swift
import SwiftUI

@available(iOS 26.0, *)
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
            
            // Glass card using native iOS 26 API
            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 48))
                Text("Liquid Glass")
                    .font(.title.bold())
                Text("iOS 26")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(32)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        }
    }
}
```

### Interactive Morphing Demo

```swift
@available(iOS 26.0, *)
struct MorphingDemo: View {
    @State private var isExpanded = false
    @Namespace private var namespace
    
    var body: some View {
        GlassEffectContainer(spacing: 12) {
            VStack(spacing: 12) {
                // Main toggle
                Button {
                    withAnimation(.bouncy) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "xmark" : "plus")
                        .font(.title2)
                        .frame(width: 56, height: 56)
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.circle)
                .glassEffectID("main", in: namespace)
                
                // Expandable items
                if isExpanded {
                    ForEach(["camera", "photo", "doc"], id: \.self) { icon in
                        Button { } label: {
                            Image(systemName: icon)
                                .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .glassEffectID(icon, in: namespace)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
    }
}
```

## Code Examples

### Glass Button Styles

```swift
@available(iOS 26.0, *)
struct GlassButtonExamples: View {
    var body: some View {
        VStack(spacing: 16) {
            // Translucent glass button
            Button("Glass Button") { }
                .buttonStyle(.glass)
                .buttonBorderShape(.capsule)
            
            // Prominent (opaque) glass button
            Button("Prominent") { }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.capsule)
            
            // Tinted glass button
            Button("Tinted") { }
                .buttonStyle(.glass)
                .tint(.purple)
            
            // Icon button
            Button { } label: {
                Image(systemName: "heart.fill")
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
        }
    }
}
```

### Glass Navigation Bar

```swift
@available(iOS 26.0, *)
struct GlassNavBar: View {
    @Namespace private var namespace
    
    var body: some View {
        GlassEffectContainer {
            HStack {
                Button { } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .glassEffectID("back", in: namespace)
                
                Spacer()
                
                Text("Liquid Glass")
                    .font(.headline)
                
                Spacer()
                
                Button { } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .glassEffectID("more", in: namespace)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassEffect(.regular, in: Rectangle())
        }
    }
}
```

### Glass Tab Bar

```swift
@available(iOS 26.0, *)
struct GlassTabBar: View {
    @Binding var selectedTab: Int
    @Namespace private var namespace
    
    let tabs = ["house.fill", "magnifyingglass", "plus.circle.fill", "heart.fill", "person.fill"]
    
    var body: some View {
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = index
                        }
                    } label: {
                        Image(systemName: tabs[index])
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .foregroundStyle(selectedTab == index ? .blue : .secondary)
                            .background {
                                if selectedTab == index {
                                    Capsule()
                                        .fill(.blue.opacity(0.15))
                                        .matchedGeometryEffect(id: "selection", in: namespace)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .glassEffectID("tab-\(index)", in: namespace)
                }
            }
            .padding(8)
            .glassEffect(.regular, in: Capsule())
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
