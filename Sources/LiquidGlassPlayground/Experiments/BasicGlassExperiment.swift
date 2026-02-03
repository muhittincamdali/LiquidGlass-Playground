// BasicGlassExperiment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Basic Glass Experiment

/// An experiment showcasing fundamental Liquid Glass effects.
///
/// This experiment provides a comprehensive introduction to iOS 26's glass
/// effects, demonstrating blur, materials, and basic styling options.
///
/// ## Overview
/// The Basic Glass Experiment covers:
/// - Material backgrounds
/// - Blur radius control
/// - Tint colors
/// - Border styling
/// - Corner radius
///
/// ## Example
/// ```swift
/// BasicGlassExperiment(parameters: $parameters)
/// ```
struct BasicGlassExperiment: View {
    
    // MARK: - Properties
    
    /// The binding to the glass parameters being edited.
    @Binding var parameters: GlassParameters
    
    /// The current state of the experiment.
    @State private var experimentState = BasicExperimentState()
    
    /// Environment object for app-wide state.
    @EnvironmentObject private var appState: AppState
    
    /// The namespace for matched geometry effects.
    @Namespace private var namespace
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                previewSection
                
                controlsSection
                
                examplesSection
                
                tipsSection
            }
            .padding()
        }
        .navigationTitle("Basic Glass")
    }
    
    // MARK: - Header Section
    
    /// The header section with experiment description.
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "square.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.blue.gradient)
                
                VStack(alignment: .leading) {
                    Text("Basic Glass Effects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Learn the fundamentals")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Start your journey into Liquid Glass by mastering the core concepts. These fundamental techniques form the foundation for all advanced effects.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.glassEffect)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Preview Section
    
    /// The main preview section showing the glass effect.
    private var previewSection: some View {
        VStack(spacing: 16) {
            Text("Live Preview")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                backgroundView
                
                glassPreview
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    /// The background view for the preview.
    private var backgroundView: some View {
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay {
            GeometryReader { geometry in
                ForEach(0..<5) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.white.opacity(0.6), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 60
                            )
                        )
                        .frame(width: 120, height: 120)
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
        }
    }
    
    /// The glass effect preview element.
    private var glassPreview: some View {
        RoundedRectangle(cornerRadius: parameters.cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: parameters.cornerRadius)
                    .fill(parameters.swiftUITintColor)
            }
            .overlay {
                if parameters.showSpecularHighlight {
                    specularHighlight
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: parameters.cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.5),
                                .white.opacity(0.1),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: parameters.borderWidth
                    )
            }
            .shadow(
                color: parameters.showShadow ? .black.opacity(0.2) : .clear,
                radius: parameters.shadowRadius,
                x: parameters.shadowOffsetX,
                y: parameters.shadowOffsetY
            )
            .frame(width: 200, height: 200)
            .matchedGeometryEffect(id: "glass", in: namespace)
    }
    
    /// The specular highlight overlay.
    private var specularHighlight: some View {
        GeometryReader { geometry in
            let angle = Angle(degrees: parameters.lightAngle)
            let radius = min(geometry.size.width, geometry.size.height) * parameters.specularSize
            
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            .white.opacity(parameters.lightIntensity),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: radius * parameters.specularSoftness
                    )
                )
                .frame(width: radius, height: radius * 0.5)
                .rotationEffect(angle)
                .position(
                    x: geometry.size.width * 0.3,
                    y: geometry.size.height * 0.3
                )
        }
    }
    
    // MARK: - Controls Section
    
    /// The controls section with parameter sliders.
    private var controlsSection: some View {
        VStack(spacing: 16) {
            Text("Parameters")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                blurControls
                
                Divider()
                
                tintControls
                
                Divider()
                
                shapeControls
                
                Divider()
                
                shadowControls
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    /// Blur-related controls.
    private var blurControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Blur", systemImage: "drop.fill")
                .font(.subheadline)
                .fontWeight(.medium)
            
            GlassSlider(
                value: $parameters.blurRadius,
                range: 0...50,
                label: "Radius",
                format: "%.0f"
            )
            
            Picker("Style", selection: $parameters.blurStyle) {
                ForEach(BlurStyle.allCases) { style in
                    Text(style.displayName).tag(style)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    /// Tint-related controls.
    private var tintControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Tint", systemImage: "paintbrush.fill")
                .font(.subheadline)
                .fontWeight(.medium)
            
            HStack {
                ColorPicker("Color", selection: Binding(
                    get: { parameters.tintColor.color },
                    set: { parameters.tintColor = CodableColor($0) }
                ))
                
                Spacer()
            }
            
            GlassSlider(
                value: $parameters.tintOpacity,
                range: 0...1,
                label: "Opacity",
                format: "%.2f"
            )
        }
    }
    
    /// Shape-related controls.
    private var shapeControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Shape", systemImage: "square.on.circle")
                .font(.subheadline)
                .fontWeight(.medium)
            
            GlassSlider(
                value: $parameters.cornerRadius,
                range: 0...50,
                label: "Corner Radius",
                format: "%.0f"
            )
            
            GlassSlider(
                value: $parameters.borderWidth,
                range: 0...10,
                label: "Border Width",
                format: "%.1f"
            )
        }
    }
    
    /// Shadow-related controls.
    private var shadowControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Shadow", systemImage: "shadow")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Toggle("", isOn: $parameters.showShadow)
                    .labelsHidden()
            }
            
            if parameters.showShadow {
                GlassSlider(
                    value: $parameters.shadowRadius,
                    range: 0...30,
                    label: "Radius",
                    format: "%.0f"
                )
                
                GlassSlider(
                    value: $parameters.shadowOffsetY,
                    range: -20...20,
                    label: "Offset Y",
                    format: "%.0f"
                )
            }
        }
    }
    
    // MARK: - Examples Section
    
    /// The examples section showing preset variations.
    private var examplesSection: some View {
        VStack(spacing: 16) {
            Text("Quick Examples")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(BasicExamplePreset.allCases) { preset in
                    ExampleCard(preset: preset) {
                        applyPreset(preset)
                    }
                }
            }
        }
    }
    
    /// The tips section with helpful information.
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Tips", systemImage: "lightbulb.fill")
                .font(.headline)
                .foregroundStyle(.yellow)
            
            VStack(alignment: .leading, spacing: 8) {
                TipRow(text: "Use subtle blur (10-20) for readable content")
                TipRow(text: "Keep tint opacity low (0.1-0.3) for elegance")
                TipRow(text: "Match corner radius with your app's design language")
                TipRow(text: "Soft shadows add depth without being distracting")
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Methods
    
    /// Applies a preset configuration to the parameters.
    private func applyPreset(_ preset: BasicExamplePreset) {
        withAnimation(PlaygroundConfiguration.shared.defaultAnimation) {
            switch preset {
            case .subtle:
                parameters.blurRadius = 10
                parameters.tintOpacity = 0.1
                parameters.cornerRadius = 12
                parameters.borderWidth = 0.5
            case .prominent:
                parameters.blurRadius = 25
                parameters.tintOpacity = 0.3
                parameters.cornerRadius = 20
                parameters.borderWidth = 1
            case .frosted:
                parameters.blurRadius = 40
                parameters.tintOpacity = 0.15
                parameters.cornerRadius = 16
                parameters.borderWidth = 0
            case .modern:
                parameters.blurRadius = 20
                parameters.tintOpacity = 0.05
                parameters.cornerRadius = 24
                parameters.borderWidth = 0.5
            }
        }
        
        appState.provideHapticFeedback(.selection)
    }
}

// MARK: - Basic Experiment State

/// The internal state for the basic glass experiment.
struct BasicExperimentState {
    var selectedExample: BasicExamplePreset?
    var showAdvancedOptions = false
}

// MARK: - Basic Example Preset

/// Preset configurations for the basic glass experiment.
enum BasicExamplePreset: String, CaseIterable, Identifiable {
    case subtle
    case prominent
    case frosted
    case modern
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var description: String {
        switch self {
        case .subtle: return "Light and elegant"
        case .prominent: return "Bold and visible"
        case .frosted: return "Heavy blur effect"
        case .modern: return "Clean and minimal"
        }
    }
    
    var systemImage: String {
        switch self {
        case .subtle: return "sparkle"
        case .prominent: return "square.fill"
        case .frosted: return "snowflake"
        case .modern: return "rectangle.fill"
        }
    }
}

// MARK: - Example Card

/// A card view for displaying an example preset.
struct ExampleCard: View {
    let preset: BasicExamplePreset
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: preset.systemImage)
                    .font(.title)
                    .foregroundStyle(.blue)
                
                Text(preset.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(preset.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Tip Row

/// A row view for displaying a tip.
struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "arrow.right.circle.fill")
                .foregroundStyle(.blue)
                .font(.caption)
            
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        BasicGlassExperiment(parameters: .constant(GlassParameters()))
            .environmentObject(AppState())
    }
}
