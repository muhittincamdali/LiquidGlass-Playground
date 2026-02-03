import SwiftUI

// MARK: - PreviewPanel

/// Displays a live preview of the current glass configuration.
///
/// The panel shows the glass effect overlaid on a vibrant sample background,
/// updating in real-time as parameters change.
public struct PreviewPanel: View {
    /// The current glass configuration to preview.
    private let configuration: GlassConfiguration

    /// Creates a preview panel for the given configuration.
    /// - Parameter configuration: The glass parameters to visualize.
    public init(configuration: GlassConfiguration) {
        self.configuration = configuration
    }

    public var body: some View {
        ZStack {
            backgroundContent
            glassOverlay
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 1)
        }
    }

    /// The sample background behind the glass.
    private var backgroundContent: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple, .pink, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 12) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 48))
                    .foregroundStyle(.white.opacity(0.6))

                Text("Sample Content")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(.white.opacity(0.8))

                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(.white.opacity(0.2))
                            .frame(width: 60, height: 8)
                    }
                }
            }
        }
    }

    /// The glass effect overlay with all current parameters applied.
    private var glassOverlay: some View {
        GlassEffectPlayground(configuration: configuration) {
            Color.clear
        }
    }
}
