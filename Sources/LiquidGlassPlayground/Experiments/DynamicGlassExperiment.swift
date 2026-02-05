// DynamicGlassExperiment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Dynamic Glass Experiment

/// An experiment demonstrating responsive, adaptive glass effects.
///
/// This experiment showcases how Liquid Glass can respond dynamically
/// to content, environment, and user interactions.
///
/// ## Features
/// - Content-aware blur intensity
/// - Adaptive tinting based on background
/// - Size-responsive effects
/// - Environment-sensitive styling
struct DynamicGlassExperiment: View {
    
    // MARK: - Properties
    
    @Binding var parameters: GlassParameters
    @EnvironmentObject private var appState: AppState
    @State private var containerSize: CGSize = .zero
    @State private var scrollOffset: CGFloat = 0
    @State private var contentOpacity: Double = 1.0
    @State private var isExpanded = false
    @State private var selectedMode: DynamicMode = .scroll
    @State private var motionOffset: CGSize = .zero
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                modeSelector
                
                dynamicPreview
                
                controlsSection
                
                adaptiveExamples
            }
            .padding()
        }
        .navigationTitle("Dynamic Glass")
        .onAppear {
            setupMotionTracking()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "waveform")
                    .font(.largeTitle)
                    .foregroundStyle(.purple.gradient)
                
                VStack(alignment: .leading) {
                    Text("Dynamic Glass Effects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Responsive and adaptive")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Create glass effects that respond to their environment. Watch how the glass adapts to scroll position, content, and device motion.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.glassEffect)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Mode Selector
    
    private var modeSelector: some View {
        VStack(spacing: 12) {
            Text("Dynamic Mode")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(DynamicMode.allCases) { mode in
                        DynamicModeButton(
                            mode: mode,
                            isSelected: selectedMode == mode
                        ) {
                            withAnimation {
                                selectedMode = mode
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Dynamic Preview
    
    private var dynamicPreview: some View {
        VStack(spacing: 16) {
            Text("Live Demo")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack {
                    dynamicBackground
                    
                    dynamicGlassElement
                        .offset(motionOffset)
                }
                .onAppear {
                    containerSize = geometry.size
                }
            }
            .frame(height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    /// The dynamic background that changes based on mode.
    private var dynamicBackground: some View {
        Group {
            switch selectedMode {
            case .scroll:
                ScrollDynamicBackground(offset: $scrollOffset)
            case .content:
                ContentDynamicBackground(opacity: $contentOpacity)
            case .motion:
                MotionDynamicBackground()
            case .size:
                SizeDynamicBackground(isExpanded: $isExpanded)
            case .colorScheme:
                ColorSchemeDynamicBackground(colorScheme: colorScheme)
            }
        }
    }
    
    /// The glass element that responds dynamically.
    private var dynamicGlassElement: some View {
        let dynamicBlur = computeDynamicBlur()
        let dynamicOpacity = computeDynamicOpacity()
        
        return RoundedRectangle(cornerRadius: parameters.cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: parameters.cornerRadius)
                    .fill(parameters.tintColor.color.opacity(dynamicOpacity))
            }
            .overlay {
                VStack {
                    Image(systemName: selectedMode.systemImage)
                        .font(.largeTitle)
                    
                    Text(selectedMode.displayName)
                        .font(.headline)
                    
                    Text("Blur: \(Int(dynamicBlur))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: parameters.cornerRadius)
                    .strokeBorder(
                        .linearGradient(
                            colors: [.white.opacity(0.5), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: parameters.borderWidth
                    )
            }
            .frame(width: isExpanded ? 280 : 200, height: isExpanded ? 220 : 160)
            .shadow(radius: parameters.shadowRadius)
            .animation(.spring(duration: 0.4), value: isExpanded)
    }
    
    /// Computes the blur radius based on the current dynamic mode.
    private func computeDynamicBlur() -> Double {
        switch selectedMode {
        case .scroll:
            return parameters.blurRadius + (scrollOffset * 0.1)
        case .content:
            return parameters.blurRadius * contentOpacity
        case .motion:
            let magnitude = sqrt(pow(motionOffset.width, 2) + pow(motionOffset.height, 2))
            return parameters.blurRadius + (magnitude * 0.2)
        case .size:
            return isExpanded ? parameters.blurRadius * 1.5 : parameters.blurRadius
        case .colorScheme:
            return colorScheme == .dark ? parameters.blurRadius * 1.2 : parameters.blurRadius
        }
    }
    
    /// Computes the tint opacity based on the current dynamic mode.
    private func computeDynamicOpacity() -> Double {
        switch selectedMode {
        case .scroll:
            return min(parameters.tintOpacity + (scrollOffset * 0.002), 0.8)
        case .content:
            return parameters.tintOpacity * (1 - contentOpacity * 0.5)
        case .motion:
            return parameters.tintOpacity
        case .size:
            return isExpanded ? parameters.tintOpacity * 0.7 : parameters.tintOpacity
        case .colorScheme:
            return colorScheme == .dark ? parameters.tintOpacity * 1.3 : parameters.tintOpacity
        }
    }
    
    // MARK: - Controls Section
    
    private var controlsSection: some View {
        VStack(spacing: 16) {
            Text("Interaction Controls")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                switch selectedMode {
                case .scroll:
                    scrollControls
                case .content:
                    contentControls
                case .motion:
                    motionControls
                case .size:
                    sizeControls
                case .colorScheme:
                    colorSchemeInfo
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var scrollControls: some View {
        VStack(spacing: 12) {
            Label("Scroll Offset", systemImage: "arrow.up.and.down")
                .font(.subheadline)
                .fontWeight(.medium)
            
            GlassSlider(
                value: $scrollOffset,
                range: 0...200,
                label: "Offset",
                format: "%.0f"
            )
            
            Text("Blur and tint increase as you scroll")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var contentControls: some View {
        VStack(spacing: 12) {
            Label("Content Visibility", systemImage: "eye")
                .font(.subheadline)
                .fontWeight(.medium)
            
            GlassSlider(
                value: $contentOpacity,
                range: 0...1,
                label: "Opacity",
                format: "%.2f"
            )
            
            Text("Glass adapts to content behind it")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var motionControls: some View {
        VStack(spacing: 12) {
            Label("Motion Offset", systemImage: "gyroscope")
                .font(.subheadline)
                .fontWeight(.medium)
            
            HStack {
                GlassSlider(
                    value: Binding(
                        get: { motionOffset.width },
                        set: { motionOffset.width = $0 }
                    ),
                    range: -50...50,
                    label: "X",
                    format: "%.0f"
                )
                
                GlassSlider(
                    value: Binding(
                        get: { motionOffset.height },
                        set: { motionOffset.height = $0 }
                    ),
                    range: -50...50,
                    label: "Y",
                    format: "%.0f"
                )
            }
            
            Text("Simulates device motion response")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var sizeControls: some View {
        VStack(spacing: 12) {
            Label("Size Mode", systemImage: "arrow.up.left.and.arrow.down.right")
                .font(.subheadline)
                .fontWeight(.medium)
            
            GlassToggle(
                isOn: $isExpanded,
                label: "Expanded"
            )
            
            Text("Glass effect adapts to container size")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var colorSchemeInfo: some View {
        VStack(spacing: 12) {
            Label("Color Scheme", systemImage: "circle.lefthalf.filled")
                .font(.subheadline)
                .fontWeight(.medium)
            
            HStack {
                Image(systemName: colorScheme == .light ? "sun.max.fill" : "moon.fill")
                    .foregroundStyle(colorScheme == .light ? .yellow : .purple)
                
                Text(colorScheme == .light ? "Light Mode" : "Dark Mode")
            }
            .font(.title3)
            
            Text("Toggle device appearance to see changes")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Adaptive Examples
    
    private var adaptiveExamples: some View {
        VStack(spacing: 16) {
            Text("Use Cases")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                UseCaseCard(
                    title: "Navigation Bar",
                    description: "Blur increases on scroll",
                    icon: "rectangle.topthird.inset.filled"
                )
                
                UseCaseCard(
                    title: "Modal Sheets",
                    description: "Adapts to content behind",
                    icon: "rectangle.bottomhalf.inset.filled"
                )
                
                UseCaseCard(
                    title: "Widgets",
                    description: "Responds to wallpaper",
                    icon: "square.grid.2x2"
                )
                
                UseCaseCard(
                    title: "Tab Bars",
                    description: "Context-aware styling",
                    icon: "rectangle.bottomthird.inset.filled"
                )
            }
        }
    }
    
    // MARK: - Methods
    
    private func setupMotionTracking() {
        // Motion tracking setup would go here
    }
}

// MARK: - Dynamic Mode

enum DynamicMode: String, CaseIterable, Identifiable {
    case scroll
    case content
    case motion
    case size
    case colorScheme
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .scroll: return "Scroll"
        case .content: return "Content"
        case .motion: return "Motion"
        case .size: return "Size"
        case .colorScheme: return "Theme"
        }
    }
    
    var systemImage: String {
        switch self {
        case .scroll: return "arrow.up.and.down"
        case .content: return "square.stack.3d.up"
        case .motion: return "gyroscope"
        case .size: return "arrow.up.left.and.arrow.down.right"
        case .colorScheme: return "circle.lefthalf.filled"
        }
    }
}

// MARK: - Dynamic Mode Button

struct DynamicModeButton: View {
    let mode: DynamicMode
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mode.systemImage)
                    .font(.title2)
                
                Text(mode.displayName)
                    .font(.caption)
            }
            .frame(width: 80, height: 70)
            .background(isSelected ? Color.accentColor.opacity(0.2) : .clear)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Dynamic Background Views

struct ScrollDynamicBackground: View {
    @Binding var offset: CGFloat
    
    var body: some View {
        LinearGradient(
            colors: [.purple.opacity(0.8), .blue.opacity(0.6)],
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay {
            VStack(spacing: 20) {
                ForEach(0..<10) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white.opacity(0.3))
                        .frame(height: 40)
                        .padding(.horizontal, 20)
                }
            }
            .offset(y: -offset)
        }
    }
}

struct ContentDynamicBackground: View {
    @Binding var opacity: Double
    
    var body: some View {
        ZStack {
            Color.indigo
            
            Image(systemName: "photo.artframe")
                .font(.system(size: 100))
                .foregroundStyle(.white.opacity(opacity))
        }
    }
}

struct MotionDynamicBackground: View {
    var body: some View {
        RadialGradient(
            colors: [.cyan, .blue, .purple],
            center: .center,
            startRadius: 0,
            endRadius: 200
        )
    }
}

struct SizeDynamicBackground: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        LinearGradient(
            colors: [.green, .teal],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay {
            Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                ForEach(0..<3) { row in
                    GridRow {
                        ForEach(0..<3) { col in
                            Circle()
                                .fill(.white.opacity(0.2))
                                .frame(width: isExpanded ? 60 : 40)
                        }
                    }
                }
            }
        }
    }
}

struct ColorSchemeDynamicBackground: View {
    let colorScheme: ColorScheme
    
    var body: some View {
        Group {
            if colorScheme == .light {
                LinearGradient(
                    colors: [.orange, .yellow],
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                LinearGradient(
                    colors: [.indigo, .purple],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
    }
}

// MARK: - Use Case Card

struct UseCaseCard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(.purple)
            
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
        DynamicGlassExperiment(parameters: .constant(GlassParameters()))
            .environmentObject(AppState())
    }
}
