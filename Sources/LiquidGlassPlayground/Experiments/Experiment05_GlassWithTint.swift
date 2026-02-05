//
//  Experiment05_GlassWithTint.swift
//  LiquidGlass-Playground
//
//  Experiment #5: Glass with Tint
//  Add color personality to your glass with .tint() modifier.
//

import SwiftUI

// MARK: - Glass with Tint Experiment

/// Demonstrates tinting Liquid Glass with colors.
///
/// The `.tint()` modifier on `Glass` adds a subtle color overlay
/// to the glass effect, perfect for branding or visual hierarchy.
///
/// ## Key Concepts:
/// - `.glassEffect(.regular.tint(.color))` - Tinted glass
/// - Opacity control for subtle vs bold tints
/// - Combining tint with interactive glass
///
@available(iOS 26.0, macOS 26.0, *)
public struct Experiment05_GlassWithTint: View {
    
    // MARK: - State
    
    @State private var selectedColor: Color = .blue
    @State private var tintOpacity: Double = 0.3
    @State private var showCode = false
    
    // MARK: - Constants
    
    private let colors: [(name: String, color: Color)] = [
        ("Blue", .blue),
        ("Purple", .purple),
        ("Pink", .pink),
        ("Orange", .orange),
        ("Green", .green),
        ("Cyan", .cyan),
        ("Red", .red),
        ("Mint", .mint)
    ]
    
    // MARK: - Body
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                tintedCardDemo
                colorPicker
                opacityControl
                tintGallery
                codeSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Glass with Tint")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("Experiment #5")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Glass with Tint")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Add color to your glass elements")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    private var tintedCardDemo: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(selectedColor)
            
            Text("Tinted Glass")
                .font(.title2.bold())
            
            Text("This card uses Glass with a \(colorName(selectedColor)) tint at \(Int(tintOpacity * 100))% opacity")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .glassEffect(
            .regular.tint(selectedColor.opacity(tintOpacity)),
            in: RoundedRectangle(cornerRadius: 24)
        )
    }
    
    private var colorPicker: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Tint Color")
                .font(.headline)
                .foregroundStyle(.white)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                ForEach(colors, id: \.name) { item in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedColor = item.color
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 44, height: 44)
                                .overlay {
                                    if selectedColor == item.color {
                                        Circle()
                                            .strokeBorder(.white, lineWidth: 3)
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundStyle(.white)
                                    }
                                }
                            
                            Text(item.name)
                                .font(.caption2)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var opacityControl: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Tint Opacity")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("\(Int(tintOpacity * 100))%")
                    .font(.system(.body, design: .monospaced).weight(.semibold))
                    .foregroundStyle(selectedColor)
            }
            
            Slider(value: $tintOpacity, in: 0.1...0.8)
                .tint(selectedColor)
            
            HStack {
                Text("Subtle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Bold")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var tintGallery: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tint Gallery")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                // Row 1: Buttons
                HStack(spacing: 12) {
                    ForEach([Color.blue, Color.purple, Color.pink], id: \.self) { color in
                        Button {
                            // Action
                        } label: {
                            Image(systemName: "star.fill")
                                .font(.title2)
                                .frame(width: 56, height: 56)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .tint(color)
                    }
                }
                
                // Row 2: Cards
                HStack(spacing: 12) {
                    ForEach(colors.prefix(4), id: \.name) { item in
                        VStack(spacing: 4) {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(item.color)
                            Text(item.name)
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .glassEffect(
                            .regular.tint(item.color.opacity(0.3)),
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                    }
                }
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
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
    
    // MARK: - Helpers
    
    private func colorName(_ color: Color) -> String {
        colors.first { $0.color == color }?.name ?? "Custom"
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.gray.opacity(0.8), .black],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Tinted Glass Card
        Text("Tinted Content")
            .padding()
            .glassEffect(
                .regular.tint(.blue.opacity(0.3)),
                in: RoundedRectangle(cornerRadius: 16)
            )
        
        // Tinted Interactive Button
        Button("Action") { }
            .buttonStyle(.glass)
            .tint(.purple)
        
        // Combining tint with interactive
        Text("Interactive Tinted")
            .glassEffect(
                .regular.tint(.orange).interactive(),
                in: .capsule
            )
        
        // Multiple tinted elements
        ForEach(colors) { color in
            Circle()
                .glassEffect(
                    .regular.tint(color.opacity(0.4)),
                    in: .circle
                )
        }
        """
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    NavigationStack {
        Experiment05_GlassWithTint()
    }
}
