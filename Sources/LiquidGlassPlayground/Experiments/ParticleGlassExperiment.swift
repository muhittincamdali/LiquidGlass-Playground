// ParticleGlassExperiment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Particle Glass Experiment

/// An experiment combining particle systems with glass effects.
///
/// This experiment demonstrates how to create stunning visual effects
/// by combining particle animations with Liquid Glass.
///
/// ## Features
/// - Particle emission
/// - Field interactions
/// - Glass integration
/// - Custom particle behaviors
struct ParticleGlassExperiment: View {
    
    // MARK: - Properties
    
    @Binding var parameters: GlassParameters
    @EnvironmentObject private var appState: AppState
    @State private var selectedEffect: ParticleEffect = .sparkle
    @State private var particles: [Particle] = []
    @State private var isEmitting = false
    @State private var emissionRate: Double = 20
    @State private var particleLifetime: Double = 2.0
    @State private var particleSize: Double = 8
    @State private var particleSpeed: Double = 50
    @State private var timer: Timer?
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                particlePreview
                
                effectSelector
                
                particleControls
                
                presetEffects
            }
            .padding()
        }
        .navigationTitle("Particle Glass")
        .onDisappear {
            stopEmission()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.largeTitle)
                    .foregroundStyle(.yellow.gradient)
                
                VStack(alignment: .leading) {
                    Text("Particle Glass Effects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Magical particle systems")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Combine beautiful particle effects with glass for stunning visual experiences. Create sparkles, snow, bubbles, and more.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.glassEffect)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Particle Preview
    
    private var particlePreview: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Preview")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    toggleEmission()
                } label: {
                    Label(
                        isEmitting ? "Stop" : "Start",
                        systemImage: isEmitting ? "stop.fill" : "play.fill"
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Clear") {
                    particles.removeAll()
                }
                .buttonStyle(.bordered)
            }
            
            GeometryReader { geometry in
                ZStack {
                    particleBackground
                    
                    particleLayer(in: geometry)
                    
                    glassElement
                }
                .contentShape(Rectangle())
                .onTapGesture { location in
                    emitBurst(at: location, in: geometry)
                }
            }
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var particleBackground: some View {
        ZStack {
            LinearGradient(
                colors: selectedEffect.backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<6) { index in
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .offset(
                        x: CGFloat.random(in: -120...120),
                        y: CGFloat.random(in: -160...160)
                    )
                    .blur(radius: 25)
            }
        }
    }
    
    private func particleLayer(in geometry: GeometryProxy) -> some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for particle in particles {
                    let age = timeline.date.timeIntervalSince(particle.birthTime)
                    let progress = age / particle.lifetime
                    
                    guard progress < 1 else { continue }
                    
                    let opacity = selectedEffect.opacityCurve(progress)
                    let scale = selectedEffect.scaleCurve(progress)
                    
                    var position = particle.position
                    position.x += particle.velocity.x * CGFloat(age)
                    position.y += particle.velocity.y * CGFloat(age)
                    
                    if selectedEffect == .snow || selectedEffect == .rain {
                        position.y += 50 * CGFloat(age)
                    }
                    
                    if selectedEffect == .bubble {
                        position.y -= 30 * CGFloat(age)
                        position.x += sin(CGFloat(age) * 3) * 10
                    }
                    
                    context.opacity = opacity
                    
                    let rect = CGRect(
                        x: position.x - particle.size * scale / 2,
                        y: position.y - particle.size * scale / 2,
                        width: particle.size * scale,
                        height: particle.size * scale
                    )
                    
                    drawParticle(
                        context: &context,
                        rect: rect,
                        color: particle.color,
                        effect: selectedEffect
                    )
                }
            }
        }
        .onChange(of: timer) { _, _ in
            cleanupParticles()
        }
    }
    
    private func drawParticle(
        context: inout GraphicsContext,
        rect: CGRect,
        color: Color,
        effect: ParticleEffect
    ) {
        switch effect {
        case .sparkle:
            context.fill(
                Path(ellipseIn: rect),
                with: .color(color)
            )
            context.addFilter(.blur(radius: 2))
        case .snow:
            context.fill(
                Path(ellipseIn: rect),
                with: .color(.white)
            )
        case .rain:
            let path = Path { p in
                p.move(to: CGPoint(x: rect.midX, y: rect.minY))
                p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            }
            context.stroke(path, with: .color(.cyan.opacity(0.7)), lineWidth: 2)
        case .bubble:
            context.stroke(
                Path(ellipseIn: rect),
                with: .color(.white.opacity(0.5)),
                lineWidth: 1
            )
            let highlightRect = CGRect(
                x: rect.minX + rect.width * 0.3,
                y: rect.minY + rect.height * 0.2,
                width: rect.width * 0.2,
                height: rect.height * 0.2
            )
            context.fill(
                Path(ellipseIn: highlightRect),
                with: .color(.white.opacity(0.6))
            )
        case .fire:
            context.fill(
                Path(ellipseIn: rect),
                with: .color(color)
            )
            context.addFilter(.blur(radius: 3))
        case .confetti:
            let rotatedRect = rect.insetBy(dx: -2, dy: 2)
            context.fill(
                Path(CGRect(x: rotatedRect.minX, y: rotatedRect.minY, width: 8, height: 4)),
                with: .color(color)
            )
        case .dust:
            context.fill(
                Path(ellipseIn: rect),
                with: .color(.white.opacity(0.3))
            )
        case .magic:
            context.fill(
                Path(ellipseIn: rect),
                with: .color(color)
            )
            context.addFilter(.blur(radius: 4))
        }
    }
    
    private var glassElement: some View {
        RoundedRectangle(cornerRadius: parameters.cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: parameters.cornerRadius)
                    .fill(parameters.tintColor.color.opacity(parameters.tintOpacity))
            }
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: selectedEffect.systemImage)
                        .font(.largeTitle)
                    
                    Text(selectedEffect.displayName)
                        .font(.headline)
                    
                    Text("Tap to emit particles")
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
            .frame(width: 180, height: 150)
            .shadow(radius: parameters.shadowRadius)
    }
    
    // MARK: - Effect Selector
    
    private var effectSelector: some View {
        VStack(spacing: 12) {
            Text("Particle Effect")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(ParticleEffect.allCases) { effect in
                    EffectButton(
                        effect: effect,
                        isSelected: selectedEffect == effect
                    ) {
                        withAnimation {
                            selectedEffect = effect
                            particles.removeAll()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Particle Controls
    
    private var particleControls: some View {
        VStack(spacing: 16) {
            Text("Particle Settings")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                GlassSlider(
                    value: $emissionRate,
                    range: 5...100,
                    label: "Emission Rate",
                    format: "%.0f/s"
                )
                
                GlassSlider(
                    value: $particleLifetime,
                    range: 0.5...5,
                    label: "Lifetime",
                    format: "%.1fs"
                )
                
                GlassSlider(
                    value: $particleSize,
                    range: 2...20,
                    label: "Size",
                    format: "%.0f"
                )
                
                GlassSlider(
                    value: $particleSpeed,
                    range: 10...200,
                    label: "Speed",
                    format: "%.0f"
                )
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Preset Effects
    
    private var presetEffects: some View {
        VStack(spacing: 16) {
            Text("Quick Presets")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                PresetButton(
                    title: "Gentle Sparkle",
                    description: "Soft, floating particles",
                    icon: "sparkle"
                ) {
                    applyPreset(.gentleSparkle)
                }
                
                PresetButton(
                    title: "Blizzard",
                    description: "Heavy snow effect",
                    icon: "snowflake"
                ) {
                    applyPreset(.blizzard)
                }
                
                PresetButton(
                    title: "Celebration",
                    description: "Confetti explosion",
                    icon: "party.popper"
                ) {
                    applyPreset(.celebration)
                }
                
                PresetButton(
                    title: "Magical Aura",
                    description: "Mystical particles",
                    icon: "wand.and.stars"
                ) {
                    applyPreset(.magicalAura)
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func toggleEmission() {
        if isEmitting {
            stopEmission()
        } else {
            startEmission()
        }
    }
    
    private func startEmission() {
        isEmitting = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / emissionRate, repeats: true) { _ in
            emitParticle()
        }
    }
    
    private func stopEmission() {
        isEmitting = false
        timer?.invalidate()
        timer = nil
    }
    
    private func emitParticle() {
        let particle = Particle(
            position: CGPoint(
                x: CGFloat.random(in: 50...330),
                y: CGFloat.random(in: 50...350)
            ),
            velocity: CGPoint(
                x: CGFloat.random(in: -particleSpeed...particleSpeed),
                y: CGFloat.random(in: -particleSpeed...particleSpeed)
            ),
            size: CGFloat(particleSize + Double.random(in: -2...2)),
            color: selectedEffect.particleColor,
            lifetime: particleLifetime + Double.random(in: -0.5...0.5),
            birthTime: Date()
        )
        
        particles.append(particle)
    }
    
    private func emitBurst(at location: CGPoint, in geometry: GeometryProxy) {
        for _ in 0..<20 {
            let angle = Double.random(in: 0...(2 * .pi))
            let speed = particleSpeed * CGFloat.random(in: 0.5...1.5)
            
            let particle = Particle(
                position: location,
                velocity: CGPoint(
                    x: cos(angle) * speed,
                    y: sin(angle) * speed
                ),
                size: CGFloat(particleSize + Double.random(in: -2...2)),
                color: selectedEffect.particleColor,
                lifetime: particleLifetime,
                birthTime: Date()
            )
            
            particles.append(particle)
        }
        
        appState.provideHapticFeedback(.impact(.light))
    }
    
    private func cleanupParticles() {
        let now = Date()
        particles.removeAll { particle in
            now.timeIntervalSince(particle.birthTime) > particle.lifetime
        }
    }
    
    private func applyPreset(_ preset: ParticlePreset) {
        switch preset {
        case .gentleSparkle:
            selectedEffect = .sparkle
            emissionRate = 15
            particleLifetime = 3
            particleSize = 6
            particleSpeed = 30
        case .blizzard:
            selectedEffect = .snow
            emissionRate = 50
            particleLifetime = 4
            particleSize = 8
            particleSpeed = 20
        case .celebration:
            selectedEffect = .confetti
            emissionRate = 30
            particleLifetime = 3
            particleSize = 10
            particleSpeed = 80
        case .magicalAura:
            selectedEffect = .magic
            emissionRate = 25
            particleLifetime = 2.5
            particleSize = 10
            particleSpeed = 40
        }
        
        particles.removeAll()
        if !isEmitting {
            startEmission()
        }
    }
}

// MARK: - Particle Model

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var size: CGFloat
    var color: Color
    var lifetime: Double
    var birthTime: Date
}

// MARK: - Particle Effect

enum ParticleEffect: String, CaseIterable, Identifiable {
    case sparkle
    case snow
    case rain
    case bubble
    case fire
    case confetti
    case dust
    case magic
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var systemImage: String {
        switch self {
        case .sparkle: return "sparkles"
        case .snow: return "snowflake"
        case .rain: return "cloud.rain"
        case .bubble: return "bubble.left.and.bubble.right"
        case .fire: return "flame"
        case .confetti: return "party.popper"
        case .dust: return "aqi.medium"
        case .magic: return "wand.and.stars"
        }
    }
    
    var particleColor: Color {
        switch self {
        case .sparkle: return [.yellow, .orange, .white].randomElement()!
        case .snow: return .white
        case .rain: return .cyan
        case .bubble: return .white
        case .fire: return [.red, .orange, .yellow].randomElement()!
        case .confetti: return [.red, .blue, .green, .yellow, .purple, .pink].randomElement()!
        case .dust: return .white
        case .magic: return [.purple, .pink, .cyan, .blue].randomElement()!
        }
    }
    
    var backgroundColors: [Color] {
        switch self {
        case .sparkle: return [.indigo, .purple]
        case .snow: return [.blue.opacity(0.8), .cyan.opacity(0.6)]
        case .rain: return [.gray, .blue.opacity(0.5)]
        case .bubble: return [.cyan, .blue]
        case .fire: return [.red.opacity(0.8), .orange.opacity(0.6)]
        case .confetti: return [.blue, .purple]
        case .dust: return [.brown.opacity(0.6), .orange.opacity(0.4)]
        case .magic: return [.purple, .indigo]
        }
    }
    
    func opacityCurve(_ progress: Double) -> Double {
        switch self {
        case .sparkle, .magic:
            return 1 - pow(progress, 0.5)
        case .snow, .dust:
            return 1 - progress
        case .rain:
            return 0.7
        case .bubble:
            return 0.6 * (1 - progress)
        case .fire:
            return 1 - pow(progress, 0.7)
        case .confetti:
            return 1 - pow(progress, 2)
        }
    }
    
    func scaleCurve(_ progress: Double) -> CGFloat {
        switch self {
        case .sparkle:
            return CGFloat(1 + sin(progress * .pi) * 0.3)
        case .snow, .rain, .dust:
            return 1
        case .bubble:
            return CGFloat(1 + progress * 0.5)
        case .fire:
            return CGFloat(1 - progress * 0.5)
        case .confetti:
            return 1
        case .magic:
            return CGFloat(1 + sin(progress * .pi * 2) * 0.2)
        }
    }
}

// MARK: - Particle Preset

enum ParticlePreset {
    case gentleSparkle
    case blizzard
    case celebration
    case magicalAura
}

// MARK: - Effect Button

struct EffectButton: View {
    let effect: ParticleEffect
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: effect.systemImage)
                    .font(.title3)
                
                Text(effect.displayName)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? Color.accentColor.opacity(0.2) : .clear)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preset Button

struct PresetButton: View {
    let title: String
    let description: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.yellow)
                
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
        ParticleGlassExperiment(parameters: .constant(GlassParameters()))
            .environmentObject(AppState())
    }
}
