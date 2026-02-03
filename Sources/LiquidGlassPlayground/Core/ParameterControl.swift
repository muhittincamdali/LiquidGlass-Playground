import SwiftUI

// MARK: - ParameterControl

/// Describes a single adjustable parameter in the playground.
public struct ParameterControl: Identifiable, Sendable {
    /// Unique identifier for this control.
    public let id: String
    /// Human-readable label displayed in the UI.
    public let label: String
    /// Minimum allowed value.
    public let minValue: Double
    /// Maximum allowed value.
    public let maxValue: Double
    /// Step increment for the slider.
    public let step: Double
    /// SF Symbol name for the control icon.
    public let iconName: String

    /// Creates a new parameter control definition.
    public init(
        id: String,
        label: String,
        minValue: Double,
        maxValue: Double,
        step: Double = 0.1,
        iconName: String = "slider.horizontal.3"
    ) {
        self.id = id
        self.label = label
        self.minValue = minValue
        self.maxValue = maxValue
        self.step = step
        self.iconName = iconName
    }
}

// MARK: - Default Controls

extension ParameterControl {
    /// All available controls for a glass configuration.
    public static let allControls: [ParameterControl] = [
        .init(id: "blurRadius", label: "Blur Radius", minValue: 0, maxValue: 50, step: 1, iconName: "aqi.medium"),
        .init(id: "refractionIndex", label: "Refraction", minValue: 0, maxValue: 1, step: 0.05, iconName: "light.recessed"),
        .init(id: "tintOpacity", label: "Tint Opacity", minValue: 0, maxValue: 1, step: 0.05, iconName: "drop.halffull"),
        .init(id: "cornerRadius", label: "Corner Radius", minValue: 0, maxValue: 40, step: 1, iconName: "square.on.square"),
        .init(id: "saturation", label: "Saturation", minValue: 0, maxValue: 2, step: 0.1, iconName: "paintpalette"),
        .init(id: "brightness", label: "Brightness", minValue: -0.5, maxValue: 0.5, step: 0.05, iconName: "sun.max"),
        .init(id: "shadowRadius", label: "Shadow", minValue: 0, maxValue: 30, step: 1, iconName: "shadow"),
        .init(id: "borderWidth", label: "Border Width", minValue: 0, maxValue: 4, step: 0.25, iconName: "square.dashed"),
        .init(id: "borderOpacity", label: "Border Opacity", minValue: 0, maxValue: 1, step: 0.05, iconName: "circle.dotted"),
    ]
}
