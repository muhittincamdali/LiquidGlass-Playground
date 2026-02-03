// ColorfulGlassExperiment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Colorful Glass Experiment

/// An experiment exploring color tints and gradients in glass effects.
///
/// This experiment demonstrates the rich color possibilities available
/// with Liquid Glass, including tints, gradients, and blend modes.
///
/// ## Features
/// - Solid color tints
/// - Gradient overlays
/// - Color harmony suggestions
/// - Blend mode exploration
struct ColorfulGlassExperiment: View {
    
    // MARK: - Properties
    
    @Binding var parameters: GlassParameters
    @EnvironmentObject private var appState: AppState
    @State private var selectedColorMode: ColorMode = .solid
    @State private var colorHarmony: ColorHarmony = .complementary
    @State private var baseColor: Color = .blue
    @State private var gradientColors: [Color] = [.blue, .purple]
    @State private var gradientType: GradientType = .linear
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                colorPreview
                
                colorModeSelector
                
                colorControls
                
                harmonySection
                
                colorPalettes
            }
            .padding()
        }
        .navigationTitle("Colorful Glass")
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "paintpalette.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.pink.gradient)
                
                VStack(alignment: .leading) {
                    Text("Colorful Glass Effects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Explore color possibilities")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Add personality to your glass effects with rich colors, gradients, and harmonious color schemes.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.glassEffect)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Color Preview
    
    private var colorPreview: some View {
        VStack(spacing: 16) {
            Text("Live Preview")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                backgroundPattern
                
                colorfulGlassElement
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var backgroundPattern: some View {
        ZStack {
            LinearGradient(
                colors: [.gray.opacity(0.8), .gray.opacity(0.4)],
                startPoint: .top,
                endPoint: .bottom
            )
            
            GeometryReader { geometry in
                Path { path in
                    let step: CGFloat = 20
                    for x in stride(from: 0, through: geometry.size.width, by: step) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                    }
                    for y in stride(from: 0, through: geometry.size.height, by: step) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                }
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
            }
            
            ForEach(0..<5) { index in
                Circle()
                    .fill(
                        [Color.red, .orange, .yellow, .green, .blue][index]
                            .opacity(0.7)
                    )
                    .frame(width: 80, height: 80)
                    .offset(
                        x: CGFloat([-80, 60, -40, 80, 0][index]),
                        y: CGFloat([-60, -30, 50, 20, -80][index])
                    )
                    .blur(radius: 20)
            }
        }
    }
    
    private var colorfulGlassElement: some View {
        RoundedRectangle(cornerRadius: parameters.cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: parameters.cornerRadius)
                    .fill(colorOverlay)
            }
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: "paintpalette")
                        .font(.largeTitle)
                    
                    Text(selectedColorMode.displayName)
                        .font(.headline)
                    
                    Text(colorDescription)
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
            .frame(width: 200, height: 180)
            .shadow(radius: parameters.shadowRadius)
    }
    
    @ViewBuilder
    private var colorOverlay: some ShapeStyle {
        switch selectedColorMode {
        case .solid:
            parameters.tintColor.color.opacity(parameters.tintOpacity)
        case .gradient:
            linearGradient
        case .radial:
            radialGradient
        case .angular:
            angularGradient
        }
    }
    
    private var linearGradient: LinearGradient {
        LinearGradient(
            colors: gradientColors.map { $0.opacity(parameters.tintOpacity) },
            startPoint: gradientStartPoint,
            endPoint: gradientEndPoint
        )
    }
    
    private var radialGradient: RadialGradient {
        RadialGradient(
            colors: gradientColors.map { $0.opacity(parameters.tintOpacity) },
            center: .center,
            startRadius: 0,
            endRadius: 150
        )
    }
    
    private var angularGradient: AngularGradient {
        AngularGradient(
            colors: gradientColors.map { $0.opacity(parameters.tintOpacity) },
            center: .center,
            angle: .degrees(parameters.gradientAngle)
        )
    }
    
    private var gradientStartPoint: UnitPoint {
        let angle = parameters.gradientAngle
        switch angle {
        case 0..<45: return .top
        case 45..<135: return .leading
        case 135..<225: return .bottom
        case 225..<315: return .trailing
        default: return .top
        }
    }
    
    private var gradientEndPoint: UnitPoint {
        let angle = parameters.gradientAngle
        switch angle {
        case 0..<45: return .bottom
        case 45..<135: return .trailing
        case 135..<225: return .top
        case 225..<315: return .leading
        default: return .bottom
        }
    }
    
    private var colorDescription: String {
        switch selectedColorMode {
        case .solid: return "Solid color tint"
        case .gradient: return "Linear gradient"
        case .radial: return "Radial gradient"
        case .angular: return "Angular gradient"
        }
    }
    
    // MARK: - Color Mode Selector
    
    private var colorModeSelector: some View {
        VStack(spacing: 12) {
            Text("Color Mode")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Picker("Mode", selection: $selectedColorMode) {
                ForEach(ColorMode.allCases) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    // MARK: - Color Controls
    
    private var colorControls: some View {
        VStack(spacing: 16) {
            Text("Color Settings")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                if selectedColorMode == .solid {
                    solidColorControls
                } else {
                    gradientColorControls
                }
                
                GlassSlider(
                    value: $parameters.tintOpacity,
                    range: 0...1,
                    label: "Opacity",
                    format: "%.2f"
                )
                
                if selectedColorMode != .solid {
                    GlassSlider(
                        value: $parameters.gradientAngle,
                        range: 0...360,
                        label: "Angle",
                        format: "%.0f°"
                    )
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var solidColorControls: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Tint Color")
                    .font(.subheadline)
                
                Spacer()
                
                ColorPicker("", selection: Binding(
                    get: { parameters.tintColor.color },
                    set: { parameters.tintColor = CodableColor($0) }
                ))
                .labelsHidden()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(quickColors, id: \.self) { color in
                        QuickColorButton(color: color) {
                            parameters.tintColor = CodableColor(color)
                        }
                    }
                }
            }
        }
    }
    
    private var gradientColorControls: some View {
        VStack(spacing: 12) {
            ForEach(gradientColors.indices, id: \.self) { index in
                HStack {
                    Text("Color \(index + 1)")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    ColorPicker("", selection: $gradientColors[index])
                        .labelsHidden()
                }
            }
            
            HStack {
                Button {
                    if gradientColors.count < 5 {
                        gradientColors.append(.white)
                    }
                } label: {
                    Label("Add Color", systemImage: "plus.circle")
                }
                .disabled(gradientColors.count >= 5)
                
                Spacer()
                
                Button {
                    if gradientColors.count > 2 {
                        gradientColors.removeLast()
                    }
                } label: {
                    Label("Remove", systemImage: "minus.circle")
                }
                .disabled(gradientColors.count <= 2)
            }
            .font(.caption)
        }
    }
    
    private var quickColors: [Color] {
        [.red, .orange, .yellow, .green, .mint, .cyan, .blue, .indigo, .purple, .pink]
    }
    
    // MARK: - Harmony Section
    
    private var harmonySection: some View {
        VStack(spacing: 16) {
            Text("Color Harmony")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                HStack {
                    Text("Base Color")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    ColorPicker("", selection: $baseColor)
                        .labelsHidden()
                }
                
                Picker("Harmony", selection: $colorHarmony) {
                    ForEach(ColorHarmony.allCases) { harmony in
                        Text(harmony.displayName).tag(harmony)
                    }
                }
                .pickerStyle(.menu)
                
                HStack(spacing: 8) {
                    ForEach(harmonyColors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                            .frame(height: 40)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                            }
                            .onTapGesture {
                                parameters.tintColor = CodableColor(color)
                            }
                    }
                }
                
                Button("Apply Harmony") {
                    applyHarmony()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var harmonyColors: [Color] {
        colorHarmony.colors(for: baseColor)
    }
    
    // MARK: - Color Palettes
    
    private var colorPalettes: some View {
        VStack(spacing: 16) {
            Text("Curated Palettes")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                ForEach(ColorPalette.allCases) { palette in
                    PaletteRow(palette: palette) {
                        applyPalette(palette)
                    }
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func applyHarmony() {
        gradientColors = harmonyColors
        selectedColorMode = .gradient
    }
    
    private func applyPalette(_ palette: ColorPalette) {
        gradientColors = palette.colors
        selectedColorMode = .gradient
    }
}

// MARK: - Color Mode

enum ColorMode: String, CaseIterable, Identifiable {
    case solid
    case gradient
    case radial
    case angular
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .solid: return "Solid"
        case .gradient: return "Linear"
        case .radial: return "Radial"
        case .angular: return "Angular"
        }
    }
}

// MARK: - Gradient Type

enum GradientType: String, CaseIterable, Identifiable {
    case linear
    case radial
    case angular
    
    var id: String { rawValue }
}

// MARK: - Color Harmony

enum ColorHarmony: String, CaseIterable, Identifiable {
    case complementary
    case triadic
    case analogous
    case splitComplementary
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .complementary: return "Complementary"
        case .triadic: return "Triadic"
        case .analogous: return "Analogous"
        case .splitComplementary: return "Split Complementary"
        }
    }
    
    func colors(for base: Color) -> [Color] {
        let hue = base.hue
        
        switch self {
        case .complementary:
            return [base, Color(hue: (hue + 0.5).truncatingRemainder(dividingBy: 1), saturation: 0.7, brightness: 0.8)]
        case .triadic:
            return [
                base,
                Color(hue: (hue + 0.333).truncatingRemainder(dividingBy: 1), saturation: 0.7, brightness: 0.8),
                Color(hue: (hue + 0.666).truncatingRemainder(dividingBy: 1), saturation: 0.7, brightness: 0.8)
            ]
        case .analogous:
            return [
                Color(hue: (hue - 0.083).truncatingRemainder(dividingBy: 1), saturation: 0.7, brightness: 0.8),
                base,
                Color(hue: (hue + 0.083).truncatingRemainder(dividingBy: 1), saturation: 0.7, brightness: 0.8)
            ]
        case .splitComplementary:
            return [
                base,
                Color(hue: (hue + 0.416).truncatingRemainder(dividingBy: 1), saturation: 0.7, brightness: 0.8),
                Color(hue: (hue + 0.583).truncatingRemainder(dividingBy: 1), saturation: 0.7, brightness: 0.8)
            ]
        }
    }
}

// MARK: - Color Extension

extension Color {
    var hue: Double {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(self).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Double(h)
    }
}

// MARK: - Color Palette

enum ColorPalette: String, CaseIterable, Identifiable {
    case ocean
    case sunset
    case forest
    case candy
    case midnight
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var colors: [Color] {
        switch self {
        case .ocean: return [.cyan, .blue, .indigo]
        case .sunset: return [.orange, .pink, .purple]
        case .forest: return [.green, .mint, .teal]
        case .candy: return [.pink, .purple, .blue]
        case .midnight: return [.indigo, .purple, .blue]
        }
    }
}

// MARK: - Quick Color Button

struct QuickColorButton: View {
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 32, height: 32)
                .overlay {
                    Circle()
                        .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                }
        }
    }
}

// MARK: - Palette Row

struct PaletteRow: View {
    let palette: ColorPalette
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(palette.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(palette.colors.indices, id: \.self) { index in
                        Circle()
                            .fill(palette.colors[index])
                            .frame(width: 24, height: 24)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ColorfulGlassExperiment(parameters: .constant(GlassParameters()))
            .environmentObject(AppState())
    }
}
