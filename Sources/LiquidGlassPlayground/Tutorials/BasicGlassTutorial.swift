import SwiftUI

// MARK: - TutorialStep

/// A single step in an interactive tutorial.
public struct TutorialStep: Identifiable, Sendable {
    public let id: Int
    /// Title of the tutorial step.
    public let title: String
    /// Detailed explanation text.
    public let explanation: String
    /// The configuration to demonstrate at this step.
    public let configuration: GlassConfiguration
    /// The parameter to highlight, if any.
    public let highlightedParameter: String?

    public init(
        id: Int,
        title: String,
        explanation: String,
        configuration: GlassConfiguration,
        highlightedParameter: String? = nil
    ) {
        self.id = id
        self.title = title
        self.explanation = explanation
        self.configuration = configuration
        self.highlightedParameter = highlightedParameter
    }
}

// MARK: - BasicGlassTutorial

/// A guided tutorial introducing the fundamentals of Liquid Glass effects.
///
/// Walk through each step to understand how individual parameters
/// affect the glass appearance.
public enum BasicGlassTutorial {
    /// All tutorial steps in order.
    public static let steps: [TutorialStep] = [
        TutorialStep(
            id: 1,
            title: "The Basics",
            explanation: "Start with a simple frosted glass panel. The material modifier provides the translucent backdrop effect.",
            configuration: GlassConfiguration(),
            highlightedParameter: nil
        ),
        TutorialStep(
            id: 2,
            title: "Blur Radius",
            explanation: "Blur radius controls how much the background content is blurred. Higher values create a more frosted look.",
            configuration: {
                var c = GlassConfiguration(); c.blurRadius = 35; return c
            }(),
            highlightedParameter: "blurRadius"
        ),
        TutorialStep(
            id: 3,
            title: "Tint & Color",
            explanation: "Add a color tint to the glass surface. Adjust opacity to control how prominent the tint appears.",
            configuration: {
                var c = GlassConfiguration(); c.tintColor = .init(red: 0.3, green: 0.5, blue: 1); c.tintOpacity = 0.25; return c
            }(),
            highlightedParameter: "tintOpacity"
        ),
        TutorialStep(
            id: 4,
            title: "Refraction",
            explanation: "Refraction simulates light bending through the glass surface. It adds a subtle distortion effect.",
            configuration: {
                var c = GlassConfiguration(); c.refractionIndex = 0.8; c.blurRadius = 10; return c
            }(),
            highlightedParameter: "refractionIndex"
        ),
        TutorialStep(
            id: 5,
            title: "Borders & Edges",
            explanation: "A thin border stroke enhances the glass edge. Adjust width and opacity for subtle or bold outlines.",
            configuration: {
                var c = GlassConfiguration(); c.borderWidth = 1.5; c.borderOpacity = 0.6; return c
            }(),
            highlightedParameter: "borderWidth"
        ),
        TutorialStep(
            id: 6,
            title: "Shadow & Depth",
            explanation: "Shadows create the illusion of depth. A larger radius produces a softer, more diffused shadow.",
            configuration: {
                var c = GlassConfiguration(); c.shadowRadius = 20; c.brightness = 0.05; return c
            }(),
            highlightedParameter: "shadowRadius"
        ),
        TutorialStep(
            id: 7,
            title: "Putting It Together",
            explanation: "Combine all parameters to craft your perfect glass effect. Experiment freely and export when ready!",
            configuration: {
                var c = GlassConfiguration()
                c.blurRadius = 18; c.refractionIndex = 0.5; c.tintColor = .init(red: 0.4, green: 0.6, blue: 1)
                c.tintOpacity = 0.15; c.cornerRadius = 20; c.saturation = 1.3; c.borderWidth = 0.75
                c.borderOpacity = 0.4; c.shadowRadius = 12
                return c
            }(),
            highlightedParameter: nil
        ),
    ]

    /// Total number of tutorial steps.
    public static var totalSteps: Int { steps.count }
}
