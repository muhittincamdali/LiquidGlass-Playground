import SwiftUI

// MARK: - ControlPanel

/// A panel of sliders and toggles for adjusting glass configuration parameters.
///
/// Binds directly to a `GlassConfiguration` and updates values in real-time.
public struct ControlPanel: View {
    /// Binding to the glass configuration being edited.
    @Binding public var configuration: GlassConfiguration

    /// Creates a control panel bound to a configuration.
    /// - Parameter configuration: A binding to the glass configuration.
    public init(configuration: Binding<GlassConfiguration>) {
        self._configuration = configuration
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Parameters")
                .font(.headline)

            parameterSlider(
                label: "Blur Radius", icon: "aqi.medium",
                value: $configuration.blurRadius, range: 0...50
            )
            parameterSlider(
                label: "Refraction", icon: "light.recessed",
                value: $configuration.refractionIndex, range: 0...1
            )
            parameterSlider(
                label: "Tint Opacity", icon: "drop.halffull",
                value: $configuration.tintOpacity, range: 0...1
            )
            parameterSlider(
                label: "Corner Radius", icon: "square.on.square",
                value: $configuration.cornerRadius, range: 0...40
            )
            parameterSlider(
                label: "Saturation", icon: "paintpalette",
                value: $configuration.saturation, range: 0...2
            )
            parameterSlider(
                label: "Brightness", icon: "sun.max",
                value: $configuration.brightness, range: -0.5...0.5
            )
            parameterSlider(
                label: "Shadow", icon: "shadow",
                value: $configuration.shadowRadius, range: 0...30
            )
            parameterSlider(
                label: "Border Width", icon: "square.dashed",
                value: $configuration.borderWidth, range: 0...4
            )
            parameterSlider(
                label: "Border Opacity", icon: "circle.dotted",
                value: $configuration.borderOpacity, range: 0...1
            )
        }
    }

    // MARK: - Slider Builder

    /// Creates a labeled slider row with an icon and formatted value display.
    @ViewBuilder
    private func parameterSlider<V: BinaryFloatingPoint>(
        label: String,
        icon: String,
        value: Binding<V>,
        range: ClosedRange<V>
    ) -> some View where V.Stride: BinaryFloatingPoint {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                Text(label)
                    .font(.subheadline)
                Spacer()
                Text(String(format: "%.2f", Double(value.wrappedValue)))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            Slider(value: value, in: range)
                .tint(.accentColor)
        }
    }
}
