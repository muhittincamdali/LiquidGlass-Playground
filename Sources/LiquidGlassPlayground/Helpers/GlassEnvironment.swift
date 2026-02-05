// GlassEnvironment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Glass Environment

/// Environment values for glass effect configuration.
///
/// `GlassEnvironment` provides a centralized way to access
/// device capabilities and environment settings related to
/// glass effects.
struct GlassEnvironment {
    
    // MARK: - Properties
    
    /// Whether the device supports blur effects.
    let supportsBlur: Bool
    
    /// Whether the device supports vibrancy effects.
    let supportsVibrancy: Bool
    
    /// Whether the device is in reduced transparency mode.
    let reducedTransparency: Bool
    
    /// Whether the device supports high refresh rate.
    let supportsProMotion: Bool
    
    /// Whether the device is in a landscape-like orientation.
    let isLandscape: Bool
    
    /// Whether the current color scheme is dark.
    let isDarkAppearance: Bool
    
    /// Whether the device uses a compact width layout.
    let isCompactWidth: Bool
    
    /// Whether the device uses a regular width layout.
    let isRegularWidth: Bool
    
    /// Whether content size is in an accessibility range.
    let isAccessibilitySize: Bool
    
    // MARK: - Static Properties
    
    /// The current glass environment based on device state.
    static var current: GlassEnvironment {
        #if os(iOS)
        let screen = UIScreen.main
        let device = UIDevice.current
        let traits = screen.traitCollection
        
        return GlassEnvironment(
            supportsBlur: !UIAccessibility.isReduceTransparencyEnabled,
            supportsVibrancy: true,
            reducedTransparency: UIAccessibility.isReduceTransparencyEnabled,
            supportsProMotion: screen.maximumFramesPerSecond >= 120,
            isLandscape: device.orientation.isLandscape,
            isDarkAppearance: traits.userInterfaceStyle == .dark,
            isCompactWidth: traits.horizontalSizeClass == .compact,
            isRegularWidth: traits.horizontalSizeClass == .regular,
            isAccessibilitySize: traits.preferredContentSizeCategory.isAccessibilityCategory
        )
        #elseif os(macOS)
        let reduceTransparency = NSWorkspace.shared.accessibilityDisplayShouldReduceTransparency
        let appearance = NSApp?.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        
        return GlassEnvironment(
            supportsBlur: !reduceTransparency,
            supportsVibrancy: true,
            reducedTransparency: reduceTransparency,
            supportsProMotion: true,
            isLandscape: true,
            isDarkAppearance: appearance == .darkAqua,
            isCompactWidth: false,
            isRegularWidth: true,
            isAccessibilitySize: false
        )
        #else
        return GlassEnvironment(
            supportsBlur: true,
            supportsVibrancy: true,
            reducedTransparency: false,
            supportsProMotion: true,
            isLandscape: false,
            isDarkAppearance: false,
            isCompactWidth: false,
            isRegularWidth: true,
            isAccessibilitySize: false
        )
        #endif
    }
    
    // MARK: - Computed Properties
    
    /// Whether glass effects should be simplified for accessibility.
    var shouldSimplifyEffects: Bool {
        reducedTransparency || isAccessibilitySize
    }
    
    /// The recommended blur radius based on device capabilities.
    var recommendedBlurRadius: Double {
        if shouldSimplifyEffects {
            return 10
        }
        return supportsProMotion ? 25 : 20
    }
    
    /// Whether the device is in compact layout.
    var isCompact: Bool {
        isCompactWidth
    }
    
    /// Whether the device is in regular layout.
    var isRegular: Bool {
        isRegularWidth
    }
    
    /// Whether dark mode is enabled.
    var isDarkMode: Bool {
        isDarkAppearance
    }
}

// MARK: - Environment Key

/// The environment key for glass environment values.
struct GlassEnvironmentKey: EnvironmentKey {
    static let defaultValue = GlassEnvironment.current
}

extension EnvironmentValues {
    
    /// The current glass environment.
    var glassEnvironment: GlassEnvironment {
        get { self[GlassEnvironmentKey.self] }
        set { self[GlassEnvironmentKey.self] = newValue }
    }
}

// MARK: - Glass Style

/// Predefined glass effect styles using native iOS 26 Liquid Glass API.
@available(iOS 26.0, macOS 26.0, *)
enum GlassStyle {
    case ultraThin
    case thin
    case regular
    case thick
    case ultraThick
    case chrome
    
    /// The blur radius for this style.
    var blurRadius: Double {
        switch self {
        case .ultraThin: return 5
        case .thin: return 10
        case .regular: return 20
        case .thick: return 30
        case .ultraThick: return 40
        case .chrome: return 15
        }
    }
    
    /// The tint opacity for this style.
    var tintOpacity: Double {
        switch self {
        case .ultraThin: return 0.05
        case .thin: return 0.1
        case .regular: return 0.15
        case .thick: return 0.25
        case .ultraThick: return 0.35
        case .chrome: return 0.2
        }
    }
}

// MARK: - View Extensions

@available(iOS 26.0, macOS 26.0, *)
extension View {
    
    /// Applies a native glass effect to the view.
    /// - Parameters:
    ///   - style: The glass style to apply.
    ///   - cornerRadius: The corner radius for the glass shape.
    /// - Returns: A view with the native iOS 26 glass effect applied.
    func liquidGlass(
        style: GlassStyle = .regular,
        cornerRadius: CGFloat = 16
    ) -> some View {
        self
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    /// Applies a glass card style to the view.
    /// - Parameter padding: The padding inside the glass card.
    /// - Returns: A view styled as a glass card.
    func glassCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
    
    /// Conditionally applies a glass effect based on environment.
    /// - Parameter parameters: The glass parameters to apply.
    /// - Returns: A view with optional glass effect.
    func adaptiveGlass(parameters: GlassParameters) -> some View {
        modifier(AdaptiveGlassModifier(parameters: parameters))
    }
}

// MARK: - Adaptive Glass Modifier

/// A view modifier that applies glass effects adaptively.
@available(iOS 26.0, macOS 26.0, *)
struct AdaptiveGlassModifier: ViewModifier {
    
    let parameters: GlassParameters
    @Environment(\.glassEnvironment) private var environment
    
    func body(content: Content) -> some View {
        if environment.shouldSimplifyEffects {
            content
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: parameters.cornerRadius))
        } else {
            content
                .glassEffect(
                    .regular.tint(parameters.tintColor.color.opacity(parameters.tintOpacity)),
                    in: RoundedRectangle(cornerRadius: parameters.cornerRadius)
                )
        }
    }
}

// MARK: - Preview Helpers

/// Helper functions for SwiftUI previews.
struct PreviewHelpers {
    
    /// Creates a colorful background for previews.
    static func colorfulBackground() -> some View {
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Creates a grid background for previews.
    static func gridBackground() -> some View {
        GeometryReader { geometry in
            Path { path in
                let step: CGFloat = 20
                for x in stride(from: 0, through: geometry.size.width, by: step) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                for y in stride(from: 0, through: geometry.size.height, by: step) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        }
    }
    
    /// Creates sample glass parameters for previews.
    static var sampleParameters: GlassParameters {
        var params = GlassParameters()
        params.blurRadius = 20
        params.tintOpacity = 0.15
        params.tintColor = CodableColor(.blue)
        params.cornerRadius = 20
        return params
    }
}

// MARK: - Glass Math Utilities

/// Mathematical utilities for glass effect calculations.
struct GlassMath {
    
    /// Interpolates between two values.
    static func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double {
        a + (b - a) * t
    }
    
    /// Clamps a value to a range.
    static func clamp(_ value: Double, min: Double, max: Double) -> Double {
        Swift.max(min, Swift.min(max, value))
    }
    
    /// Maps a value from one range to another.
    static func map(
        _ value: Double,
        from inputRange: ClosedRange<Double>,
        to outputRange: ClosedRange<Double>
    ) -> Double {
        let normalized = (value - inputRange.lowerBound) / (inputRange.upperBound - inputRange.lowerBound)
        return outputRange.lowerBound + normalized * (outputRange.upperBound - outputRange.lowerBound)
    }
    
    /// Applies an easing function to a value.
    static func ease(_ t: Double, curve: AnimationCurve) -> Double {
        switch curve {
        case .linear: return t
        case .easeIn: return t * t
        case .easeOut: return 1 - pow(1 - t, 2)
        case .easeInOut: return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
        case .spring: return 1 - cos(t * .pi / 2)
        }
    }
    
    /// Calculates the distance between two points.
    static func distance(_ p1: CGPoint, _ p2: CGPoint) -> Double {
        sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }
    
    /// Normalizes an angle to the range 0-360.
    static func normalizeAngle(_ angle: Double) -> Double {
        var result = angle.truncatingRemainder(dividingBy: 360)
        if result < 0 { result += 360 }
        return result
    }
}
