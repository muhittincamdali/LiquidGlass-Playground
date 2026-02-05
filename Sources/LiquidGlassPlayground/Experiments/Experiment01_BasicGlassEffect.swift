//
//  Experiment01_BasicGlassEffect.swift
//  LiquidGlass-Playground
//
//  Experiment #1: Basic Glass Effect
//  Learn the fundamentals of iOS 26 Liquid Glass with .glassEffect() modifier.
//

import SwiftUI

// MARK: - Basic Glass Effect Experiment

/// Demonstrates the basic .glassEffect() modifier introduced in iOS 26.
///
/// The `.glassEffect()` modifier applies Apple's new Liquid Glass material
/// to any view, creating a translucent, dynamic blur effect.
///
/// ## Key Concepts:
/// - `.glassEffect(.regular)` - Standard glass appearance
/// - `.glassEffect(.clear)` - Minimal glass effect
/// - Custom shapes with `in:` parameter
///
@available(iOS 26.0, macOS 26.0, *)
public struct Experiment01_BasicGlassEffect: View {
    
    // MARK: - State
    
    @State private var selectedVariant: GlassVariant = .regular
    @State private var showCode = false
    
    // MARK: - Types
    
    enum GlassVariant: String, CaseIterable, Identifiable {
        case regular = "Regular"
        case clear = "Clear"
        
        var id: String { rawValue }
        
        var glass: Glass {
            switch self {
            case .regular: return .regular
            case .clear: return .clear
            }
        }
    }
    
    // MARK: - Body
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                demoSection
                variantPicker
                codeSection
                explanationSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Basic Glass Effect")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.on.square.squareshape.controlhandles")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("Experiment #1")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Basic Glass Effect")
                .font(.title.bold())
                .foregroundStyle(.white)
        }
        .padding(.top, 20)
    }
    
    private var demoSection: some View {
        VStack(spacing: 20) {
            // Demo card with glass effect
            VStack(spacing: 16) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 40))
                    .foregroundStyle(.primary)
                
                Text("Liquid Glass")
                    .font(.title2.bold())
                
                Text("iOS 26's revolutionary design language")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(32)
            .glassEffect(selectedVariant.glass, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            
            // Different shapes demo
            HStack(spacing: 16) {
                // Circle
                Circle()
                    .glassEffect(.regular, in: .circle)
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "circle")
                            .font(.title2)
                    }
                
                // Capsule
                Capsule()
                    .glassEffect(.regular, in: .capsule)
                    .frame(width: 100, height: 50)
                    .overlay {
                        Text("Capsule")
                            .font(.caption.weight(.medium))
                    }
                
                // Rounded Rectangle
                RoundedRectangle(cornerRadius: 12)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 12))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "square")
                            .font(.title2)
                    }
            }
        }
    }
    
    private var variantPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Glass Variant")
                .font(.headline)
                .foregroundStyle(.white)
            
            Picker("Variant", selection: $selectedVariant) {
                ForEach(GlassVariant.allCases) { variant in
                    Text(variant.rawValue).tag(variant)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var codeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showCode.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(showCode ? 90 : 0))
                    Text("View Code")
                        .font(.headline)
                    Spacer()
                }
                .foregroundStyle(.white)
            }
            
            if showCode {
                Text(codeExample)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var explanationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How It Works")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 12) {
                explanationItem(
                    icon: "1.circle.fill",
                    title: "Apply the Modifier",
                    text: "Use .glassEffect() on any view to add the Liquid Glass material."
                )
                
                explanationItem(
                    icon: "2.circle.fill",
                    title: "Choose a Style",
                    text: "Select .regular for standard glass or .clear for minimal effect."
                )
                
                explanationItem(
                    icon: "3.circle.fill",
                    title: "Define the Shape",
                    text: "Use the 'in:' parameter to specify the glass shape."
                )
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Helpers
    
    private func explanationItem(icon: String, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.indigo, .purple, .pink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Basic Glass Effect
        Text("Hello, Glass!")
            .padding()
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
        
        // Different Shapes
        Circle()
            .glassEffect(.regular, in: .circle)
        
        Capsule()
            .glassEffect(.regular, in: .capsule)
        
        // Clear variant (minimal)
        Text("Subtle Glass")
            .glassEffect(.clear, in: .rect(cornerRadius: 12))
        """
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    NavigationStack {
        Experiment01_BasicGlassEffect()
    }
}
