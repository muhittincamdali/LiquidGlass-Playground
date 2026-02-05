//
//  Experiment02_InteractiveGlass.swift
//  LiquidGlass-Playground
//
//  Experiment #2: Interactive Glass
//  Explore .glassEffect(.regular.interactive()) for touch-responsive glass.
//

import SwiftUI

// MARK: - Interactive Glass Experiment

/// Demonstrates interactive glass effects that respond to user touch.
///
/// The `.interactive()` modifier makes glass elements respond to touches
/// with scaling, bouncing, and shimmering effects automatically.
///
/// ## Key Concepts:
/// - `.glassEffect(.regular.interactive())` - Touch-responsive glass
/// - Automatic haptic-like visual feedback
/// - Perfect for buttons and tappable elements
///
@available(iOS 26.0, macOS 26.0, *)
public struct Experiment02_InteractiveGlass: View {
    
    // MARK: - State
    
    @State private var tapCount = 0
    @State private var isInteractive = true
    @State private var showCode = false
    
    // MARK: - Body
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                interactiveDemoSection
                comparisonSection
                toggleSection
                codeSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Interactive Glass")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("Experiment #2")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Interactive Glass")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Touch-responsive Liquid Glass")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    private var interactiveDemoSection: some View {
        VStack(spacing: 20) {
            Text("Tap the buttons below")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Interactive buttons
            HStack(spacing: 16) {
                Button {
                    tapCount += 1
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.title)
                        Text("Add")
                            .font(.caption.weight(.medium))
                    }
                    .frame(width: 80, height: 80)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.roundedRectangle(radius: 20))
                
                Button {
                    tapCount = max(0, tapCount - 1)
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: "minus")
                            .font(.title)
                        Text("Remove")
                            .font(.caption.weight(.medium))
                    }
                    .frame(width: 80, height: 80)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.roundedRectangle(radius: 20))
                
                Button {
                    tapCount = 0
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title)
                        Text("Reset")
                            .font(.caption.weight(.medium))
                    }
                    .frame(width: 80, height: 80)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.roundedRectangle(radius: 20))
            }
            
            // Counter display
            Text("\(tapCount)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: tapCount)
                .padding()
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        }
    }
    
    private var comparisonSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interactive vs Static")
                .font(.headline)
                .foregroundStyle(.white)
            
            HStack(spacing: 20) {
                // Interactive
                VStack(spacing: 8) {
                    Button {
                        // Action
                    } label: {
                        Image(systemName: "hand.tap.fill")
                            .font(.largeTitle)
                            .frame(width: 100, height: 100)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    
                    Text("Interactive")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white)
                    
                    Text("Responds to touch")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Static
                VStack(spacing: 8) {
                    Image(systemName: "hand.raised.slash.fill")
                        .font(.largeTitle)
                        .frame(width: 100, height: 100)
                        .glassEffect(.regular, in: .circle)
                    
                    Text("Static")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white)
                    
                    Text("No touch response")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var toggleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Button Styles")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                // Glass button
                Button("Glass Button") {}
                    .buttonStyle(.glass)
                    .frame(maxWidth: .infinity)
                
                // Glass prominent button
                Button("Glass Prominent") {}
                    .buttonStyle(.glassProminent)
                    .frame(maxWidth: .infinity)
                
                // Tinted glass
                Button {
                    // Action
                } label: {
                    Label("Tinted Glass", systemImage: "paintbrush.fill")
                }
                .buttonStyle(.glass)
                .tint(.orange)
                .frame(maxWidth: .infinity)
            }
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
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.cyan, .blue, .indigo],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Interactive Glass Button
        Button("Tap Me") {
            // Action
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.capsule)
        
        // Prominent Glass Button
        Button("Primary Action") {
            // Action
        }
        .buttonStyle(.glassProminent)
        
        // Custom Interactive Glass
        Text("Interactive")
            .padding()
            .glassEffect(.regular.interactive(), in: .capsule)
        
        // Tinted Interactive
        Button("Tinted") { }
            .buttonStyle(.glass)
            .tint(.purple)
        """
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    NavigationStack {
        Experiment02_InteractiveGlass()
    }
}
