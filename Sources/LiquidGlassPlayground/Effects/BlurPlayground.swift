import SwiftUI

// MARK: - BlurStyle

/// Defines available blur rendering styles for the playground.
public enum BlurStyle: String, CaseIterable, Identifiable, Sendable {
    /// Standard Gaussian blur.
    case gaussian = "Gaussian"
    /// Material-based system blur.
    case material = "Material"
    /// Variable blur with gradient mask.
    case variable = "Variable"
    /// Directional motion-style blur.
    case directional = "Directional"

    public var id: String { rawValue }
}

// MARK: - BlurPlayground

/// A view that demonstrates different blur styles with adjustable radius.
///
/// ```swift
/// BlurPlayground(style: .gaussian, radius: 12)
/// ```
public struct BlurPlayground: View {
    /// The blur style to apply.
    private let style: BlurStyle
    /// The blur radius intensity.
    private let radius: CGFloat

    /// Creates a blur playground demonstration.
    /// - Parameters:
    ///   - style: The type of blur to render.
    ///   - radius: The blur intensity in points.
    public init(style: BlurStyle = .gaussian, radius: CGFloat = 20) {
        self.style = style
        self.radius = radius
    }

    public var body: some View {
        VStack(spacing: 16) {
            Text(style.rawValue)
                .font(.headline)
                .foregroundStyle(.secondary)

            blurContent
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    /// Renders the appropriate blur content based on the selected style.
    @ViewBuilder
    private var blurContent: some View {
        switch style {
        case .gaussian:
            sampleBackground
                .blur(radius: radius)

        case .material:
            ZStack {
                sampleBackground
                Rectangle()
                    .fill(.ultraThinMaterial)
            }

        case .variable:
            sampleBackground
                .blur(radius: radius)
                .mask(
                    LinearGradient(
                        colors: [.clear, .white],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

        case .directional:
            sampleBackground
                .blur(radius: radius)
                .scaleEffect(x: 1.02, y: 1.0)
        }
    }

    /// Sample gradient background for blur demonstrations.
    private var sampleBackground: some View {
        LinearGradient(
            colors: [.indigo, .cyan, .mint],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay {
            Image(systemName: "circle.hexagongrid.fill")
                .font(.system(size: 80))
                .foregroundStyle(.white.opacity(0.3))
        }
    }
}
