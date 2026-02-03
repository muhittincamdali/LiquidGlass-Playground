import SwiftUI

// MARK: - PresetLibrary

/// A collection of curated Liquid Glass presets.
///
/// Access the shared instance to browse and apply presets:
/// ```swift
/// let frosted = PresetLibrary.shared.preset(named: "Frosted")
/// ```
public final class PresetLibrary: Sendable {
    /// Shared singleton instance.
    public static let shared = PresetLibrary()

    /// A named glass configuration preset.
    public struct Preset: Identifiable, Sendable {
        public let id: String
        /// Display name of the preset.
        public let name: String
        /// Short description of the visual style.
        public let description: String
        /// The glass configuration for this preset.
        public let configuration: GlassConfiguration

        public init(name: String, description: String, configuration: GlassConfiguration) {
            self.id = name.lowercased().replacingOccurrences(of: " ", with: "-")
            self.name = name
            self.description = description
            self.configuration = configuration
        }
    }

    /// All available presets in the library.
    public let presets: [Preset] = [
        Preset(name: "Frosted", description: "Classic frosted glass", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 20; c.tintOpacity = 0.15; return c }()),
        Preset(name: "Aqua", description: "Water-like transparency", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 12; c.tintColor = .init(red: 0, green: 0.6, blue: 1); c.tintOpacity = 0.2; return c }()),
        Preset(name: "Neon", description: "Vibrant edge glow", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 8; c.borderWidth = 2; c.borderOpacity = 0.8; c.brightness = 0.1; return c }()),
        Preset(name: "Smoke", description: "Dark translucent overlay", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 25; c.tintColor = .init(red: 0.1, green: 0.1, blue: 0.1); c.tintOpacity = 0.5; return c }()),
        Preset(name: "Crystal", description: "High clarity refraction", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 5; c.refractionIndex = 0.9; c.saturation = 1.5; return c }()),
        Preset(name: "Ice", description: "Cold blue tint", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 18; c.tintColor = .init(red: 0.7, green: 0.9, blue: 1); c.tintOpacity = 0.25; return c }()),
        Preset(name: "Amber", description: "Warm golden tone", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 15; c.tintColor = .init(red: 1, green: 0.8, blue: 0.3); c.tintOpacity = 0.2; return c }()),
        Preset(name: "Rose", description: "Soft pink tint", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 16; c.tintColor = .init(red: 1, green: 0.5, blue: 0.6); c.tintOpacity = 0.18; return c }()),
        Preset(name: "Midnight", description: "Deep dark glass", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 30; c.tintColor = .init(red: 0.05, green: 0.05, blue: 0.15); c.tintOpacity = 0.6; c.brightness = -0.1; return c }()),
        Preset(name: "Vapor", description: "Ultra-light blur", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 4; c.tintOpacity = 0.05; c.borderWidth = 0.25; return c }()),
        Preset(name: "Ocean", description: "Deep blue depth", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 22; c.tintColor = .init(red: 0, green: 0.3, blue: 0.7); c.tintOpacity = 0.3; return c }()),
        Preset(name: "Sunset", description: "Orange gradient tint", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 14; c.tintColor = .init(red: 1, green: 0.5, blue: 0.2); c.tintOpacity = 0.22; c.brightness = 0.08; return c }()),
        Preset(name: "Forest", description: "Green-tinted glass", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 18; c.tintColor = .init(red: 0.2, green: 0.7, blue: 0.3); c.tintOpacity = 0.2; return c }()),
        Preset(name: "Lavender", description: "Soft purple haze", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 16; c.tintColor = .init(red: 0.6, green: 0.4, blue: 0.9); c.tintOpacity = 0.18; return c }()),
        Preset(name: "Pearl", description: "Iridescent white", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 10; c.tintOpacity = 0.08; c.saturation = 1.4; c.brightness = 0.12; return c }()),
        Preset(name: "Obsidian", description: "Jet black glass", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 28; c.tintColor = .init(red: 0, green: 0, blue: 0); c.tintOpacity = 0.7; c.brightness = -0.15; return c }()),
        Preset(name: "Copper", description: "Metallic warm tone", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 14; c.tintColor = .init(red: 0.8, green: 0.5, blue: 0.2); c.tintOpacity = 0.25; c.saturation = 1.3; return c }()),
        Preset(name: "Arctic", description: "Bright icy blue", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 20; c.tintColor = .init(red: 0.8, green: 0.95, blue: 1); c.tintOpacity = 0.2; c.brightness = 0.1; return c }()),
        Preset(name: "Sandstone", description: "Earthy matte finish", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 22; c.tintColor = .init(red: 0.7, green: 0.6, blue: 0.4); c.tintOpacity = 0.3; c.saturation = 0.8; return c }()),
        Preset(name: "Prism", description: "Rainbow refraction", configuration: {
            var c = GlassConfiguration(); c.blurRadius = 6; c.refractionIndex = 1.0; c.saturation = 1.8; c.brightness = 0.08; c.borderWidth = 1.5; return c }()),
    ]

    private init() {}

    /// Finds a preset by name.
    /// - Parameter name: The name to search for (case-insensitive).
    /// - Returns: The matching preset, or `nil`.
    public func preset(named name: String) -> Preset? {
        presets.first { $0.name.lowercased() == name.lowercased() }
    }
}
