// GlassParameters.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Glass Parameters

/// A comprehensive model for configuring Liquid Glass effects.
///
/// `GlassParameters` encapsulates all adjustable properties for creating
/// custom glass effects, including visual appearance, lighting, and animation.
///
/// ## Example
/// ```swift
/// var parameters = GlassParameters()
/// parameters.blurRadius = 20
/// parameters.tintColor = .blue
/// parameters.tintOpacity = 0.3
/// ```
///
/// ## Topics
/// ### Visual Properties
/// - ``blurRadius``
/// - ``tintColor``
/// - ``tintOpacity``
/// - ``saturation``
///
/// ### Light Properties
/// - ``lightIntensity``
/// - ``lightAngle``
/// - ``specularHighlight``
///
/// ### Shape Properties
/// - ``cornerRadius``
/// - ``borderWidth``
/// - ``borderColor``
struct GlassParameters: Codable, Equatable, Hashable {
    
    // MARK: - Blur Properties
    
    /// The blur radius applied to the background. Range: 0-50.
    var blurRadius: Double = 20
    
    /// The style of blur effect to apply.
    var blurStyle: BlurStyle = .systemMaterial
    
    /// Whether to use variable blur based on depth.
    var useVariableBlur: Bool = false
    
    /// The minimum blur for variable blur effect. Range: 0-25.
    var variableBlurMin: Double = 5
    
    /// The maximum blur for variable blur effect. Range: 25-50.
    var variableBlurMax: Double = 40
    
    // MARK: - Tint Properties
    
    /// The tint color applied to the glass effect.
    var tintColor: CodableColor = CodableColor(.clear)
    
    /// The opacity of the tint color. Range: 0-1.
    var tintOpacity: Double = 0.2
    
    /// Whether to use gradient tint instead of solid color.
    var useGradientTint: Bool = false
    
    /// The secondary color for gradient tint.
    var gradientSecondaryColor: CodableColor = CodableColor(.blue)
    
    /// The angle of the gradient in degrees. Range: 0-360.
    var gradientAngle: Double = 45
    
    // MARK: - Saturation Properties
    
    /// The saturation level of the background. Range: 0-2.
    var saturation: Double = 1.0
    
    /// Whether to desaturate colors outside the glass area.
    var desaturateBackground: Bool = false
    
    // MARK: - Brightness Properties
    
    /// The brightness adjustment. Range: -1 to 1.
    var brightness: Double = 0.0
    
    /// The contrast adjustment. Range: 0.5 to 2.
    var contrast: Double = 1.0
    
    // MARK: - Light Properties
    
    /// The intensity of the specular highlight. Range: 0-1.
    var lightIntensity: Double = 0.3
    
    /// The angle of the light source in degrees. Range: 0-360.
    var lightAngle: Double = 315
    
    /// Whether to show specular highlights.
    var showSpecularHighlight: Bool = true
    
    /// The size of the specular highlight. Range: 0-1.
    var specularSize: Double = 0.5
    
    /// The softness of the specular highlight edges. Range: 0-1.
    var specularSoftness: Double = 0.7
    
    /// The color of the specular highlight.
    var specularColor: CodableColor = CodableColor(.white)
    
    // MARK: - Refraction Properties
    
    /// Whether to enable refraction effect.
    var enableRefraction: Bool = true
    
    /// The intensity of the refraction effect. Range: 0-1.
    var refractionIntensity: Double = 0.2
    
    /// The index of refraction. Range: 1-2.
    var refractionIndex: Double = 1.5
    
    // MARK: - Shadow Properties
    
    /// Whether to show a drop shadow.
    var showShadow: Bool = true
    
    /// The color of the shadow.
    var shadowColor: CodableColor = CodableColor(.black.opacity(0.3))
    
    /// The radius of the shadow blur. Range: 0-30.
    var shadowRadius: Double = 10
    
    /// The horizontal offset of the shadow. Range: -20 to 20.
    var shadowOffsetX: Double = 0
    
    /// The vertical offset of the shadow. Range: -20 to 20.
    var shadowOffsetY: Double = 5
    
    // MARK: - Border Properties
    
    /// The corner radius of the glass shape. Range: 0-50.
    var cornerRadius: Double = 20
    
    /// The width of the border. Range: 0-10.
    var borderWidth: Double = 0.5
    
    /// The color of the border.
    var borderColor: CodableColor = CodableColor(.white.opacity(0.3))
    
    /// Whether to use gradient border.
    var useGradientBorder: Bool = true
    
    // MARK: - Animation Properties
    
    /// Whether to enable animations.
    var enableAnimation: Bool = false
    
    /// The duration of animations in seconds. Range: 0.1-5.
    var animationDuration: Double = 1.0
    
    /// The animation timing curve.
    var animationCurve: AnimationCurve = .easeInOut
    
    /// Whether to loop animations.
    var loopAnimation: Bool = true
    
    /// Whether to auto-reverse animations.
    var autoReverseAnimation: Bool = true
    
    // MARK: - Depth Properties
    
    /// The perceived depth of the glass effect. Range: 0-1.
    var depth: Double = 0.5
    
    /// Whether to enable parallax depth effect.
    var enableParallax: Bool = false
    
    /// The intensity of the parallax effect. Range: 0-1.
    var parallaxIntensity: Double = 0.3
    
    // MARK: - Computed Properties
    
    /// The SwiftUI Color representation of the tint.
    var swiftUITintColor: Color {
        tintColor.color.opacity(tintOpacity)
    }
    
    /// The SwiftUI Color representation of the border.
    var swiftUIBorderColor: Color {
        borderColor.color
    }
    
    /// The SwiftUI animation based on current settings.
    var swiftUIAnimation: Animation? {
        guard enableAnimation else { return nil }
        
        let base: Animation
        switch animationCurve {
        case .linear: base = .linear(duration: animationDuration)
        case .easeIn: base = .easeIn(duration: animationDuration)
        case .easeOut: base = .easeOut(duration: animationDuration)
        case .easeInOut: base = .easeInOut(duration: animationDuration)
        case .spring: base = .spring(duration: animationDuration)
        }
        
        if loopAnimation {
            return autoReverseAnimation
                ? base.repeatForever(autoreverses: true)
                : base.repeatForever(autoreverses: false)
        }
        
        return base
    }
}

// MARK: - Blur Style

/// The available blur styles for glass effects.
enum BlurStyle: String, Codable, CaseIterable, Identifiable {
    case systemMaterial
    case systemUltraThinMaterial
    case systemThinMaterial
    case systemThickMaterial
    case systemChromeMaterial
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .systemMaterial: return "Regular"
        case .systemUltraThinMaterial: return "Ultra Thin"
        case .systemThinMaterial: return "Thin"
        case .systemThickMaterial: return "Thick"
        case .systemChromeMaterial: return "Chrome"
        }
    }
    
    @ViewBuilder
    var material: some ShapeStyle {
        switch self {
        case .systemMaterial: Material.regular
        case .systemUltraThinMaterial: Material.ultraThinMaterial
        case .systemThinMaterial: Material.thinMaterial
        case .systemThickMaterial: Material.thickMaterial
        case .systemChromeMaterial: Material.ultraThickMaterial
        }
    }
}

// MARK: - Animation Curve

/// The available animation timing curves.
enum AnimationCurve: String, Codable, CaseIterable, Identifiable {
    case linear
    case easeIn
    case easeOut
    case easeInOut
    case spring
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .linear: return "Linear"
        case .easeIn: return "Ease In"
        case .easeOut: return "Ease Out"
        case .easeInOut: return "Ease In-Out"
        case .spring: return "Spring"
        }
    }
}

// MARK: - Codable Color

/// A Codable wrapper for SwiftUI Color.
struct CodableColor: Codable, Equatable, Hashable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double
    
    init(_ color: Color) {
        let resolved = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        resolved.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.opacity = Double(a)
    }
    
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - Glass Preset

/// A saved configuration preset for glass effects.
struct GlassPreset: Identifiable, Codable {
    let id: UUID
    var name: String
    var parameters: GlassParameters
    var createdAt: Date
    var tags: [String] = []
    var isFavorite: Bool = false
    
    /// A brief description generated from parameters.
    var description: String {
        var parts: [String] = []
        
        if parameters.blurRadius > 30 {
            parts.append("Heavy blur")
        } else if parameters.blurRadius > 15 {
            parts.append("Medium blur")
        } else {
            parts.append("Light blur")
        }
        
        if parameters.tintOpacity > 0.3 {
            parts.append("Strong tint")
        }
        
        if parameters.showSpecularHighlight {
            parts.append("Specular")
        }
        
        return parts.joined(separator: " • ")
    }
}

// MARK: - Parameter Validation

extension GlassParameters {
    
    /// Validates all parameters and clamps them to valid ranges.
    mutating func validate() {
        blurRadius = blurRadius.clamped(to: 0...50)
        variableBlurMin = variableBlurMin.clamped(to: 0...25)
        variableBlurMax = variableBlurMax.clamped(to: 25...50)
        tintOpacity = tintOpacity.clamped(to: 0...1)
        gradientAngle = gradientAngle.clamped(to: 0...360)
        saturation = saturation.clamped(to: 0...2)
        brightness = brightness.clamped(to: -1...1)
        contrast = contrast.clamped(to: 0.5...2)
        lightIntensity = lightIntensity.clamped(to: 0...1)
        lightAngle = lightAngle.clamped(to: 0...360)
        specularSize = specularSize.clamped(to: 0...1)
        specularSoftness = specularSoftness.clamped(to: 0...1)
        refractionIntensity = refractionIntensity.clamped(to: 0...1)
        refractionIndex = refractionIndex.clamped(to: 1...2)
        shadowRadius = shadowRadius.clamped(to: 0...30)
        shadowOffsetX = shadowOffsetX.clamped(to: -20...20)
        shadowOffsetY = shadowOffsetY.clamped(to: -20...20)
        cornerRadius = cornerRadius.clamped(to: 0...50)
        borderWidth = borderWidth.clamped(to: 0...10)
        animationDuration = animationDuration.clamped(to: 0.1...5)
        depth = depth.clamped(to: 0...1)
        parallaxIntensity = parallaxIntensity.clamped(to: 0...1)
    }
}

// MARK: - Comparable Extension

extension Comparable {
    
    /// Clamps the value to the specified range.
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
