<p align="center">
  <img src="Assets/logo.png" alt="Liquid Glass Playground" width="200"/>
</p>

<h1 align="center">Liquid Glass Playground</h1>

<p align="center">
  <strong>🎮 Interactive Swift Playground for exploring Liquid Glass effects</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-26-blue.svg" alt="iOS 26"/>
  <img src="https://img.shields.io/badge/Swift_Playgrounds-5.0-orange.svg" alt="Swift Playgrounds"/>
</p>

---

## What's Inside

Interactive playground to experiment with iOS 26's Liquid Glass:

### Experiments

1. **Glass Opacity** - Adjust transparency
2. **Blur Intensity** - Control blur amount
3. **Tint Colors** - Add color overlays
4. **Border Effects** - Glass borders
5. **Animations** - Glass transitions
6. **Refraction** - Light bending effects

## Usage

```swift
// Open in Swift Playgrounds or Xcode

import LiquidGlassPlayground

// Experiment with parameters
let glass = GlassView()
    .opacity(0.3)
    .blur(20)
    .tint(.blue)
    .border(width: 1, color: .white.opacity(0.3))

// See real-time preview
PlaygroundPage.current.setLiveView(glass)
```

## Requirements

- Swift Playgrounds 5.0+ or Xcode 18+
- iOS 26 SDK
- Apple Silicon Mac or iPad

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License
