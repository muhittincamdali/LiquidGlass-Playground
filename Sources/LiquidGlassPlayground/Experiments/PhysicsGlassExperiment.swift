// PhysicsGlassExperiment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Physics Glass Experiment

/// An experiment applying physics simulations to glass effects.
///
/// This experiment demonstrates how to combine physics behaviors
/// with Liquid Glass for dynamic, natural-feeling interfaces.
///
/// ## Features
/// - Gravity simulation
/// - Bounce effects
/// - Spring physics
/// - Collision detection
struct PhysicsGlassExperiment: View {
    
    // MARK: - Properties
    
    @Binding var parameters: GlassParameters
    @EnvironmentObject private var appState: AppState
    @State private var selectedPhysics: PhysicsType = .gravity
    @State private var physicsState = PhysicsState()
    @State private var isSimulating = false
    @State private var timer: Timer?
    
    // Physics parameters
    @State private var gravity: Double = 9.8
    @State private var bounciness: Double = 0.7
    @State private var friction: Double = 0.1
    @State private var springStiffness: Double = 150
    @State private var springDamping: Double = 10
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                physicsPreview
                
                physicsSelector
                
                physicsControls
                
                physicsFormulas
            }
            .padding()
        }
        .navigationTitle("Physics Glass")
        .onDisappear {
            stopSimulation()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "atom")
                    .font(.largeTitle)
                    .foregroundStyle(.indigo.gradient)
                
                VStack(alignment: .leading) {
                    Text("Physics Glass Effects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Natural motion behaviors")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Apply real-world physics to glass elements. Create natural, engaging animations with gravity, springs, and collision detection.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.glassEffect)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Physics Preview
    
    private var physicsPreview: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Simulation")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    toggleSimulation()
                } label: {
                    Label(
                        isSimulating ? "Stop" : "Start",
                        systemImage: isSimulating ? "stop.fill" : "play.fill"
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    resetPhysics()
                }
                .buttonStyle(.bordered)
            }
            
            GeometryReader { geometry in
                ZStack {
                    physicsBackground
                    
                    physicsGlassElement(in: geometry)
                    
                    if selectedPhysics == .collision {
                        collisionObjects(in: geometry)
                    }
                    
                    boundaryIndicators(in: geometry)
                }
            }
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .contentShape(Rectangle())
            .onTapGesture { location in
                applyForce(at: location)
            }
        }
    }
    
    private var physicsBackground: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<10) { index in
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .offset(
                        x: CGFloat.random(in: -150...150),
                        y: CGFloat.random(in: -180...180)
                    )
                    .blur(radius: 15)
            }
        }
    }
    
    private func physicsGlassElement(in geometry: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: parameters.cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: parameters.cornerRadius)
                    .fill(parameters.tintColor.color.opacity(parameters.tintOpacity))
            }
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: selectedPhysics.systemImage)
                        .font(.largeTitle)
                        .rotationEffect(.degrees(physicsState.rotation))
                    
                    Text(selectedPhysics.displayName)
                        .font(.headline)
                    
                    Text(String(format: "v: %.1f m/s", physicsState.velocity.magnitude))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: parameters.cornerRadius)
                    .strokeBorder(
                        .linearGradient(
                            colors: [.white.opacity(0.6), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: parameters.borderWidth
                    )
            }
            .frame(width: 120, height: 100)
            .scaleEffect(physicsState.scale)
            .position(
                x: geometry.size.width / 2 + physicsState.position.x,
                y: geometry.size.height / 2 + physicsState.position.y
            )
            .shadow(radius: 10 + abs(physicsState.velocity.magnitude) * 0.5)
    }
    
    private func collisionObjects(in geometry: GeometryProxy) -> some View {
        ForEach(physicsState.obstacles.indices, id: \.self) { index in
            let obstacle = physicsState.obstacles[index]
            Circle()
                .fill(.white.opacity(0.3))
                .frame(width: obstacle.radius * 2, height: obstacle.radius * 2)
                .position(
                    x: geometry.size.width / 2 + obstacle.position.x,
                    y: geometry.size.height / 2 + obstacle.position.y
                )
        }
    }
    
    private func boundaryIndicators(in geometry: GeometryProxy) -> some View {
        Group {
            if selectedPhysics == .gravity || selectedPhysics == .bounce {
                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(width: geometry.size.width - 40, height: 4)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 20)
            }
        }
    }
    
    // MARK: - Physics Selector
    
    private var physicsSelector: some View {
        VStack(spacing: 12) {
            Text("Physics Type")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(PhysicsType.allCases) { physics in
                    PhysicsTypeButton(
                        physics: physics,
                        isSelected: selectedPhysics == physics
                    ) {
                        withAnimation {
                            selectedPhysics = physics
                            resetPhysics()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Physics Controls
    
    private var physicsControls: some View {
        VStack(spacing: 16) {
            Text("Physics Parameters")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                switch selectedPhysics {
                case .gravity:
                    gravityControls
                case .bounce:
                    bounceControls
                case .spring:
                    springControls
                case .pendulum:
                    pendulumControls
                case .collision:
                    collisionControls
                case .fluid:
                    fluidControls
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var gravityControls: some View {
        VStack(spacing: 12) {
            GlassSlider(
                value: $gravity,
                range: 0...30,
                label: "Gravity (m/s²)",
                format: "%.1f"
            )
            
            GlassSlider(
                value: $friction,
                range: 0...1,
                label: "Air Resistance",
                format: "%.2f"
            )
            
            Text("Tap anywhere to apply upward force")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var bounceControls: some View {
        VStack(spacing: 12) {
            GlassSlider(
                value: $gravity,
                range: 0...30,
                label: "Gravity (m/s²)",
                format: "%.1f"
            )
            
            GlassSlider(
                value: $bounciness,
                range: 0...1,
                label: "Bounciness",
                format: "%.2f"
            )
            
            GlassSlider(
                value: $friction,
                range: 0...0.5,
                label: "Energy Loss",
                format: "%.2f"
            )
        }
    }
    
    private var springControls: some View {
        VStack(spacing: 12) {
            GlassSlider(
                value: $springStiffness,
                range: 50...500,
                label: "Stiffness (N/m)",
                format: "%.0f"
            )
            
            GlassSlider(
                value: $springDamping,
                range: 0...50,
                label: "Damping",
                format: "%.1f"
            )
            
            Text("Drag and release to see spring motion")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var pendulumControls: some View {
        VStack(spacing: 12) {
            GlassSlider(
                value: $gravity,
                range: 0...30,
                label: "Gravity (m/s²)",
                format: "%.1f"
            )
            
            GlassSlider(
                value: $friction,
                range: 0...0.2,
                label: "Air Damping",
                format: "%.3f"
            )
        }
    }
    
    private var collisionControls: some View {
        VStack(spacing: 12) {
            GlassSlider(
                value: $bounciness,
                range: 0...1,
                label: "Elasticity",
                format: "%.2f"
            )
            
            Button("Add Obstacle") {
                addObstacle()
            }
            .buttonStyle(.bordered)
            
            Button("Clear Obstacles") {
                physicsState.obstacles.removeAll()
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var fluidControls: some View {
        VStack(spacing: 12) {
            GlassSlider(
                value: $friction,
                range: 0...0.5,
                label: "Viscosity",
                format: "%.3f"
            )
            
            Text("Element moves smoothly through fluid")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Physics Formulas
    
    private var physicsFormulas: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Physics Formulas")
                .font(.headline)
            
            VStack(spacing: 12) {
                FormulaRow(
                    name: "Gravity",
                    formula: "F = m × g",
                    description: "Force equals mass times gravitational acceleration"
                )
                
                FormulaRow(
                    name: "Spring",
                    formula: "F = -k × x",
                    description: "Hooke's Law: force proportional to displacement"
                )
                
                FormulaRow(
                    name: "Momentum",
                    formula: "p = m × v",
                    description: "Momentum equals mass times velocity"
                )
                
                FormulaRow(
                    name: "Kinetic Energy",
                    formula: "KE = ½mv²",
                    description: "Energy from motion"
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Simulation Methods
    
    private func toggleSimulation() {
        if isSimulating {
            stopSimulation()
        } else {
            startSimulation()
        }
    }
    
    private func startSimulation() {
        isSimulating = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
            updatePhysics()
        }
    }
    
    private func stopSimulation() {
        isSimulating = false
        timer?.invalidate()
        timer = nil
    }
    
    private func resetPhysics() {
        stopSimulation()
        physicsState = PhysicsState()
        
        if selectedPhysics == .collision {
            physicsState.obstacles = [
                Obstacle(position: CGPoint(x: -80, y: 50), radius: 30),
                Obstacle(position: CGPoint(x: 80, y: -30), radius: 25)
            ]
        }
    }
    
    private func updatePhysics() {
        let dt: Double = 1.0 / 60.0
        
        switch selectedPhysics {
        case .gravity:
            updateGravity(dt: dt)
        case .bounce:
            updateBounce(dt: dt)
        case .spring:
            updateSpring(dt: dt)
        case .pendulum:
            updatePendulum(dt: dt)
        case .collision:
            updateCollision(dt: dt)
        case .fluid:
            updateFluid(dt: dt)
        }
    }
    
    private func updateGravity(dt: Double) {
        physicsState.velocity.y += gravity * dt * 10
        physicsState.velocity.x *= (1 - friction)
        physicsState.velocity.y *= (1 - friction * 0.5)
        
        physicsState.position.x += physicsState.velocity.x * dt
        physicsState.position.y += physicsState.velocity.y * dt
        
        if physicsState.position.y > 130 {
            physicsState.position.y = 130
            physicsState.velocity.y = 0
        }
    }
    
    private func updateBounce(dt: Double) {
        physicsState.velocity.y += gravity * dt * 10
        
        physicsState.position.x += physicsState.velocity.x * dt
        physicsState.position.y += physicsState.velocity.y * dt
        
        if physicsState.position.y > 130 {
            physicsState.position.y = 130
            physicsState.velocity.y = -physicsState.velocity.y * bounciness
            physicsState.velocity.x *= (1 - friction)
            
            if abs(physicsState.velocity.y) < 5 {
                physicsState.velocity.y = 0
            }
        }
    }
    
    private func updateSpring(dt: Double) {
        let displacement = physicsState.position
        let springForce = CGPoint(
            x: -springStiffness * displacement.x / 100,
            y: -springStiffness * displacement.y / 100
        )
        
        physicsState.velocity.x += springForce.x * dt
        physicsState.velocity.y += springForce.y * dt
        
        physicsState.velocity.x *= (1 - springDamping * dt)
        physicsState.velocity.y *= (1 - springDamping * dt)
        
        physicsState.position.x += physicsState.velocity.x * dt
        physicsState.position.y += physicsState.velocity.y * dt
    }
    
    private func updatePendulum(dt: Double) {
        let length: Double = 150
        let theta = atan2(physicsState.position.x, physicsState.position.y)
        let angularAccel = -gravity / length * sin(theta) * 10
        
        physicsState.angularVelocity += angularAccel * dt
        physicsState.angularVelocity *= (1 - friction)
        
        let newTheta = theta + physicsState.angularVelocity * dt
        physicsState.position.x = length * sin(newTheta)
        physicsState.position.y = length * cos(newTheta) - 50
        
        physicsState.rotation = newTheta * 180 / .pi
    }
    
    private func updateCollision(dt: Double) {
        physicsState.velocity.y += gravity * dt * 5
        
        physicsState.position.x += physicsState.velocity.x * dt
        physicsState.position.y += physicsState.velocity.y * dt
        
        for obstacle in physicsState.obstacles {
            let dx = physicsState.position.x - obstacle.position.x
            let dy = physicsState.position.y - obstacle.position.y
            let distance = sqrt(dx * dx + dy * dy)
            let minDistance = obstacle.radius + 50
            
            if distance < minDistance {
                let nx = dx / distance
                let ny = dy / distance
                let relativeVelocity = physicsState.velocity.x * nx + physicsState.velocity.y * ny
                
                physicsState.velocity.x -= 2 * relativeVelocity * nx * bounciness
                physicsState.velocity.y -= 2 * relativeVelocity * ny * bounciness
                
                physicsState.position.x = obstacle.position.x + nx * minDistance
                physicsState.position.y = obstacle.position.y + ny * minDistance
            }
        }
        
        clampPosition()
    }
    
    private func updateFluid(dt: Double) {
        let targetX: Double = 0
        let targetY: Double = 0
        
        physicsState.velocity.x += (targetX - physicsState.position.x) * 0.01
        physicsState.velocity.y += (targetY - physicsState.position.y) * 0.01
        
        physicsState.velocity.x *= (1 - friction)
        physicsState.velocity.y *= (1 - friction)
        
        physicsState.position.x += physicsState.velocity.x * dt * 50
        physicsState.position.y += physicsState.velocity.y * dt * 50
    }
    
    private func clampPosition() {
        let maxX: Double = 120
        let maxY: Double = 150
        
        if physicsState.position.x < -maxX {
            physicsState.position.x = -maxX
            physicsState.velocity.x = -physicsState.velocity.x * bounciness
        }
        if physicsState.position.x > maxX {
            physicsState.position.x = maxX
            physicsState.velocity.x = -physicsState.velocity.x * bounciness
        }
        if physicsState.position.y > maxY {
            physicsState.position.y = maxY
            physicsState.velocity.y = -physicsState.velocity.y * bounciness
        }
    }
    
    private func applyForce(at location: CGPoint) {
        physicsState.velocity.y -= 200
        physicsState.velocity.x += Double.random(in: -50...50)
    }
    
    private func addObstacle() {
        let obstacle = Obstacle(
            position: CGPoint(
                x: Double.random(in: -100...100),
                y: Double.random(in: -80...80)
            ),
            radius: Double.random(in: 20...40)
        )
        physicsState.obstacles.append(obstacle)
    }
}

// MARK: - Physics Type

enum PhysicsType: String, CaseIterable, Identifiable {
    case gravity
    case bounce
    case spring
    case pendulum
    case collision
    case fluid
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var systemImage: String {
        switch self {
        case .gravity: return "arrow.down"
        case .bounce: return "arrow.up.arrow.down"
        case .spring: return "wave.3.right"
        case .pendulum: return "metronome"
        case .collision: return "circle.circle"
        case .fluid: return "drop.fill"
        }
    }
}

// MARK: - Physics State

struct PhysicsState {
    var position: CGPoint = .zero
    var velocity: CGPoint = .zero
    var angularVelocity: Double = 0
    var rotation: Double = 0
    var scale: CGFloat = 1.0
    var obstacles: [Obstacle] = []
}

extension CGPoint {
    var magnitude: Double {
        sqrt(x * x + y * y)
    }
}

// MARK: - Obstacle

struct Obstacle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var radius: Double
}

// MARK: - Physics Type Button

struct PhysicsTypeButton: View {
    let physics: PhysicsType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: physics.systemImage)
                    .font(.title3)
                
                Text(physics.displayName)
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

// MARK: - Formula Row

struct FormulaRow: View {
    let name: String
    let formula: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(formula)
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundStyle(.indigo)
            }
            
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PhysicsGlassExperiment(parameters: .constant(GlassParameters()))
            .environmentObject(AppState())
    }
}
