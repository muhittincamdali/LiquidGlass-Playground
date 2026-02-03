// GlassSlider.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Glass Slider

/// A custom slider component with Liquid Glass styling.
///
/// This slider provides a beautiful glass-styled appearance that matches
/// iOS 26's design language while offering enhanced customization options.
///
/// ## Usage
/// ```swift
/// @State private var value: Double = 0.5
///
/// GlassSlider(
///     value: $value,
///     range: 0...1,
///     label: "Opacity",
///     format: "%.2f"
/// )
/// ```
///
/// ## Features
/// - Glass-styled track and thumb
/// - Optional value label
/// - Custom formatting
/// - Haptic feedback
struct GlassSlider: View {
    
    // MARK: - Properties
    
    /// The current value of the slider.
    @Binding var value: Double
    
    /// The range of valid values.
    let range: ClosedRange<Double>
    
    /// The label displayed above the slider.
    let label: String
    
    /// The format string for displaying the value.
    let format: String
    
    /// Whether to show the value label.
    var showValue: Bool = true
    
    /// The step increment for the slider.
    var step: Double? = nil
    
    /// The accent color for the filled portion.
    var accentColor: Color = .accentColor
    
    /// Whether to provide haptic feedback on value changes.
    var hapticsEnabled: Bool = true
    
    /// Callback when the value changes.
    var onValueChanged: ((Double) -> Void)? = nil
    
    // MARK: - State
    
    @State private var isDragging = false
    @State private var lastHapticValue: Double = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    // MARK: - Constants
    
    private let trackHeight: CGFloat = 6
    private let thumbSize: CGFloat = 24
    private let hapticStep: Double = 0.1
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            labelRow
            
            sliderTrack
        }
    }
    
    // MARK: - Label Row
    
    private var labelRow: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            if showValue {
                Text(String(format: format, value))
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
                    .animation(.snappy, value: value)
            }
        }
    }
    
    // MARK: - Slider Track
    
    private var sliderTrack: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width
            let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            let thumbPosition = trackWidth * CGFloat(progress)
            
            ZStack(alignment: .leading) {
                backgroundTrack
                
                filledTrack(width: thumbPosition)
                
                thumbView
                    .position(x: thumbPosition, y: geometry.size.height / 2)
            }
            .frame(height: thumbSize)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gestureValue in
                        handleDragChange(gestureValue, in: trackWidth)
                    }
                    .onEnded { _ in
                        handleDragEnd()
                    }
            )
        }
        .frame(height: thumbSize)
    }
    
    // MARK: - Background Track
    
    private var backgroundTrack: some View {
        Capsule()
            .fill(.ultraThinMaterial)
            .frame(height: trackHeight)
            .overlay {
                Capsule()
                    .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
            }
    }
    
    // MARK: - Filled Track
    
    private func filledTrack(width: CGFloat) -> some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [accentColor.opacity(0.8), accentColor],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: max(trackHeight, width), height: trackHeight)
    }
    
    // MARK: - Thumb View
    
    private var thumbView: some View {
        Circle()
            .fill(.white)
            .frame(width: thumbSize, height: thumbSize)
            .overlay {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white, .white.opacity(0.8)],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: thumbSize
                        )
                    )
            }
            .overlay {
                Circle()
                    .strokeBorder(.white.opacity(0.5), lineWidth: 0.5)
            }
            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
            .scaleEffect(isDragging ? 1.15 : 1.0)
            .animation(.spring(duration: 0.2), value: isDragging)
    }
    
    // MARK: - Gesture Handling
    
    private func handleDragChange(_ gesture: DragGesture.Value, in trackWidth: CGFloat) {
        isDragging = true
        
        let newProgress = gesture.location.x / trackWidth
        let clampedProgress = max(0, min(1, newProgress))
        
        var newValue = range.lowerBound + Double(clampedProgress) * (range.upperBound - range.lowerBound)
        
        if let step = step {
            newValue = round(newValue / step) * step
        }
        
        newValue = max(range.lowerBound, min(range.upperBound, newValue))
        
        if newValue != value {
            value = newValue
            onValueChanged?(newValue)
            
            provideHapticFeedback()
        }
    }
    
    private func handleDragEnd() {
        isDragging = false
    }
    
    private func provideHapticFeedback() {
        guard hapticsEnabled else { return }
        
        let stepDifference = abs(value - lastHapticValue)
        if stepDifference >= hapticStep * (range.upperBound - range.lowerBound) {
            UISelectionFeedbackGenerator().selectionChanged()
            lastHapticValue = value
        }
    }
}

// MARK: - Glass Slider Variants

extension GlassSlider {
    
    /// Creates a slider with integer steps.
    static func integer(
        value: Binding<Double>,
        range: ClosedRange<Int>,
        label: String
    ) -> GlassSlider {
        GlassSlider(
            value: value,
            range: Double(range.lowerBound)...Double(range.upperBound),
            label: label,
            format: "%.0f",
            step: 1
        )
    }
    
    /// Creates a slider for percentage values.
    static func percentage(
        value: Binding<Double>,
        label: String
    ) -> GlassSlider {
        GlassSlider(
            value: value,
            range: 0...1,
            label: label,
            format: "%.0f%%"
        )
    }
    
    /// Creates a slider for angle values.
    static func angle(
        value: Binding<Double>,
        label: String
    ) -> GlassSlider {
        GlassSlider(
            value: value,
            range: 0...360,
            label: label,
            format: "%.0f°",
            step: 1
        )
    }
}

// MARK: - Vertical Glass Slider

/// A vertical variant of the glass slider.
struct VerticalGlassSlider: View {
    
    @Binding var value: Double
    let range: ClosedRange<Double>
    let label: String
    let format: String
    
    @State private var isDragging = false
    
    private let trackWidth: CGFloat = 6
    private let thumbSize: CGFloat = 24
    
    var body: some View {
        VStack(spacing: 8) {
            Text(String(format: format, value))
                .font(.caption.monospacedDigit())
            
            GeometryReader { geometry in
                let trackHeight = geometry.size.height
                let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
                let thumbPosition = trackHeight * CGFloat(1 - progress)
                
                ZStack(alignment: .bottom) {
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .frame(width: trackWidth)
                    
                    Capsule()
                        .fill(Color.accentColor)
                        .frame(width: trackWidth, height: trackHeight * CGFloat(progress))
                    
                    Circle()
                        .fill(.white)
                        .frame(width: thumbSize, height: thumbSize)
                        .shadow(radius: 4, y: 2)
                        .position(x: geometry.size.width / 2, y: thumbPosition)
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            let newProgress = 1 - (gesture.location.y / trackHeight)
                            let clampedProgress = max(0, min(1, newProgress))
                            value = range.lowerBound + Double(clampedProgress) * (range.upperBound - range.lowerBound)
                        }
                )
            }
            .frame(width: thumbSize)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Range Glass Slider

/// A slider for selecting a range of values.
struct RangeGlassSlider: View {
    
    @Binding var lowerValue: Double
    @Binding var upperValue: Double
    let range: ClosedRange<Double>
    let label: String
    
    @State private var isDraggingLower = false
    @State private var isDraggingUpper = false
    
    private let trackHeight: CGFloat = 6
    private let thumbSize: CGFloat = 24
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(Int(lowerValue)) - \(Int(upperValue))")
                    .font(.subheadline.monospacedDigit())
            }
            
            GeometryReader { geometry in
                let trackWidth = geometry.size.width
                let lowerProgress = (lowerValue - range.lowerBound) / (range.upperBound - range.lowerBound)
                let upperProgress = (upperValue - range.lowerBound) / (range.upperBound - range.lowerBound)
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .frame(height: trackHeight)
                    
                    Capsule()
                        .fill(Color.accentColor)
                        .frame(
                            width: trackWidth * CGFloat(upperProgress - lowerProgress),
                            height: trackHeight
                        )
                        .offset(x: trackWidth * CGFloat(lowerProgress))
                    
                    Circle()
                        .fill(.white)
                        .frame(width: thumbSize, height: thumbSize)
                        .shadow(radius: 4, y: 2)
                        .position(x: trackWidth * CGFloat(lowerProgress), y: geometry.size.height / 2)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    let progress = gesture.location.x / trackWidth
                                    let newValue = range.lowerBound + Double(progress) * (range.upperBound - range.lowerBound)
                                    lowerValue = max(range.lowerBound, min(upperValue - 1, newValue))
                                }
                        )
                    
                    Circle()
                        .fill(.white)
                        .frame(width: thumbSize, height: thumbSize)
                        .shadow(radius: 4, y: 2)
                        .position(x: trackWidth * CGFloat(upperProgress), y: geometry.size.height / 2)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    let progress = gesture.location.x / trackWidth
                                    let newValue = range.lowerBound + Double(progress) * (range.upperBound - range.lowerBound)
                                    upperValue = max(lowerValue + 1, min(range.upperBound, newValue))
                                }
                        )
                }
            }
            .frame(height: thumbSize)
        }
    }
}

// MARK: - Preview

#Preview("Glass Slider") {
    VStack(spacing: 30) {
        GlassSlider(
            value: .constant(25),
            range: 0...50,
            label: "Blur Radius",
            format: "%.0f"
        )
        
        GlassSlider(
            value: .constant(0.5),
            range: 0...1,
            label: "Opacity",
            format: "%.2f"
        )
        
        GlassSlider.angle(
            value: .constant(45),
            label: "Angle"
        )
    }
    .padding()
}

#Preview("Range Slider") {
    RangeGlassSlider(
        lowerValue: .constant(20),
        upperValue: .constant(80),
        range: 0...100,
        label: "Range"
    )
    .padding()
}
