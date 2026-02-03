import Foundation

// MARK: - CodeExporter

/// Generates production-ready SwiftUI code from a glass configuration.
///
/// ```swift
/// let exporter = CodeExporter()
/// let code = exporter.export(engine.configuration)
/// ```
public struct CodeExporter: Sendable {
    /// The indentation style for exported code.
    public enum IndentStyle: Sendable {
        case spaces(Int)
        case tabs
    }

    /// Indentation preference.
    private let indentStyle: IndentStyle

    /// Creates a code exporter.
    /// - Parameter indentStyle: The indentation style to use. Defaults to 4 spaces.
    public init(indentStyle: IndentStyle = .spaces(4)) {
        self.indentStyle = indentStyle
    }

    /// Exports a glass configuration as SwiftUI modifier code.
    /// - Parameter configuration: The configuration to export.
    /// - Returns: A string containing valid SwiftUI code.
    public func export(_ configuration: GlassConfiguration) -> String {
        let indent = indentString

        var lines: [String] = []
        lines.append("// Liquid Glass Effect")
        lines.append("// Export from LiquidGlass-Playground")
        lines.append("")
        lines.append("RoundedRectangle(cornerRadius: \(formatted(configuration.cornerRadius)), style: .continuous)")
        lines.append("\(indent).fill(.ultraThinMaterial)")
        lines.append("\(indent).overlay {")
        lines.append("\(indent)\(indent)RoundedRectangle(cornerRadius: \(formatted(configuration.cornerRadius)), style: .continuous)")

        let tint = configuration.tintColor
        lines.append("\(indent)\(indent)\(indent).fill(Color(red: \(formatted(tint.red)), green: \(formatted(tint.green)), blue: \(formatted(tint.blue))).opacity(\(formatted(configuration.tintOpacity))))")
        lines.append("\(indent)}")

        if configuration.borderWidth > 0 {
            lines.append("\(indent).overlay {")
            lines.append("\(indent)\(indent)RoundedRectangle(cornerRadius: \(formatted(configuration.cornerRadius)), style: .continuous)")
            lines.append("\(indent)\(indent)\(indent).strokeBorder(.white.opacity(\(formatted(configuration.borderOpacity))), lineWidth: \(formatted(configuration.borderWidth)))")
            lines.append("\(indent)}")
        }

        lines.append("\(indent).saturation(\(formatted(configuration.saturation)))")
        lines.append("\(indent).brightness(\(formatted(configuration.brightness)))")
        lines.append("\(indent).shadow(color: .black.opacity(0.2), radius: \(formatted(configuration.shadowRadius)), x: 0, y: \(formatted(configuration.shadowRadius / 3)))")

        return lines.joined(separator: "\n")
    }

    /// Exports a full SwiftUI view wrapping the configuration.
    /// - Parameters:
    ///   - configuration: The configuration to export.
    ///   - viewName: The name of the generated view struct.
    /// - Returns: A complete SwiftUI view file as a string.
    public func exportView(_ configuration: GlassConfiguration, viewName: String = "GlassCard") -> String {
        let indent = indentString
        var lines: [String] = []
        lines.append("import SwiftUI")
        lines.append("")
        lines.append("struct \(viewName): View {")
        lines.append("\(indent)var body: some View {")
        lines.append("\(indent)\(indent)\(export(configuration).replacingOccurrences(of: "\n", with: "\n\(indent)\(indent)"))")
        lines.append("\(indent)}")
        lines.append("}")
        return lines.joined(separator: "\n")
    }

    // MARK: - Private Helpers

    private var indentString: String {
        switch indentStyle {
        case .spaces(let count):
            return String(repeating: " ", count: count)
        case .tabs:
            return "\t"
        }
    }

    private func formatted(_ value: CGFloat) -> String {
        let double = Double(value)
        if double == double.rounded() {
            return String(format: "%.0f", double)
        }
        return String(format: "%.2f", double)
    }

    private func formatted(_ value: Double) -> String {
        if value == value.rounded() {
            return String(format: "%.0f", value)
        }
        return String(format: "%.2f", value)
    }
}
