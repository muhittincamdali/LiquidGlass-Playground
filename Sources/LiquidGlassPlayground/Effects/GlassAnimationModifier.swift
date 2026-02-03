//
//  GlassAnimationModifier.swift
//  LiquidGlass-Playground
//
//  Animation modifiers and effects for Liquid Glass components.
//  Provides spring, bounce, morph, and physics-based animations.
//

import SwiftUI

// MARK: - GlassAnimationType

/// Types of glass-specific animations
public enum GlassAnimationType: String, CaseIterable, Identifiable, Sendable {
    case bounce
    case spring
    case elastic
    case smooth
    case snappy
    case ripple
    case pulse
    case glow
    case shimmer
    case morph
    case liquid
    case breathe
    
    public var id: String { rawValue }
    
    public var displayName: String {
        rawValue.capitalized
    }
    
    public var animation: Animation {
        switch self {
        case .bounce:
            return .bouncy(duration: 0.5)
        case .spring:
            return .spring(response: 0.4, dampingFraction: 0.7)
        case .elastic:
            return .spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)
        case .smooth:
            return .smooth(duration: 0.4)
        case .snappy:
            return .snappy(duration: 0.3)
        case .ripple:
            return .spring(response: 0.6, dampingFraction: 0.6)
        case .pulse:
            return .easeInOut(duration: 0.8).repeatForever(autoreverses: true)
        case .glow:
            return .easeInOut(duration: 1.2).repeatForever(autoreverses: true)
        case .shimmer:
            return .linear(duration: 2.0).repeatForever(autoreverses: false)
        case .morph:
            return .spring(response: 0.35, dampingFraction: 0.75)
        case .liquid:
            return .interactiveSpring(response: 0.4, dampingFraction: 0.65)
        case .breathe:
            return .easeInOut(duration: 3.0).repeatForever(autoreverses: true)
        }
    }
}

// MARK: - GlassAnimationConfiguration

/// Configuration for glass animations
public struct GlassAnimationConfiguration: Equatable, Sendable {
    public var type: GlassAnimationType
    public var duration: Double
    public var delay: Double
    public var repeatCount: Int?
    public var autoreverses: Bool
    public var intensity: CGFloat
    
    public init(
        type: GlassAnimationType = .spring,
        duration: Double = 0.4,
        delay: Double = 0,
        repeatCount: Int? = nil,
        autoreverses: Bool = true,
        intensity: CGFloat = 1.0
    ) {
        self.type = type
        self.duration = duration
        self.delay = delay
        self.repeatCount = repeatCount
        self.autoreverses = autoreverses
        self.intensity = intensity
    }
    
    public static let `default` = GlassAnimationConfiguration()
    public static let bouncy = GlassAnimationConfiguration(type: .bounce)
    public static let elastic = GlassAnimationConfiguration(type: .elastic)
    public static let snappy = GlassAnimationConfiguration(type: .snappy, duration: 0.2)
}

// MARK: - GlassBounceModifier

/// Adds bounce animation to glass elements
@available(iOS 26.0, macOS 26.0, *)
public struct GlassBounceModifier: ViewModifier {
    let trigger: Bool
    let intensity: CGFloat
    
    @State private var scale: CGFloat = 1.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(trigger: Bool, intensity: CGFloat = 1.0) {
        self.trigger = trigger
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onChange(of: trigger) { _, _ in
                if !reduceMotion {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        scale = 1.0 + (0.1 * intensity)
                    }
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.15)) {
                        scale = 1.0
                    }
                }
            }
    }
}

// MARK: - GlassPulseModifier

/// Adds pulse animation to glass elements
@available(iOS 26.0, macOS 26.0, *)
public struct GlassPulseModifier: ViewModifier {
    let isActive: Bool
    let intensity: CGFloat
    let duration: Double
    
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(isActive: Bool = true, intensity: CGFloat = 1.0, duration: Double = 1.5) {
        self.isActive = isActive
        self.intensity = intensity
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                if isActive && !reduceMotion {
                    startPulse()
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue && !reduceMotion {
                    startPulse()
                } else {
                    stopPulse()
                }
            }
    }
    
    private func startPulse() {
        withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
            scale = 1.0 + (0.05 * intensity)
            opacity = 0.8
        }
    }
    
    private func stopPulse() {
        withAnimation(.easeOut(duration: 0.2)) {
            scale = 1.0
            opacity = 1.0
        }
    }
}

// MARK: - GlassShimmerModifier

/// Adds shimmer/shine animation to glass elements
@available(iOS 26.0, macOS 26.0, *)
public struct GlassShimmerModifier: ViewModifier {
    let isActive: Bool
    let color: Color
    let duration: Double
    let angle: Angle
    
    @State private var phase: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        isActive: Bool = true,
        color: Color = .white,
        duration: Double = 2.0,
        angle: Angle = .degrees(30)
    ) {
        self.isActive = isActive
        self.color = color
        self.duration = duration
        self.angle = angle
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay {
                if isActive && !reduceMotion {
                    GeometryReader { geometry in
                        shimmerGradient
                            .frame(width: geometry.size.width * 2)
                            .offset(x: -geometry.size.width + phase * geometry.size.width * 2)
                            .rotationEffect(angle)
                    }
                    .clipped()
                    .allowsHitTesting(false)
                }
            }
            .onAppear {
                if isActive && !reduceMotion {
                    startShimmer()
                }
            }
    }
    
    private var shimmerGradient: some View {
        LinearGradient(
            colors: [
                color.opacity(0),
                color.opacity(0.3),
                color.opacity(0.5),
                color.opacity(0.3),
                color.opacity(0)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private func startShimmer() {
        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
            phase = 1
        }
    }
}

// MARK: - GlassRippleModifier

/// Adds ripple effect to glass elements
@available(iOS 26.0, macOS 26.0, *)
public struct GlassRippleModifier: ViewModifier {
    let trigger: Bool
    let color: Color
    let duration: Double
    
    @State private var ripples: [RippleState] = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    struct RippleState: Identifiable {
        let id = UUID()
        var scale: CGFloat = 0
        var opacity: Double = 1
    }
    
    public init(trigger: Bool, color: Color = .white, duration: Double = 0.8) {
        self.trigger = trigger
        self.color = color
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    ForEach(ripples) { ripple in
                        Circle()
                            .stroke(color, lineWidth: 2)
                            .scaleEffect(ripple.scale)
                            .opacity(ripple.opacity)
                    }
                }
            }
            .onChange(of: trigger) { _, _ in
                if !reduceMotion {
                    addRipple()
                }
            }
    }
    
    private func addRipple() {
        var newRipple = RippleState()
        ripples.append(newRipple)
        
        withAnimation(.easeOut(duration: duration)) {
            if let index = ripples.firstIndex(where: { $0.id == newRipple.id }) {
                ripples[index].scale = 2.5
                ripples[index].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            ripples.removeAll { $0.id == newRipple.id }
        }
    }
}

// MARK: - GlassGlowModifier

/// Adds glow effect to glass elements
@available(iOS 26.0, macOS 26.0, *)
public struct GlassGlowModifier: ViewModifier {
    let isActive: Bool
    let color: Color
    let radius: CGFloat
    let intensity: CGFloat
    
    @State private var glowRadius: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        isActive: Bool = true,
        color: Color = .blue,
        radius: CGFloat = 15,
        intensity: CGFloat = 1.0
    ) {
        self.isActive = isActive
        self.color = color
        self.radius = radius
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content
            .shadow(
                color: color.opacity(0.5 * Double(intensity)),
                radius: glowRadius
            )
            .shadow(
                color: color.opacity(0.3 * Double(intensity)),
                radius: glowRadius * 1.5
            )
            .onAppear {
                if isActive && !reduceMotion {
                    startGlow()
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue && !reduceMotion {
                    startGlow()
                } else {
                    stopGlow()
                }
            }
    }
    
    private func startGlow() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            glowRadius = radius
        }
    }
    
    private func stopGlow() {
        withAnimation(.easeOut(duration: 0.3)) {
            glowRadius = 0
        }
    }
}

// MARK: - GlassMorphModifier

/// Enables morphing transitions between glass states
@available(iOS 26.0, macOS 26.0, *)
public struct GlassMorphModifier: ViewModifier {
    let id: String
    let namespace: Namespace.ID
    
    public init(id: String, namespace: Namespace.ID) {
        self.id = id
        self.namespace = namespace
    }
    
    public func body(content: Content) -> some View {
        content
            .matchedGeometryEffect(id: id, in: namespace)
    }
}

// MARK: - GlassFloatModifier

/// Adds floating animation to glass elements
@available(iOS 26.0, macOS 26.0, *)
public struct GlassFloatModifier: ViewModifier {
    let isActive: Bool
    let intensity: CGFloat
    let duration: Double
    
    @State private var offset: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(isActive: Bool = true, intensity: CGFloat = 1.0, duration: Double = 3.0) {
        self.isActive = isActive
        self.intensity = intensity
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .onAppear {
                if isActive && !reduceMotion {
                    startFloating()
                }
            }
    }
    
    private func startFloating() {
        withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
            offset = -8 * intensity
        }
    }
}

// MARK: - GlassBreathModifier

/// Adds breathing/scale animation
@available(iOS 26.0, macOS 26.0, *)
public struct GlassBreathModifier: ViewModifier {
    let isActive: Bool
    let minScale: CGFloat
    let maxScale: CGFloat
    let duration: Double
    
    @State private var scale: CGFloat = 1.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        isActive: Bool = true,
        minScale: CGFloat = 0.98,
        maxScale: CGFloat = 1.02,
        duration: Double = 4.0
    ) {
        self.isActive = isActive
        self.minScale = minScale
        self.maxScale = maxScale
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                scale = minScale
                if isActive && !reduceMotion {
                    startBreathing()
                }
            }
    }
    
    private func startBreathing() {
        withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
            scale = maxScale
        }
    }
}

// MARK: - GlassWobbleModifier

/// Adds wobble/jelly animation
@available(iOS 26.0, macOS 26.0, *)
public struct GlassWobbleModifier: ViewModifier {
    let trigger: Bool
    let intensity: CGFloat
    
    @State private var rotation: Angle = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(trigger: Bool, intensity: CGFloat = 1.0) {
        self.trigger = trigger
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content
            .rotationEffect(rotation)
            .onChange(of: trigger) { _, _ in
                if !reduceMotion {
                    wobble()
                }
            }
    }
    
    private func wobble() {
        let degrees = 3.0 * Double(intensity)
        
        withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) {
            rotation = .degrees(degrees)
        }
        
        withAnimation(.spring(response: 0.15, dampingFraction: 0.3).delay(0.1)) {
            rotation = .degrees(-degrees * 0.6)
        }
        
        withAnimation(.spring(response: 0.15, dampingFraction: 0.5).delay(0.2)) {
            rotation = .degrees(degrees * 0.3)
        }
        
        withAnimation(.spring(response: 0.15, dampingFraction: 0.7).delay(0.3)) {
            rotation = .zero
        }
    }
}

// MARK: - GlassSpringModifier

/// Adds spring physics to glass interactions
@available(iOS 26.0, macOS 26.0, *)
public struct GlassSpringModifier: ViewModifier {
    @Binding var isPressed: Bool
    let pressScale: CGFloat
    let response: Double
    let dampingFraction: Double
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        isPressed: Binding<Bool>,
        pressScale: CGFloat = 0.95,
        response: Double = 0.3,
        dampingFraction: Double = 0.6
    ) {
        self._isPressed = isPressed
        self.pressScale = pressScale
        self.response = response
        self.dampingFraction = dampingFraction
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? pressScale : 1.0)
            .animation(
                reduceMotion ? .none : .spring(response: response, dampingFraction: dampingFraction),
                value: isPressed
            )
    }
}

// MARK: - View Extensions

@available(iOS 26.0, macOS 26.0, *)
extension View {
    /// Applies bounce animation on trigger
    public func glassBounce(trigger: Bool, intensity: CGFloat = 1.0) -> some View {
        modifier(GlassBounceModifier(trigger: trigger, intensity: intensity))
    }
    
    /// Applies continuous pulse animation
    public func glassPulse(isActive: Bool = true, intensity: CGFloat = 1.0) -> some View {
        modifier(GlassPulseModifier(isActive: isActive, intensity: intensity))
    }
    
    /// Applies shimmer effect
    public func glassShimmer(isActive: Bool = true, color: Color = .white) -> some View {
        modifier(GlassShimmerModifier(isActive: isActive, color: color))
    }
    
    /// Applies ripple effect on trigger
    public func glassRipple(trigger: Bool, color: Color = .white) -> some View {
        modifier(GlassRippleModifier(trigger: trigger, color: color))
    }
    
    /// Applies glow effect
    public func glassGlow(isActive: Bool = true, color: Color = .blue, radius: CGFloat = 15) -> some View {
        modifier(GlassGlowModifier(isActive: isActive, color: color, radius: radius))
    }
    
    /// Applies floating animation
    public func glassFloat(isActive: Bool = true, intensity: CGFloat = 1.0) -> some View {
        modifier(GlassFloatModifier(isActive: isActive, intensity: intensity))
    }
    
    /// Applies breathing animation
    public func glassBreathe(isActive: Bool = true) -> some View {
        modifier(GlassBreathModifier(isActive: isActive))
    }
    
    /// Applies wobble animation on trigger
    public func glassWobble(trigger: Bool, intensity: CGFloat = 1.0) -> some View {
        modifier(GlassWobbleModifier(trigger: trigger, intensity: intensity))
    }
    
    /// Applies spring physics for press interactions
    public func glassSpring(isPressed: Binding<Bool>, pressScale: CGFloat = 0.95) -> some View {
        modifier(GlassSpringModifier(isPressed: isPressed, pressScale: pressScale))
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
struct GlassAnimationModifier_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Shimmer example
                Text("Shimmer")
                    .font(.title2.bold())
                    .padding()
                    .frame(width: 200)
                    .glassEffect(.regular, in: .capsule)
                    .glassShimmer()
                
                // Pulse example
                Text("Pulse")
                    .font(.title2.bold())
                    .padding()
                    .frame(width: 200)
                    .glassEffect(.regular, in: .capsule)
                    .glassPulse()
                
                // Glow example
                Text("Glow")
                    .font(.title2.bold())
                    .padding()
                    .frame(width: 200)
                    .glassEffect(.regular.tint(.cyan), in: .capsule)
                    .glassGlow(color: .cyan)
                
                // Float example
                Text("Float")
                    .font(.title2.bold())
                    .padding()
                    .frame(width: 200)
                    .glassEffect(.regular, in: .capsule)
                    .glassFloat()
            }
        }
    }
}
