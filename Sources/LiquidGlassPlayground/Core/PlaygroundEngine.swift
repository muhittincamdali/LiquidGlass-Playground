import SwiftUI
import Combine

// MARK: - GlassConfiguration

/// Represents a complete set of Liquid Glass parameters.
public struct GlassConfiguration: Equatable, Codable, Sendable {
    /// Gaussian blur radius applied to the background.
    public var blurRadius: CGFloat = 20
    /// Simulated refraction index for the glass surface.
    public var refractionIndex: CGFloat = 0.5
    /// Tint color overlay on the glass.
    public var tintColor: CodableColor = .init(.white)
    /// Opacity of the tint overlay.
    public var tintOpacity: Double = 0.15
    /// Corner radius for the glass shape.
    public var cornerRadius: CGFloat = 16
    /// Color saturation multiplier for background content.
    public var saturation: Double = 1.2
    /// Brightness adjustment applied to the glass.
    public var brightness: Double = 0.05
    /// Shadow radius beneath the glass element.
    public var shadowRadius: CGFloat = 8
    /// Border stroke width around the glass edge.
    public var borderWidth: CGFloat = 0.5
    /// Opacity of the border stroke.
    public var borderOpacity: Double = 0.3

    /// Creates a default configuration.
    public init() {}
}

// MARK: - CodableColor

/// A `Codable` wrapper around SwiftUI `Color`.
public struct CodableColor: Equatable, Codable, Sendable {
    public var red: Double
    public var green: Double
    public var blue: Double
    public var opacity: Double

    public init(_ color: Color) {
        // Default to white; resolved at render time
        self.red = 1
        self.green = 1
        self.blue = 1
        self.opacity = 1
    }

    public init(red: Double, green: Double, blue: Double, opacity: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }

    /// Converts back to a SwiftUI `Color`.
    public var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - PlaygroundEngine

/// Manages the experiment state for the Liquid Glass playground.
@MainActor
@Observable
public final class PlaygroundEngine {
    /// The current glass configuration being edited.
    public var configuration: GlassConfiguration

    /// Name of the currently loaded preset, if any.
    public private(set) var activePresetName: String?

    /// Undo stack for configuration history.
    private var undoStack: [GlassConfiguration] = []

    /// Maximum undo history depth.
    private let maxUndoDepth = 30

    /// Creates an engine with the given initial configuration.
    /// - Parameter preset: An optional preset to start from.
    public init(preset: PresetLibrary.Preset? = nil) {
        if let preset {
            self.configuration = preset.configuration
            self.activePresetName = preset.name
        } else {
            self.configuration = GlassConfiguration()
            self.activePresetName = nil
        }
    }

    /// Loads a preset into the engine.
    /// - Parameter preset: The preset to apply.
    public func load(preset: PresetLibrary.Preset) {
        pushUndo()
        configuration = preset.configuration
        activePresetName = preset.name
    }

    /// Resets to default configuration.
    public func reset() {
        pushUndo()
        configuration = GlassConfiguration()
        activePresetName = nil
    }

    /// Undoes the last configuration change.
    public func undo() {
        guard let previous = undoStack.popLast() else { return }
        configuration = previous
        activePresetName = nil
    }

    /// Saves the current state to the undo stack.
    private func pushUndo() {
        undoStack.append(configuration)
        if undoStack.count > maxUndoDepth {
            undoStack.removeFirst()
        }
    }

    /// Whether undo is available.
    public var canUndo: Bool {
        !undoStack.isEmpty
    }
}
