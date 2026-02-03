// PlaygroundConfiguration.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Playground Configuration

/// Global configuration settings for the Liquid Glass Playground.
///
/// This struct provides centralized access to configuration values,
/// including feature flags, default values, and appearance settings.
///
/// ## Usage
/// ```swift
/// let config = PlaygroundConfiguration.shared
/// let maxBlur = config.maxBlurRadius
/// ```
struct PlaygroundConfiguration {
    
    // MARK: - Singleton
    
    /// The shared configuration instance.
    static let shared = PlaygroundConfiguration()
    
    // MARK: - Feature Flags
    
    /// Whether the code export feature is enabled.
    let codeExportEnabled = true
    
    /// Whether the preset sharing feature is enabled.
    let presetSharingEnabled = true
    
    /// Whether advanced experiments are unlocked.
    let advancedExperimentsEnabled = true
    
    /// Whether haptic feedback is available.
    let hapticsAvailable = true
    
    /// Whether the tutorial system is enabled.
    let tutorialsEnabled = true
    
    /// Whether performance monitoring is enabled.
    let performanceMonitoringEnabled = false
    
    /// Whether debug mode is enabled.
    let debugModeEnabled = false
    
    // MARK: - Parameter Ranges
    
    /// The maximum blur radius value.
    let maxBlurRadius: Double = 50
    
    /// The minimum blur radius value.
    let minBlurRadius: Double = 0
    
    /// The maximum tint opacity value.
    let maxTintOpacity: Double = 1.0
    
    /// The minimum tint opacity value.
    let minTintOpacity: Double = 0.0
    
    /// The maximum corner radius value.
    let maxCornerRadius: Double = 50
    
    /// The minimum corner radius value.
    let minCornerRadius: Double = 0
    
    /// The maximum border width value.
    let maxBorderWidth: Double = 10
    
    /// The minimum border width value.
    let minBorderWidth: Double = 0
    
    /// The maximum shadow radius value.
    let maxShadowRadius: Double = 30
    
    /// The minimum shadow radius value.
    let minShadowRadius: Double = 0
    
    /// The maximum animation duration.
    let maxAnimationDuration: Double = 5.0
    
    /// The minimum animation duration.
    let minAnimationDuration: Double = 0.1
    
    // MARK: - Default Values
    
    /// The default glass parameters.
    var defaultParameters: GlassParameters {
        GlassParameters()
    }
    
    /// The default preview background.
    let defaultBackground: PreviewBackground = .gradient
    
    /// The default animation speed multiplier.
    let defaultAnimationSpeed: Double = 1.0
    
    // MARK: - UI Configuration
    
    /// The spacing between control elements.
    let controlSpacing: CGFloat = 16
    
    /// The padding for control panels.
    let controlPadding: CGFloat = 20
    
    /// The corner radius for cards.
    let cardCornerRadius: CGFloat = 16
    
    /// The minimum touch target size.
    let minimumTouchTarget: CGFloat = 44
    
    /// The standard icon size.
    let standardIconSize: CGFloat = 24
    
    /// The large icon size.
    let largeIconSize: CGFloat = 32
    
    // MARK: - Animation Configuration
    
    /// The default animation for UI transitions.
    let defaultAnimation: Animation = .spring(duration: 0.3)
    
    /// The animation for parameter changes.
    let parameterChangeAnimation: Animation = .easeOut(duration: 0.2)
    
    /// The animation for showing/hiding panels.
    let panelAnimation: Animation = .spring(duration: 0.4, bounce: 0.2)
    
    // MARK: - Color Palette
    
    /// The primary accent color.
    let primaryAccentColor = Color.blue
    
    /// The secondary accent color.
    let secondaryAccentColor = Color.purple
    
    /// The success color.
    let successColor = Color.green
    
    /// The warning color.
    let warningColor = Color.orange
    
    /// The error color.
    let errorColor = Color.red
    
    // MARK: - Performance Configuration
    
    /// The maximum number of history entries.
    let maxHistoryEntries = 50
    
    /// The debounce interval for parameter changes in milliseconds.
    let parameterDebounceInterval: Int = 100
    
    /// The maximum number of saved presets.
    let maxSavedPresets = 100
    
    /// The preview render quality (0.5 - 1.0).
    let previewRenderQuality: CGFloat = 1.0
    
    // MARK: - Export Configuration
    
    /// The code generation style.
    let codeStyle: CodeStyle = .swiftUI
    
    /// Whether to include comments in generated code.
    let includeCodeComments = true
    
    /// Whether to include preview provider in generated code.
    let includePreviewProvider = true
    
    // MARK: - Computed Properties
    
    /// The blur radius range.
    var blurRadiusRange: ClosedRange<Double> {
        minBlurRadius...maxBlurRadius
    }
    
    /// The tint opacity range.
    var tintOpacityRange: ClosedRange<Double> {
        minTintOpacity...maxTintOpacity
    }
    
    /// The corner radius range.
    var cornerRadiusRange: ClosedRange<Double> {
        minCornerRadius...maxCornerRadius
    }
    
    /// The border width range.
    var borderWidthRange: ClosedRange<Double> {
        minBorderWidth...maxBorderWidth
    }
    
    /// The shadow radius range.
    var shadowRadiusRange: ClosedRange<Double> {
        minShadowRadius...maxShadowRadius
    }
    
    /// The animation duration range.
    var animationDurationRange: ClosedRange<Double> {
        minAnimationDuration...maxAnimationDuration
    }
}

// MARK: - Code Style

/// The style of generated code.
enum CodeStyle: String, CaseIterable, Identifiable {
    case swiftUI
    case uiKit
    case combined
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .swiftUI: return "SwiftUI"
        case .uiKit: return "UIKit"
        case .combined: return "Combined"
        }
    }
}

// MARK: - Experiment Type

/// The types of experiments available in the playground.
enum ExperimentType: String, CaseIterable, Identifiable {
    case basicGlass
    case dynamicGlass
    case layeredGlass
    case animatedGlass
    case colorfulGlass
    case interactiveGlass
    case physicsGlass
    case morphingGlass
    case particleGlass
    case advancedGlass
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .basicGlass: return "Basic Glass"
        case .dynamicGlass: return "Dynamic Glass"
        case .layeredGlass: return "Layered Glass"
        case .animatedGlass: return "Animated Glass"
        case .colorfulGlass: return "Colorful Glass"
        case .interactiveGlass: return "Interactive Glass"
        case .physicsGlass: return "Physics Glass"
        case .morphingGlass: return "Morphing Glass"
        case .particleGlass: return "Particle Glass"
        case .advancedGlass: return "Advanced Glass"
        }
    }
    
    var description: String {
        switch self {
        case .basicGlass: return "Learn the fundamentals of glass effects"
        case .dynamicGlass: return "Create dynamic, responsive glass surfaces"
        case .layeredGlass: return "Stack multiple glass layers for depth"
        case .animatedGlass: return "Add smooth animations to glass effects"
        case .colorfulGlass: return "Explore color tints and gradients"
        case .interactiveGlass: return "Build touch-responsive glass interfaces"
        case .physicsGlass: return "Apply physics simulations to glass"
        case .morphingGlass: return "Create shape-shifting glass effects"
        case .particleGlass: return "Combine particles with glass effects"
        case .advancedGlass: return "Master advanced glass techniques"
        }
    }
    
    var systemImage: String {
        switch self {
        case .basicGlass: return "square.fill"
        case .dynamicGlass: return "waveform"
        case .layeredGlass: return "square.3.layers.3d"
        case .animatedGlass: return "play.fill"
        case .colorfulGlass: return "paintpalette.fill"
        case .interactiveGlass: return "hand.tap.fill"
        case .physicsGlass: return "atom"
        case .morphingGlass: return "wand.and.stars"
        case .particleGlass: return "sparkles"
        case .advancedGlass: return "star.fill"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .basicGlass: return .blue
        case .dynamicGlass: return .purple
        case .layeredGlass: return .green
        case .animatedGlass: return .orange
        case .colorfulGlass: return .pink
        case .interactiveGlass: return .cyan
        case .physicsGlass: return .indigo
        case .morphingGlass: return .mint
        case .particleGlass: return .yellow
        case .advancedGlass: return .red
        }
    }
    
    var features: [String] {
        switch self {
        case .basicGlass:
            return ["Blur effects", "Material backgrounds", "Simple shapes"]
        case .dynamicGlass:
            return ["Responsive sizing", "Adaptive colors", "Environment-aware"]
        case .layeredGlass:
            return ["Multiple layers", "Z-depth control", "Parallax effects"]
        case .animatedGlass:
            return ["Smooth transitions", "Keyframe animations", "Auto-reverse"]
        case .colorfulGlass:
            return ["Color gradients", "Tint overlays", "Blend modes"]
        case .interactiveGlass:
            return ["Touch gestures", "Haptic feedback", "State transitions"]
        case .physicsGlass:
            return ["Gravity simulation", "Collision detection", "Fluid dynamics"]
        case .morphingGlass:
            return ["Shape interpolation", "Path animations", "Smooth morphing"]
        case .particleGlass:
            return ["Particle systems", "Emission effects", "Field interactions"]
        case .advancedGlass:
            return ["Custom shaders", "Metal integration", "Pro techniques"]
        }
    }
}
