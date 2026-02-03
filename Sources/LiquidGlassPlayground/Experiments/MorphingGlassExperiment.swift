// MorphingGlassExperiment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Morphing Glass Experiment

/// An experiment demonstrating shape-shifting glass effects.
///
/// This experiment shows how to create smooth transitions between
/// different shapes while maintaining the glass effect properties.
///
/// ## Features
/// - Shape interpolation
/// - Path morphing
/// - Smooth transitions
/// - Custom shapes
struct MorphingGlassExperiment: View {
    
    // MARK: - Properties
    
    @Binding var parameters: GlassParameters
    @EnvironmentObject private var appState: AppState
    @State private var selectedShape: MorphShape = .circle
    @State private var morphProgress: CGFloat = 0
    @State private var isAutoMorphing = false
    @State private var morphDuration: Double = 1.5
    @State private var morphCurve: MorphCurve = .easeInOut
    @State private var showCustomShapeEditor = false
    @State private var customPoints: [CGPoint] = []
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                morphPreview
                
                shapeSelector
                
                morphControls
                
                morphSequencer
                
                shapeGallery
            }
            .padding()
        }
        .navigationTitle("Morphing Glass")
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "wand.and.stars")
                    .font(.largeTitle)
                    .foregroundStyle(.mint.gradient)
                
                VStack(alignment: .leading) {
                    Text("Morphing Glass Effects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Shape-shifting magic")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Create captivating shape transitions with smooth morphing animations. Watch glass elements transform seamlessly between shapes.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.glassEffect)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Morph Preview
    
    private var morphPreview: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Preview")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    toggleAutoMorph()
                } label: {
                    Label(
                        isAutoMorphing ? "Stop" : "Auto",
                        systemImage: isAutoMorphing ? "stop.fill" : "arrow.triangle.2.circlepath"
                    )
                }
                .buttonStyle(.borderedProminent)
            }
            
            ZStack {
                morphBackground
                
                morphingGlassElement
            }
            .frame(height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var morphBackground: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .teal, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<8) { index in
                Circle()
                    .fill(.white.opacity(0.15))
                    .frame(width: 80, height: 80)
                    .offset(
                        x: cos(Double(index) * .pi / 4) * 100,
                        y: sin(Double(index) * .pi / 4) * 100
                    )
                    .blur(radius: 20)
            }
        }
    }
    
    private var morphingGlassElement: some View {
        MorphingShape(
            shape: selectedShape,
            progress: morphProgress,
            parameters: parameters
        )
        .fill(.ultraThinMaterial)
        .overlay {
            MorphingShape(
                shape: selectedShape,
                progress: morphProgress,
                parameters: parameters
            )
            .fill(parameters.tintColor.color.opacity(parameters.tintOpacity))
        }
        .overlay {
            VStack(spacing: 8) {
                Image(systemName: selectedShape.systemImage)
                    .font(.title)
                
                Text(selectedShape.displayName)
                    .font(.headline)
                
                Text(String(format: "%.0f%%", morphProgress * 100))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .overlay {
            MorphingShape(
                shape: selectedShape,
                progress: morphProgress,
                parameters: parameters
            )
            .stroke(
                .linearGradient(
                    colors: [.white.opacity(0.6), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: parameters.borderWidth
            )
        }
        .frame(width: 200, height: 200)
        .shadow(radius: parameters.shadowRadius)
    }
    
    // MARK: - Shape Selector
    
    private var shapeSelector: some View {
        VStack(spacing: 12) {
            Text("Target Shape")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(MorphShape.allCases) { shape in
                    ShapeButton(
                        shape: shape,
                        isSelected: selectedShape == shape
                    ) {
                        withAnimation(morphAnimation) {
                            selectedShape = shape
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Morph Controls
    
    private var morphControls: some View {
        VStack(spacing: 16) {
            Text("Morph Controls")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                GlassSlider(
                    value: $morphProgress,
                    range: 0...1,
                    label: "Morph Progress",
                    format: "%.2f"
                )
                
                GlassSlider(
                    value: $morphDuration,
                    range: 0.3...5,
                    label: "Duration",
                    format: "%.1fs"
                )
                
                Picker("Curve", selection: $morphCurve) {
                    ForEach(MorphCurve.allCases) { curve in
                        Text(curve.displayName).tag(curve)
                    }
                }
                .pickerStyle(.segmented)
                
                HStack {
                    Button("0%") {
                        withAnimation(morphAnimation) {
                            morphProgress = 0
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Button("50%") {
                        withAnimation(morphAnimation) {
                            morphProgress = 0.5
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Button("100%") {
                        withAnimation(morphAnimation) {
                            morphProgress = 1.0
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Morph Sequencer
    
    private var morphSequencer: some View {
        VStack(spacing: 16) {
            Text("Morph Sequences")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                SequenceCard(
                    title: "Shape Cycle",
                    description: "Circle → Square → Star → Circle",
                    icon: "arrow.triangle.2.circlepath"
                ) {
                    playShapeCycle()
                }
                
                SequenceCard(
                    title: "Pulse",
                    description: "Rhythmic size pulse",
                    icon: "waveform"
                ) {
                    playPulseSequence()
                }
                
                SequenceCard(
                    title: "Bounce",
                    description: "Elastic morph effect",
                    icon: "arrow.up.arrow.down"
                ) {
                    playBounceSequence()
                }
                
                SequenceCard(
                    title: "Random",
                    description: "Surprise transitions",
                    icon: "dice"
                ) {
                    playRandomSequence()
                }
            }
        }
    }
    
    // MARK: - Shape Gallery
    
    private var shapeGallery: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Shape Reference")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(MorphShape.allCases) { shape in
                    ShapeReferenceRow(shape: shape)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Computed Properties
    
    private var morphAnimation: Animation {
        switch morphCurve {
        case .linear: return .linear(duration: morphDuration)
        case .easeIn: return .easeIn(duration: morphDuration)
        case .easeOut: return .easeOut(duration: morphDuration)
        case .easeInOut: return .easeInOut(duration: morphDuration)
        case .spring: return .spring(duration: morphDuration, bounce: 0.3)
        case .bouncy: return .spring(duration: morphDuration, bounce: 0.6)
        }
    }
    
    // MARK: - Methods
    
    private func toggleAutoMorph() {
        isAutoMorphing.toggle()
        
        if isAutoMorphing {
            startAutoMorph()
        }
    }
    
    private func startAutoMorph() {
        guard isAutoMorphing else { return }
        
        withAnimation(morphAnimation) {
            morphProgress = morphProgress < 0.5 ? 1.0 : 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + morphDuration + 0.5) {
            startAutoMorph()
        }
    }
    
    private func playShapeCycle() {
        let shapes: [MorphShape] = [.circle, .square, .star, .hexagon, .circle]
        var delay: Double = 0
        
        for shape in shapes {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(morphAnimation) {
                    selectedShape = shape
                }
            }
            delay += morphDuration + 0.2
        }
    }
    
    private func playPulseSequence() {
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.6) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    morphProgress = 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.6 + 0.3) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    morphProgress = 0.0
                }
            }
        }
    }
    
    private func playBounceSequence() {
        withAnimation(.spring(duration: 0.8, bounce: 0.7)) {
            morphProgress = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring(duration: 0.8, bounce: 0.7)) {
                morphProgress = 0.0
            }
        }
    }
    
    private func playRandomSequence() {
        for i in 0..<6 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.8) {
                withAnimation(morphAnimation) {
                    selectedShape = MorphShape.allCases.randomElement() ?? .circle
                    morphProgress = Double.random(in: 0...1)
                }
            }
        }
    }
}

// MARK: - Morph Shape

enum MorphShape: String, CaseIterable, Identifiable {
    case circle
    case square
    case roundedSquare
    case star
    case hexagon
    case triangle
    case diamond
    case heart
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .roundedSquare: return "Rounded"
        default: return rawValue.capitalized
        }
    }
    
    var systemImage: String {
        switch self {
        case .circle: return "circle.fill"
        case .square: return "square.fill"
        case .roundedSquare: return "app.fill"
        case .star: return "star.fill"
        case .hexagon: return "hexagon.fill"
        case .triangle: return "triangle.fill"
        case .diamond: return "diamond.fill"
        case .heart: return "heart.fill"
        }
    }
    
    var pointCount: Int {
        switch self {
        case .circle: return 32
        case .square, .roundedSquare, .diamond: return 4
        case .star: return 10
        case .hexagon: return 6
        case .triangle: return 3
        case .heart: return 20
        }
    }
}

// MARK: - Morph Curve

enum MorphCurve: String, CaseIterable, Identifiable {
    case linear
    case easeIn
    case easeOut
    case easeInOut
    case spring
    case bouncy
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .linear: return "Linear"
        case .easeIn: return "Ease In"
        case .easeOut: return "Ease Out"
        case .easeInOut: return "Ease"
        case .spring: return "Spring"
        case .bouncy: return "Bouncy"
        }
    }
}

// MARK: - Morphing Shape View

struct MorphingShape: Shape {
    let shape: MorphShape
    var progress: CGFloat
    let parameters: GlassParameters
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 * (0.8 + progress * 0.2)
        
        switch shape {
        case .circle:
            return circlePath(center: center, radius: radius)
        case .square:
            return squarePath(center: center, size: radius * 2)
        case .roundedSquare:
            return roundedSquarePath(center: center, size: radius * 2, cornerRadius: parameters.cornerRadius)
        case .star:
            return starPath(center: center, radius: radius)
        case .hexagon:
            return polygonPath(center: center, radius: radius, sides: 6)
        case .triangle:
            return polygonPath(center: center, radius: radius, sides: 3)
        case .diamond:
            return diamondPath(center: center, radius: radius)
        case .heart:
            return heartPath(center: center, radius: radius)
        }
    }
    
    private func circlePath(center: CGPoint, radius: CGFloat) -> Path {
        Path { path in
            path.addEllipse(in: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
            ))
        }
    }
    
    private func squarePath(center: CGPoint, size: CGFloat) -> Path {
        Path { path in
            path.addRect(CGRect(
                x: center.x - size / 2,
                y: center.y - size / 2,
                width: size,
                height: size
            ))
        }
    }
    
    private func roundedSquarePath(center: CGPoint, size: CGFloat, cornerRadius: Double) -> Path {
        Path { path in
            path.addRoundedRect(
                in: CGRect(
                    x: center.x - size / 2,
                    y: center.y - size / 2,
                    width: size,
                    height: size
                ),
                cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
            )
        }
    }
    
    private func starPath(center: CGPoint, radius: CGFloat) -> Path {
        Path { path in
            let points = 5
            let innerRadius = radius * 0.4
            
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
        }
    }
    
    private func polygonPath(center: CGPoint, radius: CGFloat, sides: Int) -> Path {
        Path { path in
            for i in 0..<sides {
                let angle = Double(i) * 2 * .pi / Double(sides) - .pi / 2
                let x = center.x + CGFloat(cos(angle)) * radius
                let y = center.y + CGFloat(sin(angle)) * radius
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
        }
    }
    
    private func diamondPath(center: CGPoint, radius: CGFloat) -> Path {
        Path { path in
            path.move(to: CGPoint(x: center.x, y: center.y - radius))
            path.addLine(to: CGPoint(x: center.x + radius, y: center.y))
            path.addLine(to: CGPoint(x: center.x, y: center.y + radius))
            path.addLine(to: CGPoint(x: center.x - radius, y: center.y))
            path.closeSubpath()
        }
    }
    
    private func heartPath(center: CGPoint, radius: CGFloat) -> Path {
        Path { path in
            let width = radius * 2
            let height = radius * 1.8
            
            path.move(to: CGPoint(x: center.x, y: center.y + height * 0.35))
            
            path.addCurve(
                to: CGPoint(x: center.x - width * 0.5, y: center.y - height * 0.1),
                control1: CGPoint(x: center.x - width * 0.15, y: center.y + height * 0.15),
                control2: CGPoint(x: center.x - width * 0.5, y: center.y + height * 0.1)
            )
            
            path.addCurve(
                to: CGPoint(x: center.x, y: center.y - height * 0.35),
                control1: CGPoint(x: center.x - width * 0.5, y: center.y - height * 0.35),
                control2: CGPoint(x: center.x - width * 0.15, y: center.y - height * 0.35)
            )
            
            path.addCurve(
                to: CGPoint(x: center.x + width * 0.5, y: center.y - height * 0.1),
                control1: CGPoint(x: center.x + width * 0.15, y: center.y - height * 0.35),
                control2: CGPoint(x: center.x + width * 0.5, y: center.y - height * 0.35)
            )
            
            path.addCurve(
                to: CGPoint(x: center.x, y: center.y + height * 0.35),
                control1: CGPoint(x: center.x + width * 0.5, y: center.y + height * 0.1),
                control2: CGPoint(x: center.x + width * 0.15, y: center.y + height * 0.15)
            )
        }
    }
}

// MARK: - Shape Button

struct ShapeButton: View {
    let shape: MorphShape
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: shape.systemImage)
                    .font(.title3)
                
                Text(shape.displayName)
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

// MARK: - Sequence Card

struct SequenceCard: View {
    let title: String
    let description: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.mint)
                
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

// MARK: - Shape Reference Row

struct ShapeReferenceRow: View {
    let shape: MorphShape
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: shape.systemImage)
                .font(.title2)
                .foregroundStyle(.mint)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(shape.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(shape.pointCount) control points")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        MorphingGlassExperiment(parameters: .constant(GlassParameters()))
            .environmentObject(AppState())
    }
}
