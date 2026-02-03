import SwiftUI

// MARK: - PlaygroundView

/// The main container view for the Liquid Glass playground.
///
/// Combines the preview panel, control panel, and preset selector
/// into a unified interactive experience.
///
/// ```swift
/// PlaygroundView()
/// ```
public struct PlaygroundView: View {
    /// The playground engine managing all state.
    @State private var engine = PlaygroundEngine()
    /// Whether the code export sheet is presented.
    @State private var showingExport = false
    /// The currently selected blur style for the blur demo.
    @State private var selectedBlurStyle: BlurStyle = .gaussian

    public init() {}

    public var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                if geometry.size.width > 700 {
                    landscapeLayout
                } else {
                    portraitLayout
                }
            }
            .navigationTitle("Liquid Glass Playground")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        engine.reset()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .disabled(!engine.canUndo)
                }

                ToolbarItem(placement: .automatic) {
                    Button {
                        showingExport = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showingExport) {
                exportSheet
            }
        }
    }

    // MARK: - Layouts

    /// Side-by-side layout for wider screens.
    private var landscapeLayout: some View {
        HStack(spacing: 0) {
            PreviewPanel(configuration: engine.configuration)
                .frame(maxWidth: .infinity)

            Divider()

            ScrollView {
                VStack(spacing: 20) {
                    ControlPanel(configuration: $engine.configuration)
                    presetGrid
                }
                .padding()
            }
            .frame(width: 320)
        }
    }

    /// Stacked layout for compact screens.
    private var portraitLayout: some View {
        ScrollView {
            VStack(spacing: 20) {
                PreviewPanel(configuration: engine.configuration)
                    .frame(height: 300)

                ControlPanel(configuration: $engine.configuration)

                presetGrid
            }
            .padding()
        }
    }

    // MARK: - Subviews

    /// Grid of preset buttons.
    private var presetGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Presets")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 8) {
                ForEach(PresetLibrary.shared.presets) { preset in
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            engine.load(preset: preset)
                        }
                    } label: {
                        Text(preset.name)
                            .font(.caption)
                            .fontWeight(engine.activePresetName == preset.name ? .bold : .regular)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(engine.activePresetName == preset.name ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.1))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    /// Code export sheet.
    private var exportSheet: some View {
        NavigationStack {
            ScrollView {
                let exporter = CodeExporter()
                let code = exporter.export(engine.configuration)

                Text(code)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
            }
            .navigationTitle("Exported Code")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { showingExport = false }
                }
            }
        }
    }
}
