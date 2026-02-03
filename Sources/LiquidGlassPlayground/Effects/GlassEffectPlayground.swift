import SwiftUI

// MARK: - GlassEffectPlayground

/// A SwiftUI view that renders a Liquid Glass effect with adjustable parameters.
///
/// Use this view to visualize a `GlassConfiguration` applied over any background content.
///
/// ```swift
/// GlassEffectPlayground(configuration: engine.configuration) {
///     Image("wallpaper")
/// }
/// ```
public struct GlassEffectPlayground<Background: View>: View {
    /// The glass configuration to render.
    private let configuration: GlassConfiguration
    /// The background content visible through the glass.
    private let background: Background

    /// Creates a glass effect playground view.
    /// - Parameters:
    ///   - configuration: The glass parameters to apply.
    ///   - background: A view builder for the background content.
    public init(
        configuration: GlassConfiguration,
        @ViewBuilder background: () -> Background
    ) {
        self.configuration = configuration
        self.background = background()
    }

    public var body: some View {
        ZStack {
            background
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            glassOverlay
                .frame(width: 280, height: 200)
        }
    }

    /// The glass overlay shape with all effects applied.
    @ViewBuilder
    private var glassOverlay: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .fill(configuration.tintColor.color.opacity(configuration.tintOpacity))
            }
            .overlay {
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .strokeBorder(
                        .white.opacity(configuration.borderOpacity),
                        lineWidth: configuration.borderWidth
                    )
            }
            .blur(radius: refractionBlur)
            .saturation(configuration.saturation)
            .brightness(configuration.brightness)
            .shadow(
                color: .black.opacity(0.2),
                radius: configuration.shadowRadius,
                x: 0,
                y: configuration.shadowRadius / 3
            )
    }

    /// Computed refraction-based inner blur for the glass surface.
    private var refractionBlur: CGFloat {
        configuration.refractionIndex * 2.0
    }
}

// MARK: - Default Background

extension GlassEffectPlayground where Background == AnyView {
    /// Creates a glass effect playground with a default gradient background.
    /// - Parameter configuration: The glass parameters to apply.
    public init(configuration: GlassConfiguration) {
        self.configuration = configuration
        self.background = AnyView(
            LinearGradient(
                colors: [.blue, .purple, .pink, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
