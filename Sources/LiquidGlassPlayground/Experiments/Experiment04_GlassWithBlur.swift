//
//  Experiment04_GlassWithBlur.swift
//  LiquidGlass-Playground
//
//  Experiment #4: Glass with Blur
//  Understand how Liquid Glass interacts with blur and materials.
//

import SwiftUI

// MARK: - Glass with Blur Experiment

/// Explores the relationship between Liquid Glass and blur effects.
///
/// iOS 26 Liquid Glass automatically handles blur based on the
/// underlying content. This experiment shows how glass adapts
/// to different backgrounds and blur intensities.
///
/// ## Key Concepts:
/// - Glass naturally blurs background content
/// - Combining with `.blur()` for additional effects
/// - Material comparison: Glass vs traditional materials
///
@available(iOS 26.0, macOS 26.0, *)
public struct Experiment04_GlassWithBlur: View {
    
    // MARK: - State
    
    @State private var blurAmount: Double = 0
    @State private var backgroundIndex = 0
    @State private var showCode = false
    
    // MARK: - Constants
    
    private let backgrounds: [(name: String, colors: [Color])] = [
        ("Sunset", [.orange, .pink, .purple]),
        ("Ocean", [.cyan, .blue, .indigo]),
        ("Forest", [.green, .teal, .mint]),
        ("Night", [.indigo, .purple, .black])
    ]
    
    // MARK: - Body
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                liveBlurDemo
                materialComparison
                blurControlSection
                codeSection
            }
            .padding()
        }
        .background(currentBackground)
        .navigationTitle("Glass with Blur")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "aqi.medium")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("Experiment #4")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Glass with Blur")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Explore blur depth and intensity")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    private var liveBlurDemo: some View {
        VStack(spacing: 20) {
            // Sample content behind glass
            ZStack {
                // Background content
                VStack(spacing: 12) {
                    Image(systemName: "photo.artframe")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                    
                    Text("Background Content")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.white.opacity(0.5))
                                .frame(width: 40, height: 8)
                        }
                    }
                }
                .padding(40)
                .blur(radius: blurAmount)
                
                // Glass overlay
                VStack(spacing: 12) {
                    Text("Glass Overlay")
                        .font(.headline)
                    
                    Text("Blur: \(Int(blurAmount))")
                        .font(.system(.title, design: .rounded).weight(.bold))
                    
                    Text("Adjust the slider below")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(24)
                .frame(width: 200)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
            }
            .frame(height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Blur slider
            VStack(alignment: .leading, spacing: 8) {
                Text("Additional Blur: \(Int(blurAmount))")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white)
                
                Slider(value: $blurAmount, in: 0...30)
                    .tint(.white)
            }
            .padding()
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var materialComparison: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Glass vs Materials")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Compare Liquid Glass with traditional materials")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                // Liquid Glass
                VStack(spacing: 8) {
                    Text("Content")
                        .font(.caption)
                    Image(systemName: "sparkles")
                        .font(.title)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                .overlay(alignment: .bottom) {
                    Text("Glass")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.blue)
                        .clipShape(Capsule())
                        .offset(y: 12)
                }
                
                // Ultra Thin Material
                VStack(spacing: 8) {
                    Text("Content")
                        .font(.caption)
                    Image(systemName: "sparkles")
                        .font(.title)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .overlay(alignment: .bottom) {
                    Text("Ultra Thin")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.orange)
                        .clipShape(Capsule())
                        .offset(y: 12)
                }
                
                // Regular Material
                VStack(spacing: 8) {
                    Text("Content")
                        .font(.caption)
                    Image(systemName: "sparkles")
                        .font(.title)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                .overlay(alignment: .bottom) {
                    Text("Regular")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.green)
                        .clipShape(Capsule())
                        .offset(y: 12)
                }
            }
            .padding(.bottom, 16)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var blurControlSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Background")
                .font(.headline)
                .foregroundStyle(.white)
            
            // Background picker
            HStack(spacing: 8) {
                ForEach(0..<backgrounds.count, id: \.self) { index in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            backgroundIndex = index
                        }
                    } label: {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: backgrounds[index].colors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .overlay {
                                if backgroundIndex == index {
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 3)
                                }
                            }
                    }
                }
            }
            
            Text("Selected: \(backgrounds[backgroundIndex].name)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
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
    
    private var currentBackground: some View {
        LinearGradient(
            colors: backgrounds[backgroundIndex].colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Glass with natural blur
        Text("Content")
            .padding()
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
        
        // Adding extra blur to background
        ZStack {
            Image("background")
                .blur(radius: 10)
            
            Text("Overlay")
                .glassEffect(.regular, in: .capsule)
        }
        
        // Comparing with traditional materials
        Text("Ultra Thin")
            .background(.ultraThinMaterial)
        
        Text("Glass Effect")
            .glassEffect(.regular, in: .rect)
        """
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    NavigationStack {
        Experiment04_GlassWithBlur()
    }
}
