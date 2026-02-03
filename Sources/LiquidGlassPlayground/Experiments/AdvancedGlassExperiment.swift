// AdvancedGlassExperiment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Advanced Glass Experiment

/// An experiment showcasing advanced glass techniques and pro features.
///
/// This experiment demonstrates sophisticated glass effects including
/// custom shaders, performance optimization, and complex compositions.
///
/// ## Features
/// - Complex compositions
/// - Performance tips
/// - Pro techniques
/// - Real-world examples
struct AdvancedGlassExperiment: View {
    
    // MARK: - Properties
    
    @Binding var parameters: GlassParameters
    @EnvironmentObject private var appState: AppState
    @State private var selectedTechnique: AdvancedTechnique = .composition
    @State private var showPerformanceMetrics = false
    @State private var compositionLayers: Int = 3
    @State private var enableBlending = true
    @State private var blendMode: BlendModeOption = .normal
    @State private var maskShape: MaskShapeOption = .none
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                advancedPreview
                
                techniqueSelector
                
                techniqueControls
                
                performanceSection
                
                realWorldExamples
            }
            .padding()
        }
        .navigationTitle("Advanced Glass")
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.red.gradient)
                
                VStack(alignment: .leading) {
                    Text("Advanced Glass Effects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Pro techniques & optimizations")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Master advanced glass techniques for production apps. Learn about composition, masking, blending modes, and performance optimization.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.glassEffect)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Advanced Preview
    
    private var advancedPreview: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Preview")
                    .font(.headline)
                
                Spacer()
                
                Toggle("Metrics", isOn: $showPerformanceMetrics)
                    .toggleStyle(.button)
            }
            
            ZStack {
                advancedBackground
                
                advancedGlassComposition
                
                if showPerformanceMetrics {
                    performanceOverlay
                }
            }
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var advancedBackground: some View {
        ZStack {
            LinearGradient(
                colors: [.red, .orange, .pink, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<12) { index in
                let angle = Double(index) * .pi / 6
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.4), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .offset(
                        x: cos(angle) * 120,
                        y: sin(angle) * 120
                    )
                    .blur(radius: 15)
            }
        }
    }
    
    @ViewBuilder
    private var advancedGlassComposition: some View {
        switch selectedTechnique {
        case .composition:
            compositionDemo
        case .masking:
            maskingDemo
        case .blending:
            blendingDemo
        case .layering:
            layeringDemo
        case .animation:
            animationDemo
        case .performance:
            performanceDemo
        }
    }
    
    // MARK: - Technique Demos
    
    private var compositionDemo: some View {
        ZStack {
            ForEach(0..<compositionLayers, id: \.self) { index in
                let offset = CGFloat(index) * 20
                let scale = 1 - CGFloat(index) * 0.1
                
                RoundedRectangle(cornerRadius: parameters.cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: parameters.cornerRadius)
                            .fill(parameters.tintColor.color.opacity(parameters.tintOpacity * Double(compositionLayers - index) / Double(compositionLayers)))
                    }
                    .overlay {
                        if index == compositionLayers - 1 {
                            VStack {
                                Text("Composition")
                                    .font(.headline)
                                Text("\(compositionLayers) layers")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: parameters.cornerRadius)
                            .strokeBorder(.white.opacity(0.3), lineWidth: 0.5)
                    }
                    .frame(width: 180, height: 140)
                    .scaleEffect(scale)
                    .offset(x: offset, y: -offset)
            }
        }
    }
    
    private var maskingDemo: some View {
        ZStack {
            RoundedRectangle(cornerRadius: parameters.cornerRadius)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: parameters.cornerRadius)
                        .fill(parameters.tintColor.color.opacity(parameters.tintOpacity))
                }
                .frame(width: 220, height: 180)
                .mask {
                    maskView
                }
            
            VStack {
                Text("Masking")
                    .font(.headline)
                Text(maskShape.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var maskView: some View {
        switch maskShape {
        case .none:
            Rectangle()
        case .circle:
            Circle()
                .frame(width: 180, height: 180)
        case .star:
            StarShape()
                .frame(width: 200, height: 200)
        case .text:
            Text("GLASS")
                .font(.system(size: 60, weight: .black))
        case .gradient:
            LinearGradient(
                colors: [.white, .clear],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var blendingDemo: some View {
        ZStack {
            Circle()
                .fill(.red.opacity(0.6))
                .frame(width: 120, height: 120)
                .offset(x: -40, y: -30)
            
            Circle()
                .fill(.blue.opacity(0.6))
                .frame(width: 120, height: 120)
                .offset(x: 40, y: -30)
            
            Circle()
                .fill(.green.opacity(0.6))
                .frame(width: 120, height: 120)
                .offset(y: 40)
            
            RoundedRectangle(cornerRadius: parameters.cornerRadius)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: parameters.cornerRadius)
                        .fill(parameters.tintColor.color.opacity(parameters.tintOpacity))
                }
                .frame(width: 160, height: 120)
                .blendMode(blendMode.mode)
                .overlay {
                    VStack {
                        Text("Blend Mode")
                            .font(.headline)
                        Text(blendMode.displayName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
        }
    }
    
    private var layeringDemo: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                let hue = Double(index) / 5
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hue: hue, saturation: 0.6, brightness: 0.8).opacity(0.3))
                    }
                    .frame(width: 100, height: 60)
                    .offset(y: CGFloat(index - 2) * 35)
                    .zIndex(Double(index))
            }
            
            VStack {
                Text("Z-Layering")
                    .font(.headline)
            }
            .offset(y: 100)
        }
    }
    
    private var animationDemo: some View {
        TimelineView(.animation(minimumInterval: 1/60)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let pulse = sin(time * 2) * 0.5 + 0.5
            
            RoundedRectangle(cornerRadius: parameters.cornerRadius)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: parameters.cornerRadius)
                        .fill(parameters.tintColor.color.opacity(parameters.tintOpacity * pulse))
                }
                .overlay {
                    VStack {
                        Text("60 FPS Animation")
                            .font(.headline)
                        Text("Using TimelineView")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: parameters.cornerRadius)
                        .strokeBorder(.white.opacity(0.3 + pulse * 0.3), lineWidth: 1)
                }
                .frame(width: 200, height: 150)
                .scaleEffect(1 + pulse * 0.05)
                .shadow(radius: 10 + pulse * 10)
        }
    }
    
    private var performanceDemo: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: parameters.cornerRadius)
                .fill(.ultraThinMaterial)
                .overlay {
                    VStack {
                        Text("Optimized Glass")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            MetricView(label: "Draw Calls", value: "1")
                            MetricView(label: "Overdraw", value: "Low")
                        }
                    }
                }
                .frame(width: 220, height: 140)
        }
    }
    
    private var performanceOverlay: some View {
        VStack {
            HStack {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("60 FPS")
                        .font(.caption.monospaced())
                    Text("GPU: 45%")
                        .font(.caption.monospaced())
                    Text("Memory: 12MB")
                        .font(.caption.monospaced())
                }
                .padding(8)
                .background(.black.opacity(0.6))
                .foregroundStyle(.green)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Technique Selector
    
    private var techniqueSelector: some View {
        VStack(spacing: 12) {
            Text("Technique")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(AdvancedTechnique.allCases) { technique in
                    TechniqueButton(
                        technique: technique,
                        isSelected: selectedTechnique == technique
                    ) {
                        withAnimation {
                            selectedTechnique = technique
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Technique Controls
    
    private var techniqueControls: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                switch selectedTechnique {
                case .composition:
                    compositionControls
                case .masking:
                    maskingControls
                case .blending:
                    blendingControls
                case .layering:
                    layeringControls
                case .animation:
                    animationControls
                case .performance:
                    performanceControls
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var compositionControls: some View {
        VStack(spacing: 12) {
            Stepper("Layers: \(compositionLayers)", value: $compositionLayers, in: 1...6)
            
            GlassSlider(
                value: $parameters.tintOpacity,
                range: 0...1,
                label: "Tint Opacity",
                format: "%.2f"
            )
            
            Text("Composition creates depth by stacking glass layers")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var maskingControls: some View {
        VStack(spacing: 12) {
            Picker("Mask Shape", selection: $maskShape) {
                ForEach(MaskShapeOption.allCases) { shape in
                    Text(shape.displayName).tag(shape)
                }
            }
            .pickerStyle(.segmented)
            
            Text("Masking clips glass effects to custom shapes")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var blendingControls: some View {
        VStack(spacing: 12) {
            Picker("Blend Mode", selection: $blendMode) {
                ForEach(BlendModeOption.allCases) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
            .pickerStyle(.menu)
            
            Text("Blend modes change how glass interacts with content below")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var layeringControls: some View {
        VStack(spacing: 12) {
            GlassSlider(
                value: $parameters.tintOpacity,
                range: 0...1,
                label: "Layer Opacity",
                format: "%.2f"
            )
            
            Text("Z-layering creates visual hierarchy with glass elements")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var animationControls: some View {
        VStack(spacing: 12) {
            GlassSlider(
                value: $parameters.animationDuration,
                range: 0.1...5,
                label: "Animation Speed",
                format: "%.1fs"
            )
            
            Text("TimelineView enables smooth, high-performance animations")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var performanceControls: some View {
        VStack(spacing: 12) {
            GlassToggle(
                isOn: $enableBlending,
                label: "Enable Blending"
            )
            
            Text("Optimize glass effects for smooth 60fps rendering")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Performance Section
    
    private var performanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Tips")
                .font(.headline)
            
            VStack(spacing: 12) {
                PerformanceTip(
                    title: "Reduce Blur Radius",
                    description: "Lower blur values improve rendering speed",
                    impact: "High"
                )
                
                PerformanceTip(
                    title: "Limit Layer Count",
                    description: "Fewer stacked materials means less overdraw",
                    impact: "High"
                )
                
                PerformanceTip(
                    title: "Use drawingGroup()",
                    description: "Rasterizes complex views into images",
                    impact: "Medium"
                )
                
                PerformanceTip(
                    title: "Avoid Overlapping Glass",
                    description: "Multiple overlapping glass views compound performance cost",
                    impact: "Medium"
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Real World Examples
    
    private var realWorldExamples: some View {
        VStack(spacing: 16) {
            Text("Real-World Applications")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ExampleCard(
                    title: "Navigation Bar",
                    description: "Scrolling content behind",
                    icon: "rectangle.topthird.inset.filled"
                )
                
                ExampleCard(
                    title: "Tab Bar",
                    description: "Always visible controls",
                    icon: "rectangle.bottomthird.inset.filled"
                )
                
                ExampleCard(
                    title: "Modal Sheets",
                    description: "Context-preserving overlays",
                    icon: "rectangle.inset.filled"
                )
                
                ExampleCard(
                    title: "Widgets",
                    description: "Home screen integration",
                    icon: "square.grid.2x2"
                )
            }
        }
    }
}

// MARK: - Advanced Technique

enum AdvancedTechnique: String, CaseIterable, Identifiable {
    case composition
    case masking
    case blending
    case layering
    case animation
    case performance
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var systemImage: String {
        switch self {
        case .composition: return "square.3.layers.3d"
        case .masking: return "theatermasks"
        case .blending: return "circle.hexagongrid"
        case .layering: return "square.stack"
        case .animation: return "play.circle"
        case .performance: return "speedometer"
        }
    }
}

// MARK: - Mask Shape Option

enum MaskShapeOption: String, CaseIterable, Identifiable {
    case none
    case circle
    case star
    case text
    case gradient
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .circle: return "Circle"
        case .star: return "Star"
        case .text: return "Text"
        case .gradient: return "Gradient"
        }
    }
}

// MARK: - Blend Mode Option

enum BlendModeOption: String, CaseIterable, Identifiable {
    case normal
    case multiply
    case screen
    case overlay
    case softLight
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .normal: return "Normal"
        case .multiply: return "Multiply"
        case .screen: return "Screen"
        case .overlay: return "Overlay"
        case .softLight: return "Soft Light"
        }
    }
    
    var mode: BlendMode {
        switch self {
        case .normal: return .normal
        case .multiply: return .multiply
        case .screen: return .screen
        case .overlay: return .overlay
        case .softLight: return .softLight
        }
    }
}

// MARK: - Star Shape

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius * 0.4
        let points = 5
        
        var path = Path()
        
        for i in 0..<points * 2 {
            let angle = Double(i) * .pi / Double(points) - .pi / 2
            let r = i % 2 == 0 ? radius : innerRadius
            let x = center.x + CGFloat(cos(angle)) * r
            let y = center.y + CGFloat(sin(angle)) * r
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Supporting Views

struct TechniqueButton: View {
    let technique: AdvancedTechnique
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: technique.systemImage)
                    .font(.title3)
                
                Text(technique.displayName)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.accentColor.opacity(0.2) : .clear)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

struct MetricView: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
                .foregroundStyle(.green)
            
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

struct PerformanceTip: View {
    let title: String
    let description: String
    let impact: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(impact)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(impact == "High" ? Color.green.opacity(0.2) : Color.yellow.opacity(0.2))
                .clipShape(Capsule())
        }
    }
}

struct ExampleCard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.red)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AdvancedGlassExperiment(parameters: .constant(GlassParameters()))
            .environmentObject(AppState())
    }
}
