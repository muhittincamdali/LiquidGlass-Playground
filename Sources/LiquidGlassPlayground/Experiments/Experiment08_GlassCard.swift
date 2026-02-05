//
//  Experiment08_GlassCard.swift
//  LiquidGlass-Playground
//
//  Experiment #8: Glass Card
//  Design beautiful content cards with Liquid Glass effects.
//

import SwiftUI

// MARK: - Glass Card Experiment

/// Demonstrates creating content cards with Liquid Glass.
///
/// Glass cards are perfect for displaying content in a visually
/// appealing way while maintaining readability. This experiment
/// shows various card patterns and layouts.
///
/// ## Key Concepts:
/// - Card layouts with glass backgrounds
/// - Nested glass elements
/// - Combining glass with images and text
///
@available(iOS 26.0, macOS 26.0, *)
public struct Experiment08_GlassCard: View {
    
    // MARK: - State
    
    @State private var isLiked = false
    @State private var showCode = false
    @Namespace private var cardNamespace
    
    // MARK: - Body
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                simpleCard
                imageCard
                statsCard
                socialCard
                listCard
                codeSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Glass Card")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("Experiment #8")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Glass Card")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Beautiful content containers")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    private var simpleCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Simple Card")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                    
                    Text("Featured")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.yellow)
                }
                
                Text("Glass Card Title")
                    .font(.title2.bold())
                
                Text("This is a simple glass card demonstrating how content can be displayed with the Liquid Glass effect.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Button("Learn More") {}
                    .buttonStyle(.glass)
                    .buttonBorderShape(.capsule)
                    .tint(.blue)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        }
    }
    
    private var imageCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Image Card")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(spacing: 0) {
                // Image placeholder
                ZStack {
                    LinearGradient(
                        colors: [.purple, .pink, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    Image(systemName: "photo.artframe")
                        .font(.system(size: 48))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .frame(height: 180)
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 24,
                    topTrailingRadius: 24
                ))
                
                // Card content
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Mountain Sunrise")
                                .font(.headline)
                            
                            Text("Photography • 2 hours ago")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                isLiked.toggle()
                            }
                        } label: {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundStyle(isLiked ? .red : .secondary)
                                .symbolEffect(.bounce, value: isLiked)
                        }
                    }
                    
                    Text("A beautiful morning captured at the peak. The colors were absolutely stunning.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(16)
                .glassEffect(.regular, in: UnevenRoundedRectangle(
                    bottomLeadingRadius: 24,
                    bottomTrailingRadius: 24
                ))
            }
        }
    }
    
    private var statsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stats Card")
                .font(.headline)
                .foregroundStyle(.white)
            
            GlassEffectContainer(spacing: 12) {
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title2)
                            .foregroundStyle(.green)
                        
                        Text("Performance")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("+24%")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.green)
                    }
                    
                    HStack(spacing: 12) {
                        statItem(value: "2.4K", label: "Views", icon: "eye.fill", color: .blue)
                        statItem(value: "186", label: "Likes", icon: "heart.fill", color: .pink)
                        statItem(value: "42", label: "Shares", icon: "arrow.turn.up.right", color: .orange)
                    }
                }
                .padding(20)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
            }
        }
    }
    
    private func statItem(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            
            Text(value)
                .font(.title3.bold())
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .glassEffect(.regular.tint(color.opacity(0.15)), in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var socialCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Social Card")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 16) {
                // Author row
                HStack(spacing: 12) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                        .overlay {
                            Text("JD")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("John Doe")
                            .font(.subheadline.weight(.semibold))
                        
                        Text("@johndoe • 5m")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        // Menu
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                }
                
                // Content
                Text("Just shipped an amazing feature using Liquid Glass in iOS 26! The translucent effects are absolutely stunning. 🚀✨")
                    .font(.body)
                
                // Actions
                GlassEffectContainer(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach([
                            ("heart", "42"),
                            ("bubble.right", "12"),
                            ("arrow.2.squarepath", "8"),
                            ("square.and.arrow.up", "")
                        ], id: \.0) { item in
                            Button {
                                // Action
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: item.0)
                                    if !item.1.isEmpty {
                                        Text(item.1)
                                            .font(.caption)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.glass)
                            .buttonBorderShape(.capsule)
                            .glassEffectID("social-\(item.0)", in: cardNamespace)
                        }
                    }
                }
            }
            .padding(20)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        }
    }
    
    private var listCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("List Card")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    HStack(spacing: 12) {
                        Image(systemName: listIcons[index])
                            .font(.title2)
                            .foregroundStyle(listColors[index])
                            .frame(width: 40)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(listTitles[index])
                                .font(.subheadline.weight(.medium))
                            
                            Text(listSubtitles[index])
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(16)
                    
                    if index < 3 {
                        Divider()
                            .overlay(Color.white.opacity(0.1))
                            .padding(.leading, 68)
                    }
                }
            }
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var listIcons: [String] {
        ["bell.badge.fill", "person.2.fill", "gearshape.fill", "questionmark.circle.fill"]
    }
    
    private var listColors: [Color] {
        [.red, .blue, .gray, .orange]
    }
    
    private var listTitles: [String] {
        ["Notifications", "Friends", "Settings", "Help & Support"]
    }
    
    private var listSubtitles: [String] {
        ["3 new alerts", "24 online", "Customize app", "Get assistance"]
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
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.orange, .pink, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Simple Glass Card
        VStack(alignment: .leading, spacing: 12) {
            Text("Card Title")
                .font(.title2.bold())
            
            Text("Card description here...")
                .foregroundStyle(.secondary)
            
            Button("Action") { }
                .buttonStyle(.glass)
        }
        .padding(20)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        
        // Image Card
        VStack(spacing: 0) {
            Image("photo")
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 24,
                    topTrailingRadius: 24
                ))
            
            VStack { /* content */ }
                .glassEffect(.regular, in: UnevenRoundedRectangle(
                    bottomLeadingRadius: 24,
                    bottomTrailingRadius: 24
                ))
        }
        """
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    NavigationStack {
        Experiment08_GlassCard()
    }
}
