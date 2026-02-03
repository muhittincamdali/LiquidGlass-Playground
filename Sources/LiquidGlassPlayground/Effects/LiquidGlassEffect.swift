//
//  LiquidGlassEffect.swift
//  LiquidGlass-Playground
//
//  Advanced Liquid Glass effect implementations for iOS 26.
//  Provides custom modifiers, animations, and shader-based effects.
//

import SwiftUI

// MARK: - LiquidGlassVariant

/// Extended variants for Liquid Glass effects
public enum LiquidGlassVariant: String, CaseIterable, Identifiable, Sendable {
    case standard
    case frosted
    case crystal
    case ice
    case water
    case aurora
    case neon
    case holographic
    case smoke
    case diamond
    
    public var id: String { rawValue }
    
    public var displayName: String {
        rawValue.capitalized
    }
    
    public var description: String {
        switch self {
        case .standard: return "Default Liquid Glass appearance"
        case .frosted: return "Heavy blur with matte finish"
        case .crystal: return "Sharp edges with prismatic refraction"
        case .ice: return "Cool blue tones with crystalline texture"
        case .water: return "Fluid, wave-like distortion"
        case .aurora: return "Northern lights color shifting"
        case .neon: return "Bright, glowing edges"
        case .holographic: return "Rainbow gradient reflections"
        case .smoke: return "Soft, diffused appearance"
        case .diamond: return "Sparkle and brilliance effects"
        }
    }
    
    public var primaryColor: Color {
        switch self {
        case .standard: return .clear
        case .frosted: return .white.opacity(0.1)
        case .crystal: return .white.opacity(0.05)
        case .ice: return .cyan.opacity(0.1)
        case .water: return .blue.opacity(0.08)
        case .aurora: return .green.opacity(0.1)
        case .neon: return .pink.opacity(0.15)
        case .holographic: return .purple.opacity(0.1)
        case .smoke: return .gray.opacity(0.1)
        case .diamond: return .white.opacity(0.15)
        }
    }
    
    public var secondaryColor: Color {
        switch self {
        case .standard: return .clear
        case .frosted: return .white.opacity(0.05)
        case .crystal: return .white.opacity(0.1)
        case .ice: return .blue.opacity(0.05)
        case .water: return .cyan.opacity(0.05)
        case .aurora: return .purple.opacity(0.08)
        case .neon: return .cyan.opacity(0.1)
        case .holographic: return .pink.opacity(0.08)
        case .smoke: return .black.opacity(0.05)
        case .diamond: return .yellow.opacity(0.05)
        }
    }
    
    public var blurIntensity: CGFloat {
        switch self {
        case .standard: return 1.0
        case .frosted: return 1.5
        case .crystal: return 0.7
        case .ice: return 1.2
        case .water: return 0.9
        case .aurora: return 1.1
        case .neon: return 0.8
        case .holographic: return 0.85
        case .smoke: return 1.8
        case .diamond: return 0.6
        }
    }
}

// MARK: - LiquidGlassParameters

/// Parameters for customizing Liquid Glass effects
public struct LiquidGlassParameters: Equatable, Sendable {
    public var variant: LiquidGlassVariant
    public var blurRadius: CGFloat
    public var refractionIndex: CGFloat
    public var reflectivity: CGFloat
    public var saturation: CGFloat
    public var brightness: CGFloat
    public var tintColor: Color?
    public var tintIntensity: CGFloat
    public var borderWidth: CGFloat
    public var borderOpacity: CGFloat
    public var shadowIntensity: CGFloat
    public var isInteractive: Bool
    public var animationSpeed: CGFloat
    
    public init(
        variant: LiquidGlassVariant = .standard,
        blurRadius: CGFloat = 20,
        refractionIndex: CGFloat = 1.0,
        reflectivity: CGFloat = 0.5,
        saturation: CGFloat = 1.2,
        brightness: CGFloat = 1.0,
        tintColor: Color? = nil,
        tintIntensity: CGFloat = 0.3,
        borderWidth: CGFloat = 0.5,
        borderOpacity: CGFloat = 0.3,
        shadowIntensity: CGFloat = 0.2,
        isInteractive: Bool = true,
        animationSpeed: CGFloat = 1.0
    ) {
        self.variant = variant
        self.blurRadius = blurRadius
        self.refractionIndex = refractionIndex
        self.reflectivity = reflectivity
        self.saturation = saturation
        self.brightness = brightness
        self.tintColor = tintColor
        self.tintIntensity = tintIntensity
        self.borderWidth = borderWidth
        self.borderOpacity = borderOpacity
        self.shadowIntensity = shadowIntensity
        self.isInteractive = isInteractive
        self.animationSpeed = animationSpeed
    }
    
    // MARK: Presets
    
    public static let `default` = LiquidGlassParameters()
    
    public static let frosted = LiquidGlassParameters(
        variant: .frosted,
        blurRadius: 30,
        reflectivity: 0.3,
        saturation: 0.9
    )
    
    public static let crystal = LiquidGlassParameters(
        variant: .crystal,
        blurRadius: 15,
        refractionIndex: 1.5,
        reflectivity: 0.8,
        borderOpacity: 0.5
    )
    
    public static let ice = LiquidGlassParameters(
        variant: .ice,
        blurRadius: 25,
        tintColor: .cyan,
        tintIntensity: 0.2,
        saturation: 1.1
    )
    
    public static let water = LiquidGlassParameters(
        variant: .water,
        blurRadius: 18,
        refractionIndex: 1.33,
        tintColor: .blue,
        tintIntensity: 0.15
    )
    
    public static let aurora = LiquidGlassParameters(
        variant: .aurora,
        blurRadius: 22,
        saturation: 1.4,
        brightness: 1.1,
        animationSpeed: 0.5
    )
    
    public static let neon = LiquidGlassParameters(
        variant: .neon,
        blurRadius: 16,
        brightness: 1.3,
        borderWidth: 1.0,
        borderOpacity: 0.8,
        shadowIntensity: 0.5
    )
    
    public static let holographic = LiquidGlassParameters(
        variant: .holographic,
        blurRadius: 17,
        refractionIndex: 1.2,
        reflectivity: 0.7,
        saturation: 1.3
    )
    
    public static let smoke = LiquidGlassParameters(
        variant: .smoke,
        blurRadius: 35,
        reflectivity: 0.2,
        saturation: 0.7,
        brightness: 0.95
    )
    
    public static let diamond = LiquidGlassParameters(
        variant: .diamond,
        blurRadius: 12,
        refractionIndex: 2.4,
        reflectivity: 0.9,
        brightness: 1.15,
        borderOpacity: 0.6
    )
}

// MARK: - LiquidGlassModifier

/// A comprehensive view modifier for Liquid Glass effects
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassModifier<S: Shape>: ViewModifier {
    let parameters: LiquidGlassParameters
    let shape: S
    
    @State private var animationPhase: CGFloat = 0
    @State private var isHovered = false
    @State private var pressLocation: CGPoint?
    
    @Namespace private var namespace
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    public init(
        parameters: LiquidGlassParameters = .default,
        shape: S
    ) {
        self.parameters = parameters
        self.shape = shape
    }
    
    public func body(content: Content) -> some View {
        content
            .background(glassBackground)
            .overlay(borderOverlay)
            .clipShape(shape)
            .shadow(
                color: shadowColor,
                radius: parameters.shadowIntensity * 10,
                y: parameters.shadowIntensity * 5
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(
                reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7),
                value: isHovered
            )
            .onHover { hovering in
                if parameters.isInteractive {
                    isHovered = hovering
                }
            }
            .glassEffectID(UUID().uuidString, in: namespace)
            .onAppear {
                if !reduceMotion && parameters.animationSpeed > 0 {
                    withAnimation(.linear(duration: 10 / parameters.animationSpeed).repeatForever(autoreverses: false)) {
                        animationPhase = 1
                    }
                }
            }
    }
    
    // MARK: Glass Background
    
    @ViewBuilder
    private var glassBackground: some View {
        if reduceTransparency {
            shape.fill(solidBackgroundColor)
        } else {
            ZStack {
                // Base glass effect
                baseGlassLayer
                
                // Variant-specific layers
                variantLayers
                
                // Shimmer effect
                if parameters.reflectivity > 0.3 && !reduceMotion {
                    shimmerLayer
                }
            }
        }
    }
    
    @ViewBuilder
    private var baseGlassLayer: some View {
        let glass: Glass = {
            var g: Glass = parameters.isInteractive ? .regular.interactive() : .regular
            if let tint = parameters.tintColor {
                g = g.tint(tint.opacity(parameters.tintIntensity))
            } else if parameters.variant != .standard {
                g = g.tint(parameters.variant.primaryColor)
            }
            return g
        }()
        
        Color.clear.glassEffect(glass, in: shape)
    }
    
    @ViewBuilder
    private var variantLayers: some View {
        switch parameters.variant {
        case .frosted:
            frostedLayer
        case .crystal:
            crystalLayer
        case .ice:
            iceLayer
        case .water:
            waterLayer
        case .aurora:
            auroraLayer
        case .neon:
            neonLayer
        case .holographic:
            holographicLayer
        case .smoke:
            smokeLayer
        case .diamond:
            diamondLayer
        case .standard:
            EmptyView()
        }
    }
    
    // MARK: Variant Layers
    
    @ViewBuilder
    private var frostedLayer: some View {
        LinearGradient(
            colors: [
                Color.white.opacity(0.15),
                Color.white.opacity(0.05),
                Color.white.opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .blendMode(.overlay)
    }
    
    @ViewBuilder
    private var crystalLayer: some View {
        ZStack {
            // Prismatic effect
            LinearGradient(
                colors: [
                    Color.red.opacity(0.03),
                    Color.orange.opacity(0.02),
                    Color.yellow.opacity(0.03),
                    Color.green.opacity(0.02),
                    Color.blue.opacity(0.03),
                    Color.purple.opacity(0.02)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blendMode(.plusLighter)
            
            // Edge highlights
            shape
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.5), .clear, .white.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }
    
    @ViewBuilder
    private var iceLayer: some View {
        ZStack {
            // Cool gradient
            LinearGradient(
                colors: [
                    Color.cyan.opacity(0.1),
                    Color.blue.opacity(0.05),
                    Color.white.opacity(0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.overlay)
            
            // Frost texture simulation
            if !reduceMotion {
                GeometryReader { geo in
                    Canvas { context, size in
                        for _ in 0..<20 {
                            let x = CGFloat.random(in: 0...size.width)
                            let y = CGFloat.random(in: 0...size.height)
                            let sparkleSize = CGFloat.random(in: 1...3)
                            
                            context.fill(
                                Circle().path(in: CGRect(x: x, y: y, width: sparkleSize, height: sparkleSize)),
                                with: .color(.white.opacity(0.3))
                            )
                        }
                    }
                    .opacity(0.5)
                }
            }
        }
    }
    
    @ViewBuilder
    private var waterLayer: some View {
        ZStack {
            // Water caustics simulation
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.08),
                    Color.cyan.opacity(0.05),
                    Color.blue.opacity(0.06)
                ],
                startPoint: UnitPoint(x: animationPhase, y: 0),
                endPoint: UnitPoint(x: 1 - animationPhase, y: 1)
            )
            .blendMode(.overlay)
            
            // Ripple effect
            if !reduceMotion {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.1), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .scaleEffect(1 + animationPhase * 0.5)
                    .opacity(1 - animationPhase)
            }
        }
    }
    
    @ViewBuilder
    private var auroraLayer: some View {
        ZStack {
            // Aurora gradient
            LinearGradient(
                colors: [
                    Color.green.opacity(0.12),
                    Color.cyan.opacity(0.08),
                    Color.purple.opacity(0.1),
                    Color.pink.opacity(0.08)
                ],
                startPoint: UnitPoint(x: animationPhase, y: 0),
                endPoint: UnitPoint(x: 1, y: 1 - animationPhase)
            )
            .blendMode(.overlay)
            
            // Secondary wave
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.06),
                    Color.green.opacity(0.08),
                    Color.cyan.opacity(0.06)
                ],
                startPoint: UnitPoint(x: 1 - animationPhase, y: animationPhase),
                endPoint: UnitPoint(x: animationPhase, y: 1)
            )
            .blendMode(.plusLighter)
        }
    }
    
    @ViewBuilder
    private var neonLayer: some View {
        ZStack {
            // Inner glow
            shape
                .stroke(
                    LinearGradient(
                        colors: [.pink.opacity(0.5), .cyan.opacity(0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
                .blur(radius: 4)
            
            // Outer glow
            shape
                .stroke(
                    LinearGradient(
                        colors: [.pink.opacity(0.3), .cyan.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 4
                )
                .blur(radius: 8)
        }
    }
    
    @ViewBuilder
    private var holographicLayer: some View {
        // Rainbow gradient
        LinearGradient(
            colors: [
                Color.red.opacity(0.08),
                Color.orange.opacity(0.07),
                Color.yellow.opacity(0.08),
                Color.green.opacity(0.07),
                Color.blue.opacity(0.08),
                Color.purple.opacity(0.07),
                Color.pink.opacity(0.08)
            ],
            startPoint: UnitPoint(x: animationPhase, y: 0),
            endPoint: UnitPoint(x: 1 - animationPhase, y: 1)
        )
        .blendMode(.overlay)
    }
    
    @ViewBuilder
    private var smokeLayer: some View {
        ZStack {
            // Diffuse gradient
            RadialGradient(
                colors: [
                    Color.gray.opacity(0.1),
                    Color.black.opacity(0.05),
                    Color.gray.opacity(0.08)
                ],
                center: UnitPoint(x: 0.3 + animationPhase * 0.4, y: 0.3 + animationPhase * 0.4),
                startRadius: 0,
                endRadius: 200
            )
            .blendMode(.overlay)
        }
    }
    
    @ViewBuilder
    private var diamondLayer: some View {
        ZStack {
            // Brilliance
            AngularGradient(
                colors: [
                    Color.white.opacity(0.2),
                    Color.clear,
                    Color.white.opacity(0.15),
                    Color.clear,
                    Color.white.opacity(0.2),
                    Color.clear,
                    Color.white.opacity(0.15),
                    Color.clear
                ],
                center: .center,
                angle: .degrees(animationPhase * 360)
            )
            .blendMode(.overlay)
            
            // Sparkle points
            if !reduceMotion {
                GeometryReader { geo in
                    ForEach(0..<5, id: \.self) { i in
                        let angle = (Double(i) / 5.0 + Double(animationPhase)) * 2 * .pi
                        let radius = min(geo.size.width, geo.size.height) * 0.3
                        let x = geo.size.width / 2 + cos(angle) * radius
                        let y = geo.size.height / 2 + sin(angle) * radius
                        
                        Image(systemName: "sparkle")
                            .font(.system(size: 8))
                            .foregroundStyle(.white.opacity(0.6))
                            .position(x: x, y: y)
                    }
                }
            }
        }
    }
    
    // MARK: Shimmer Layer
    
    @ViewBuilder
    private var shimmerLayer: some View {
        GeometryReader { geometry in
            let shimmerGradient = LinearGradient(
                colors: [
                    Color.white.opacity(0),
                    Color.white.opacity(parameters.reflectivity * 0.3),
                    Color.white.opacity(0)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            
            Rectangle()
                .fill(shimmerGradient)
                .frame(width: geometry.size.width * 0.5)
                .offset(x: -geometry.size.width * 0.5 + geometry.size.width * 1.5 * animationPhase)
                .blendMode(.overlay)
        }
        .clipShape(shape)
    }
    
    // MARK: Border Overlay
    
    @ViewBuilder
    private var borderOverlay: some View {
        if parameters.borderWidth > 0 && parameters.borderOpacity > 0 {
            shape
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(parameters.borderOpacity),
                            Color.white.opacity(parameters.borderOpacity * 0.3),
                            Color.white.opacity(parameters.borderOpacity * 0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: parameters.borderWidth
                )
        }
    }
    
    // MARK: Computed Properties
    
    private var solidBackgroundColor: Color {
        colorScheme == .dark
            ? Color.gray.opacity(0.3)
            : Color.white.opacity(0.8)
    }
    
    private var shadowColor: Color {
        if let tint = parameters.tintColor {
            return tint.opacity(parameters.shadowIntensity)
        }
        return Color.black.opacity(parameters.shadowIntensity)
    }
}

// MARK: - View Extension

@available(iOS 26.0, macOS 26.0, *)
extension View {
    /// Applies a Liquid Glass effect with custom parameters
    public func liquidGlass<S: Shape>(
        _ parameters: LiquidGlassParameters = .default,
        in shape: S
    ) -> some View {
        modifier(LiquidGlassModifier(parameters: parameters, shape: shape))
    }
    
    /// Applies a Liquid Glass effect with a variant preset
    public func liquidGlass<S: Shape>(
        variant: LiquidGlassVariant,
        in shape: S
    ) -> some View {
        let parameters: LiquidGlassParameters = {
            switch variant {
            case .standard: return .default
            case .frosted: return .frosted
            case .crystal: return .crystal
            case .ice: return .ice
            case .water: return .water
            case .aurora: return .aurora
            case .neon: return .neon
            case .holographic: return .holographic
            case .smoke: return .smoke
            case .diamond: return .diamond
            }
        }()
        return modifier(LiquidGlassModifier(parameters: parameters, shape: shape))
    }
    
    /// Applies a simple Liquid Glass effect with default shape
    public func liquidGlass(variant: LiquidGlassVariant = .standard) -> some View {
        liquidGlass(variant: variant, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

// MARK: - LiquidGlassPreview

@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassPreview: View {
    let variant: LiquidGlassVariant
    let size: CGFloat
    
    public init(variant: LiquidGlassVariant, size: CGFloat = 120) {
        self.variant = variant
        self.size = size
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            Text(variant.displayName)
                .font(.headline)
                .foregroundStyle(.primary)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .liquidGlass(variant: variant, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .frame(width: size, height: size)
            
            Text(variant.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(width: size + 40)
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
struct LiquidGlassEffect_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 20) {
                    ForEach(LiquidGlassVariant.allCases) { variant in
                        LiquidGlassPreview(variant: variant)
                    }
                }
                .padding()
            }
        }
    }
}
