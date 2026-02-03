// GlassColorPicker.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Glass Color Picker

/// A custom color picker component with Liquid Glass styling.
///
/// This color picker provides an elegant interface for selecting colors
/// with support for presets, custom colors, and opacity adjustment.
///
/// ## Usage
/// ```swift
/// @State private var color: Color = .blue
///
/// GlassColorPicker(
///     selection: $color,
///     label: "Tint Color"
/// )
/// ```
struct GlassColorPicker: View {
    
    // MARK: - Properties
    
    @Binding var selection: Color
    let label: String
    var showOpacity: Bool = true
    var presetColors: [Color]? = nil
    
    @State private var opacity: Double = 1.0
    @State private var showFullPicker = false
    
    private let defaultPresets: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal,
        .cyan, .blue, .indigo, .purple, .pink, .brown
    ]
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerRow
            
            presetColorsGrid
            
            if showOpacity {
                opacitySlider
            }
        }
    }
    
    // MARK: - Header Row
    
    private var headerRow: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            ColorPicker("", selection: $selection)
                .labelsHidden()
            
            selectedColorPreview
        }
    }
    
    // MARK: - Selected Color Preview
    
    private var selectedColorPreview: some View {
        Circle()
            .fill(selection)
            .frame(width: 28, height: 28)
            .overlay {
                Circle()
                    .strokeBorder(.white.opacity(0.3), lineWidth: 1)
            }
            .shadow(color: selection.opacity(0.3), radius: 4)
    }
    
    // MARK: - Preset Colors Grid
    
    private var presetColorsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 8) {
            ForEach(presetColors ?? defaultPresets, id: \.self) { color in
                PresetColorButton(
                    color: color,
                    isSelected: selection == color
                ) {
                    selection = color
                    UISelectionFeedbackGenerator().selectionChanged()
                }
            }
        }
    }
    
    // MARK: - Opacity Slider
    
    private var opacitySlider: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Opacity")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(String(format: "%.0f%%", opacity * 100))
                    .font(.caption.monospacedDigit())
            }
            
            OpacitySlider(opacity: $opacity, color: selection)
                .frame(height: 24)
                .onChange(of: opacity) { _, newValue in
                    selection = selection.opacity(newValue)
                }
        }
    }
}

// MARK: - Preset Color Button

/// A button for selecting a preset color.
struct PresetColorButton: View {
    
    let color: Color
    let isSelected: Bool
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
                .overlay {
                    if isSelected {
                        Circle()
                            .strokeBorder(.white, lineWidth: 2)
                        
                        Image(systemName: "checkmark")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                    }
                }
                .shadow(color: color.opacity(0.3), radius: 3)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Opacity Slider

/// A slider specifically designed for opacity selection.
struct OpacitySlider: View {
    
    @Binding var opacity: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                checkerboardBackground
                    .frame(height: 12)
                    .clipShape(Capsule())
                
                opacityGradient
                    .frame(height: 12)
                    .clipShape(Capsule())
                
                thumb
                    .position(
                        x: geometry.size.width * CGFloat(opacity),
                        y: geometry.size.height / 2
                    )
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let newOpacity = gesture.location.x / geometry.size.width
                        opacity = max(0, min(1, newOpacity))
                    }
            )
        }
    }
    
    private var checkerboardBackground: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let squareSize: CGFloat = 6
                var isLight = true
                
                for y in stride(from: 0, through: size.height, by: squareSize) {
                    for x in stride(from: 0, through: size.width, by: squareSize) {
                        let rect = CGRect(x: x, y: y, width: squareSize, height: squareSize)
                        context.fill(
                            Path(rect),
                            with: .color(isLight ? .white : .gray.opacity(0.3))
                        )
                        isLight.toggle()
                    }
                    isLight.toggle()
                }
            }
        }
    }
    
    private var opacityGradient: some View {
        LinearGradient(
            colors: [color.opacity(0), color],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var thumb: some View {
        Circle()
            .fill(.white)
            .frame(width: 20, height: 20)
            .overlay {
                Circle()
                    .fill(color.opacity(opacity))
                    .padding(3)
            }
            .overlay {
                Circle()
                    .strokeBorder(.white, lineWidth: 2)
            }
            .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
    }
}

// MARK: - Hue Saturation Picker

/// A 2D picker for selecting hue and saturation.
struct HueSaturationPicker: View {
    
    @Binding var hue: Double
    @Binding var saturation: Double
    let brightness: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                hueGradient
                
                saturationOverlay
                
                selectionIndicator
                    .position(
                        x: geometry.size.width * CGFloat(hue),
                        y: geometry.size.height * CGFloat(1 - saturation)
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        hue = max(0, min(1, gesture.location.x / geometry.size.width))
                        saturation = max(0, min(1, 1 - gesture.location.y / geometry.size.height))
                    }
            )
        }
    }
    
    private var hueGradient: some View {
        LinearGradient(
            colors: (0...10).map { Color(hue: Double($0) / 10, saturation: 1, brightness: brightness) },
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var saturationOverlay: some View {
        LinearGradient(
            colors: [.white, .clear],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var selectionIndicator: some View {
        Circle()
            .fill(Color(hue: hue, saturation: saturation, brightness: brightness))
            .frame(width: 24, height: 24)
            .overlay {
                Circle()
                    .strokeBorder(.white, lineWidth: 3)
            }
            .shadow(color: .black.opacity(0.3), radius: 3)
    }
}

// MARK: - Color Well

/// A compact color well for quick color selection.
struct GlassColorWell: View {
    
    @Binding var color: Color
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            
            Spacer()
            
            ColorPicker("", selection: $color)
                .labelsHidden()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Gradient Color Picker

/// A picker for creating gradient colors.
struct GlassGradientPicker: View {
    
    @Binding var colors: [Color]
    let label: String
    let maxColors: Int
    
    init(colors: Binding<[Color]>, label: String, maxColors: Int = 5) {
        self._colors = colors
        self.label = label
        self.maxColors = maxColors
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            gradientPreview
            
            colorStops
            
            actionButtons
        }
    }
    
    private var gradientPreview: some View {
        LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
            .frame(height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
            }
    }
    
    private var colorStops: some View {
        HStack(spacing: 8) {
            ForEach(colors.indices, id: \.self) { index in
                ColorPicker("", selection: $colors[index])
                    .labelsHidden()
                    .overlay {
                        if colors.count > 2 {
                            Button {
                                colors.remove(at: index)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.white, .red)
                            }
                            .offset(x: 12, y: -12)
                        }
                    }
            }
        }
    }
    
    private var actionButtons: some View {
        HStack {
            Button {
                if colors.count < maxColors {
                    colors.append(.white)
                }
            } label: {
                Label("Add Stop", systemImage: "plus")
            }
            .disabled(colors.count >= maxColors)
            .font(.caption)
            
            Spacer()
            
            Button("Reverse") {
                colors.reverse()
            }
            .font(.caption)
        }
    }
}

// MARK: - Preview

#Preview("Glass Color Picker") {
    VStack(spacing: 30) {
        GlassColorPicker(
            selection: .constant(.blue),
            label: "Tint Color"
        )
        
        GlassColorWell(
            color: .constant(.purple),
            label: "Border Color"
        )
        
        GlassGradientPicker(
            colors: .constant([.blue, .purple, .pink]),
            label: "Gradient Colors"
        )
    }
    .padding()
}
