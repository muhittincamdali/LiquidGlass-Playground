// PresetManager.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Preset Manager

/// Manages the persistence and retrieval of glass effect presets.
///
/// The PresetManager handles saving, loading, and organizing presets
/// using UserDefaults for local storage with optional iCloud sync.
///
/// ## Usage
/// ```swift
/// let manager = PresetManager()
/// let presets = manager.loadPresets()
/// manager.save(presets: updatedPresets)
/// ```
final class PresetManager {
    
    // MARK: - Constants
    
    private let presetsKey = "com.liquidglass.playground.presets"
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Public Methods
    
    /// Loads all saved presets from storage.
    /// - Returns: An array of saved glass presets.
    func loadPresets() -> [GlassPreset] {
        guard let data = userDefaults.data(forKey: presetsKey) else {
            return defaultPresets
        }
        
        do {
            let presets = try decoder.decode([GlassPreset].self, from: data)
            return presets
        } catch {
            print("Failed to decode presets: \(error)")
            return defaultPresets
        }
    }
    
    /// Saves the given presets to storage.
    /// - Parameter presets: The presets to save.
    func save(presets: [GlassPreset]) {
        do {
            let data = try encoder.encode(presets)
            userDefaults.set(data, forKey: presetsKey)
        } catch {
            print("Failed to encode presets: \(error)")
        }
    }
    
    /// Adds a single preset to storage.
    /// - Parameter preset: The preset to add.
    func add(preset: GlassPreset) {
        var presets = loadPresets()
        presets.append(preset)
        save(presets: presets)
    }
    
    /// Removes a preset from storage.
    /// - Parameter id: The ID of the preset to remove.
    func remove(id: UUID) {
        var presets = loadPresets()
        presets.removeAll { $0.id == id }
        save(presets: presets)
    }
    
    /// Updates an existing preset.
    /// - Parameter preset: The updated preset.
    func update(preset: GlassPreset) {
        var presets = loadPresets()
        if let index = presets.firstIndex(where: { $0.id == preset.id }) {
            presets[index] = preset
            save(presets: presets)
        }
    }
    
    /// Exports presets to JSON data.
    /// - Parameter presets: The presets to export.
    /// - Returns: JSON data representing the presets.
    func export(presets: [GlassPreset]) -> Data? {
        try? encoder.encode(presets)
    }
    
    /// Imports presets from JSON data.
    /// - Parameter data: The JSON data to import.
    /// - Returns: The imported presets, or nil if decoding fails.
    func importPresets(from data: Data) -> [GlassPreset]? {
        try? decoder.decode([GlassPreset].self, from: data)
    }
    
    /// Resets to default presets.
    func resetToDefaults() {
        save(presets: defaultPresets)
    }
    
    // MARK: - Default Presets
    
    /// The collection of built-in default presets.
    var defaultPresets: [GlassPreset] {
        [
            // Subtle presets
            GlassPreset(
                id: UUID(),
                name: "Whisper",
                parameters: makeParameters(blur: 8, tintOpacity: 0.05, corner: 12),
                createdAt: Date(),
                tags: ["subtle", "minimal"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Mist",
                parameters: makeParameters(blur: 15, tintOpacity: 0.1, corner: 16),
                createdAt: Date(),
                tags: ["subtle", "soft"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Haze",
                parameters: makeParameters(blur: 20, tintOpacity: 0.08, corner: 20),
                createdAt: Date(),
                tags: ["subtle", "elegant"]
            ),
            
            // Bold presets
            GlassPreset(
                id: UUID(),
                name: "Frosted",
                parameters: makeParameters(blur: 35, tintOpacity: 0.15, corner: 24),
                createdAt: Date(),
                tags: ["bold", "frosted"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Crystal",
                parameters: makeParameters(blur: 25, tintOpacity: 0.2, corner: 16, specular: true),
                createdAt: Date(),
                tags: ["bold", "shiny"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Ice",
                parameters: makeParameters(blur: 30, tintOpacity: 0.12, corner: 20, tintColor: .cyan),
                createdAt: Date(),
                tags: ["bold", "cool"]
            ),
            
            // Colorful presets
            GlassPreset(
                id: UUID(),
                name: "Sunset",
                parameters: makeParameters(blur: 20, tintOpacity: 0.25, corner: 16, tintColor: .orange),
                createdAt: Date(),
                tags: ["colorful", "warm"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Ocean",
                parameters: makeParameters(blur: 22, tintOpacity: 0.2, corner: 18, tintColor: .blue),
                createdAt: Date(),
                tags: ["colorful", "cool"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Forest",
                parameters: makeParameters(blur: 18, tintOpacity: 0.18, corner: 14, tintColor: .green),
                createdAt: Date(),
                tags: ["colorful", "natural"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Lavender",
                parameters: makeParameters(blur: 20, tintOpacity: 0.22, corner: 20, tintColor: .purple),
                createdAt: Date(),
                tags: ["colorful", "soft"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Rose",
                parameters: makeParameters(blur: 18, tintOpacity: 0.2, corner: 16, tintColor: .pink),
                createdAt: Date(),
                tags: ["colorful", "romantic"]
            ),
            
            // Modern presets
            GlassPreset(
                id: UUID(),
                name: "Minimal",
                parameters: makeParameters(blur: 10, tintOpacity: 0.03, corner: 8, border: 0),
                createdAt: Date(),
                tags: ["modern", "minimal"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Sharp",
                parameters: makeParameters(blur: 15, tintOpacity: 0.1, corner: 4, border: 1),
                createdAt: Date(),
                tags: ["modern", "geometric"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Rounded",
                parameters: makeParameters(blur: 20, tintOpacity: 0.12, corner: 30),
                createdAt: Date(),
                tags: ["modern", "soft"]
            ),
            
            // Dark mode presets
            GlassPreset(
                id: UUID(),
                name: "Obsidian",
                parameters: makeParameters(blur: 25, tintOpacity: 0.3, corner: 16, tintColor: .black),
                createdAt: Date(),
                tags: ["dark", "bold"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Midnight",
                parameters: makeParameters(blur: 20, tintOpacity: 0.25, corner: 18, tintColor: .indigo),
                createdAt: Date(),
                tags: ["dark", "elegant"]
            ),
            
            // Animated presets
            GlassPreset(
                id: UUID(),
                name: "Pulse",
                parameters: makeAnimatedParameters(animation: true, duration: 1.5),
                createdAt: Date(),
                tags: ["animated", "subtle"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Breathe",
                parameters: makeAnimatedParameters(animation: true, duration: 2.5, autoReverse: true),
                createdAt: Date(),
                tags: ["animated", "relaxing"]
            ),
            
            // Special effect presets
            GlassPreset(
                id: UUID(),
                name: "Glow",
                parameters: makeParameters(blur: 20, tintOpacity: 0.15, corner: 20, shadow: 15),
                createdAt: Date(),
                tags: ["effect", "glow"]
            ),
            GlassPreset(
                id: UUID(),
                name: "Neon",
                parameters: makeParameters(blur: 15, tintOpacity: 0.25, corner: 12, tintColor: .cyan, shadow: 20),
                createdAt: Date(),
                tags: ["effect", "vibrant"]
            )
        ]
    }
    
    // MARK: - Helper Methods
    
    private func makeParameters(
        blur: Double,
        tintOpacity: Double,
        corner: Double,
        tintColor: Color = .clear,
        border: Double = 0.5,
        specular: Bool = false,
        shadow: Double = 10
    ) -> GlassParameters {
        var params = GlassParameters()
        params.blurRadius = blur
        params.tintOpacity = tintOpacity
        params.tintColor = CodableColor(tintColor)
        params.cornerRadius = corner
        params.borderWidth = border
        params.showSpecularHighlight = specular
        params.shadowRadius = shadow
        return params
    }
    
    private func makeAnimatedParameters(
        animation: Bool,
        duration: Double,
        autoReverse: Bool = false
    ) -> GlassParameters {
        var params = GlassParameters()
        params.enableAnimation = animation
        params.animationDuration = duration
        params.autoReverseAnimation = autoReverse
        params.loopAnimation = true
        return params
    }
}

// MARK: - Preset Category

/// Categories for organizing presets.
enum PresetCategory: String, CaseIterable, Identifiable {
    case all
    case subtle
    case bold
    case colorful
    case modern
    case dark
    case animated
    case effect
    case custom
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var systemImage: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .subtle: return "drop"
        case .bold: return "bold"
        case .colorful: return "paintpalette"
        case .modern: return "square.stack.3d.up"
        case .dark: return "moon"
        case .animated: return "play.circle"
        case .effect: return "sparkles"
        case .custom: return "star"
        }
    }
}
