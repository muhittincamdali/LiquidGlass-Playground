// AnimatedGlassExperiment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Animated Glass Experiment

/// An experiment showcasing animated glass effects.
///
/// This experiment demonstrates how to add smooth, engaging animations
/// to Liquid Glass effects for dynamic user interfaces.
///
/// ## Features
/// - Smooth parameter transitions
/// - Keyframe animations
/// - Auto-reversing loops
/// - Timing curve control
struct AnimatedGlassExperiment: View {
    
    // MARK: - Properties
    
    @Binding var parameters: GlassParameters
    @EnvironmentObject private var appState: AppState
    @State private var isAnimating = false
    @State private var animationPhase: CGFloat = 0
    @State private var selectedAnimation: AnimationType = .pulse
    @State private var animationSpeed: Double = 1.0
    @State private var showTimingCurves = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                animationPreview
                
                animationSelector
                
                animationControls
                
                timingCurvesSection
                
                presetAnimations
            }
            .padding()
        }
        .navigationTitle("Animated Glass")
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.orange.gradient)
                
                VStack(alignment: .leading) {
                    Text("Animated Glass Effects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Bring glass to life")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Add smooth, delightful animations to your glass effects. Control timing curves, duration, and create complex animation sequences.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.glassEffect)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Animation Preview
    
    private var animationPreview: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Preview")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    toggleAnimation()
                } label: {
                    Label(
                        isAnimating ? "Stop" : "Play",
                        systemImage: isAnimating ? "stop.fill" : "play.fill"
                    )
                }
                .buttonStyle(.borderedProminent)
            }
            
            ZStack {
                animatedBackground
                
                animatedGlassElement
            }
            .frame(height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var animatedBackground: some View {
        ZStack {
            LinearGradient(
                colors: [.orange, .pink, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<8) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.5), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .offset(
                        x: CGFloat.random(in: -120...120),
                        y: CGFloat.random(in: -150...150)
                    )
                    .blur(radius: 15)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        .linear(duration: Double(index + 5))
                        .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
        }
    }
    
    private var animatedGlassElement: some View {
        let animation = selectedAnimation.animation(
            duration: parameters.animationDuration * animationSpeed,
            phase: animationPhase
        )
        
        return RoundedRectangle(cornerRadius: animatedCornerRadius)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: animatedCornerRadius)
                    .fill(parameters.tintColor.color.opacity(animatedOpacity))
            }
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: selectedAnimation.systemImage)
                        .font(.largeTitle)
                        .rotationEffect(.degrees(animatedRotation))
                    
                    Text(selectedAnimation.displayName)
                        .font(.headline)
                    
                    Text(isAnimating ? "Animating..." : "Tap Play")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: animatedCornerRadius)
                    .strokeBorder(
                        .linearGradient(
                            colors: [.white.opacity(0.6), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: parameters.borderWidth
                    )
            }
            .frame(width: animatedWidth, height: animatedHeight)
            .scaleEffect(animatedScale)
            .offset(y: animatedOffset)
            .shadow(radius: animatedShadow)
            .animation(animation, value: animationPhase)
    }
    
    // MARK: - Animated Values
    
    private var animatedScale: CGFloat {
        switch selectedAnimation {
        case .pulse: return 1 + (animationPhase * 0.1)
        case .breathe: return 1 + (sin(animationPhase * .pi) * 0.08)
        case .bounce: return 1
        case .shake: return 1
        case .morph: return 1
        case .glow: return 1
        case .wave: return 1
        case .spin: return 1
        }
    }
    
    private var animatedOffset: CGFloat {
        switch selectedAnimation {
        case .bounce: return -animationPhase * 20
        case .shake: return sin(animationPhase * .pi * 4) * 5
        case .wave: return sin(animationPhase * .pi * 2) * 15
        default: return 0
        }
    }
    
    private var animatedRotation: Double {
        switch selectedAnimation {
        case .spin: return animationPhase * 360
        case .shake: return sin(animationPhase * .pi * 4) * 5
        default: return 0
        }
    }
    
    private var animatedOpacity: Double {
        switch selectedAnimation {
        case .glow: return parameters.tintOpacity + (sin(animationPhase * .pi) * 0.3)
        case .breathe: return parameters.tintOpacity + (sin(animationPhase * .pi) * 0.2)
        default: return parameters.tintOpacity
        }
    }
    
    private var animatedCornerRadius: Double {
        switch selectedAnimation {
        case .morph: return parameters.cornerRadius + (animationPhase * 30)
        default: return parameters.cornerRadius
        }
    }
    
    private var animatedWidth: CGFloat {
        switch selectedAnimation {
        case .morph: return 200 + (animationPhase * 40)
        default: return 200
        }
    }
    
    private var animatedHeight: CGFloat {
        switch selectedAnimation {
        case .morph: return 160 - (animationPhase * 30)
        default: return 160
        }
    }
    
    private var animatedShadow: CGFloat {
        switch selectedAnimation {
        case .glow: return parameters.shadowRadius + (sin(animationPhase * .pi) * 15)
        default: return parameters.shadowRadius
        }
    }
    
    // MARK: - Animation Selector
    
    private var animationSelector: some View {
        VStack(spacing: 12) {
            Text("Animation Type")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(AnimationType.allCases) { animation in
                    AnimationTypeButton(
                        animation: animation,
                        isSelected: selectedAnimation == animation
                    ) {
                        withAnimation {
                            selectedAnimation = animation
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Animation Controls
    
    private var animationControls: some View {
        VStack(spacing: 16) {
            Text("Controls")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                GlassSlider(
                    value: $parameters.animationDuration,
                    range: 0.1...5,
                    label: "Duration",
                    format: "%.1fs"
                )
                
                GlassSlider(
                    value: $animationSpeed,
                    range: 0.25...4,
                    label: "Speed Multiplier",
                    format: "%.2fx"
                )
                
                Picker("Timing Curve", selection: $parameters.animationCurve) {
                    ForEach(AnimationCurve.allCases) { curve in
                        Text(curve.displayName).tag(curve)
                    }
                }
                .pickerStyle(.segmented)
                
                HStack {
                    GlassToggle(
                        isOn: $parameters.loopAnimation,
                        label: "Loop"
                    )
                    
                    GlassToggle(
                        isOn: $parameters.autoReverseAnimation,
                        label: "Auto-Reverse"
                    )
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Timing Curves Section
    
    private var timingCurvesSection: some View {
        VStack(spacing: 12) {
            Button {
                showTimingCurves.toggle()
            } label: {
                HStack {
                    Text("Timing Curves Guide")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: showTimingCurves ? "chevron.up" : "chevron.down")
                }
            }
            .buttonStyle(.plain)
            
            if showTimingCurves {
                VStack(spacing: 16) {
                    ForEach(AnimationCurve.allCases) { curve in
                        TimingCurveRow(curve: curve)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Preset Animations
    
    private var presetAnimations: some View {
        VStack(spacing: 16) {
            Text("Quick Presets")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                PresetAnimationCard(
                    title: "Subtle Pulse",
                    description: "Gentle breathing effect",
                    icon: "heart.fill"
                ) {
                    applyPreset(.subtlePulse)
                }
                
                PresetAnimationCard(
                    title: "Energetic Bounce",
                    description: "Playful bouncing motion",
                    icon: "arrow.up.arrow.down"
                ) {
                    applyPreset(.energeticBounce)
                }
                
                PresetAnimationCard(
                    title: "Smooth Morph",
                    description: "Shape transformation",
                    icon: "wand.and.stars"
                ) {
                    applyPreset(.smoothMorph)
                }
                
                PresetAnimationCard(
                    title: "Glowing Aura",
                    description: "Pulsing glow effect",
                    icon: "sparkle"
                ) {
                    applyPreset(.glowingAura)
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func toggleAnimation() {
        isAnimating.toggle()
        
        if isAnimating {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
    
    private func startAnimation() {
        withAnimation(
            .linear(duration: parameters.animationDuration * animationSpeed)
            .repeatForever(autoreverses: parameters.autoReverseAnimation)
        ) {
            animationPhase = 1
        }
    }
    
    private func stopAnimation() {
        withAnimation(.easeOut(duration: 0.3)) {
            animationPhase = 0
        }
    }
    
    private func applyPreset(_ preset: AnimationPreset) {
        withAnimation {
            switch preset {
            case .subtlePulse:
                selectedAnimation = .pulse
                parameters.animationDuration = 2.0
                parameters.animationCurve = .easeInOut
                animationSpeed = 1.0
            case .energeticBounce:
                selectedAnimation = .bounce
                parameters.animationDuration = 0.5
                parameters.animationCurve = .spring
                animationSpeed = 1.5
            case .smoothMorph:
                selectedAnimation = .morph
                parameters.animationDuration = 3.0
                parameters.animationCurve = .easeInOut
                animationSpeed = 0.8
            case .glowingAura:
                selectedAnimation = .glow
                parameters.animationDuration = 1.5
                parameters.animationCurve = .easeInOut
                animationSpeed = 1.0
            }
        }
        
        if !isAnimating {
            toggleAnimation()
        }
    }
}

// MARK: - Animation Type

enum AnimationType: String, CaseIterable, Identifiable {
    case pulse
    case breathe
    case bounce
    case shake
    case morph
    case glow
    case wave
    case spin
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var systemImage: String {
        switch self {
        case .pulse: return "heart.fill"
        case .breathe: return "wind"
        case .bounce: return "arrow.up.arrow.down"
        case .shake: return "waveform.path"
        case .morph: return "wand.and.stars"
        case .glow: return "sparkle"
        case .wave: return "water.waves"
        case .spin: return "arrow.triangle.2.circlepath"
        }
    }
    
    func animation(duration: Double, phase: CGFloat) -> Animation {
        switch self {
        case .pulse, .breathe, .glow:
            return .easeInOut(duration: duration)
        case .bounce:
            return .spring(duration: duration, bounce: 0.5)
        case .shake, .wave:
            return .linear(duration: duration)
        case .morph:
            return .easeInOut(duration: duration)
        case .spin:
            return .linear(duration: duration)
        }
    }
}

// MARK: - Animation Preset

enum AnimationPreset {
    case subtlePulse
    case energeticBounce
    case smoothMorph
    case glowingAura
}

// MARK: - Animation Type Button

struct AnimationTypeButton: View {
    let animation: AnimationType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: animation.systemImage)
                    .font(.title3)
                
                Text(animation.displayName)
                    .font(.caption2)
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

// MARK: - Timing Curve Row

struct TimingCurveRow: View {
    let curve: AnimationCurve
    
    var body: some View {
        HStack(spacing: 12) {
            TimingCurveGraph(curve: curve)
                .frame(width: 60, height: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(curve.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(curveDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
    
    private var curveDescription: String {
        switch curve {
        case .linear: return "Constant speed throughout"
        case .easeIn: return "Starts slow, accelerates"
        case .easeOut: return "Starts fast, decelerates"
        case .easeInOut: return "Slow start and end"
        case .spring: return "Natural bouncy motion"
        }
    }
}

// MARK: - Timing Curve Graph

struct TimingCurveGraph: View {
    let curve: AnimationCurve
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: geometry.size.height))
                
                for x in stride(from: 0, through: geometry.size.width, by: 2) {
                    let t = x / geometry.size.width
                    let y = geometry.size.height * (1 - curveValue(t))
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(Color.accentColor, lineWidth: 2)
        }
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    private func curveValue(_ t: Double) -> Double {
        switch curve {
        case .linear: return t
        case .easeIn: return t * t
        case .easeOut: return 1 - pow(1 - t, 2)
        case .easeInOut: return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
        case .spring: return 1 - cos(t * .pi / 2)
        }
    }
}

// MARK: - Preset Animation Card

struct PresetAnimationCard: View {
    let title: String
    let description: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.orange)
                
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
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AnimatedGlassExperiment(parameters: .constant(GlassParameters()))
            .environmentObject(AppState())
    }
}
