//
//  Experiment09_GlassButton.swift
//  LiquidGlass-Playground
//
//  Experiment #9: Glass Button
//  Master all glass button styles and configurations.
//

import SwiftUI

// MARK: - Glass Button Experiment

/// Comprehensive guide to glass button styles in iOS 26.
///
/// iOS 26 introduces dedicated button styles for Liquid Glass:
/// - `.buttonStyle(.glass)` - Translucent glass button
/// - `.buttonStyle(.glassProminent)` - Opaque prominent glass button
///
/// ## Key Concepts:
/// - Button styles and shapes
/// - Tinting and customization
/// - Loading and disabled states
///
@available(iOS 26.0, macOS 26.0, *)
public struct Experiment09_GlassButton: View {
    
    // MARK: - State
    
    @State private var isLoading = false
    @State private var buttonCount = 0
    @State private var showCode = false
    @Namespace private var buttonNamespace
    
    // MARK: - Body
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                basicButtonsSection
                shapesSection
                tintedButtonsSection
                sizeSection
                statesSection
                iconButtonsSection
                codeSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Glass Button")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "button.horizontal.fill")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("Experiment #9")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Glass Button")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Tap count: \(buttonCount)")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .contentTransition(.numericText())
        }
        .padding(.top, 20)
    }
    
    private var basicButtonsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Button Styles")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                // Glass button
                Button {
                    buttonCount += 1
                } label: {
                    HStack {
                        Image(systemName: "hand.tap.fill")
                        Text("Glass Button")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glass)
                
                // Glass prominent button
                Button {
                    buttonCount += 1
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("Glass Prominent")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
                
                // Comparison with bordered
                Button {
                    buttonCount += 1
                } label: {
                    HStack {
                        Image(systemName: "square.fill")
                        Text("Bordered (for comparison)")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var shapesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Button Shapes")
                .font(.headline)
                .foregroundStyle(.white)
            
            GlassEffectContainer(spacing: 12) {
                HStack(spacing: 12) {
                    // Capsule
                    Button("Capsule") {
                        buttonCount += 1
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.capsule)
                    .glassEffectID("shape-capsule", in: buttonNamespace)
                    
                    // Rounded
                    Button("Rounded") {
                        buttonCount += 1
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.roundedRectangle(radius: 12))
                    .glassEffectID("shape-rounded", in: buttonNamespace)
                    
                    // Circle
                    Button {
                        buttonCount += 1
                    } label: {
                        Image(systemName: "circle")
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .glassEffectID("shape-circle", in: buttonNamespace)
                }
            }
            
            // More shapes
            HStack(spacing: 12) {
                Button("Automatic") {
                    buttonCount += 1
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.automatic)
                
                Button("Large Radius") {
                    buttonCount += 1
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.roundedRectangle(radius: 24))
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var tintedButtonsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tinted Buttons")
                .font(.headline)
                .foregroundStyle(.white)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                ForEach([
                    ("Blue", Color.blue),
                    ("Purple", Color.purple),
                    ("Pink", Color.pink),
                    ("Orange", Color.orange),
                    ("Green", Color.green),
                    ("Red", Color.red)
                ], id: \.0) { item in
                    Button(item.0) {
                        buttonCount += 1
                    }
                    .buttonStyle(.glassProminent)
                    .buttonBorderShape(.capsule)
                    .tint(item.1)
                }
            }
            
            Text("Tinted Glass (Translucent)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
            
            HStack(spacing: 8) {
                ForEach([Color.blue, .purple, .pink, .orange], id: \.self) { color in
                    Button {
                        buttonCount += 1
                    } label: {
                        Image(systemName: "paintbrush.fill")
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .tint(color)
                }
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var sizeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Button Sizes")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                // Mini
                Button("Mini") { buttonCount += 1 }
                    .buttonStyle(.glass)
                    .controlSize(.mini)
                
                // Small
                Button("Small") { buttonCount += 1 }
                    .buttonStyle(.glass)
                    .controlSize(.small)
                
                // Regular
                Button("Regular") { buttonCount += 1 }
                    .buttonStyle(.glass)
                    .controlSize(.regular)
                
                // Large
                Button("Large") { buttonCount += 1 }
                    .buttonStyle(.glass)
                    .controlSize(.large)
                
                // Extra Large
                Button("Extra Large") { buttonCount += 1 }
                    .buttonStyle(.glassProminent)
                    .controlSize(.extraLarge)
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var statesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Button States")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                // Normal
                Button {
                    buttonCount += 1
                } label: {
                    Text("Normal")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glass)
                
                // Loading
                Button {
                    // Action
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        }
                        Text(isLoading ? "Loading..." : "Tap to Load")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
                .disabled(isLoading)
                .onTapGesture {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
                
                // Disabled
                Button {
                    // Won't fire
                } label: {
                    Text("Disabled")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glass)
                .disabled(true)
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var iconButtonsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Icon Buttons")
                .font(.headline)
                .foregroundStyle(.white)
            
            GlassEffectContainer(spacing: 12) {
                HStack(spacing: 12) {
                    ForEach(["play.fill", "pause.fill", "backward.fill", "forward.fill", "shuffle"], id: \.self) { icon in
                        Button {
                            buttonCount += 1
                        } label: {
                            Image(systemName: icon)
                                .font(.title3)
                                .frame(width: 48, height: 48)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .glassEffectID("icon-\(icon)", in: buttonNamespace)
                    }
                }
            }
            
            // Action buttons
            HStack(spacing: 12) {
                Button {
                    buttonCount += 1
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.capsule)
                
                Button {
                    buttonCount += 1
                } label: {
                    Label("Save", systemImage: "bookmark")
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.capsule)
                
                Button {
                    buttonCount += 1
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.capsule)
                .tint(.red)
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
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.blue, .indigo, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Glass Button
        Button("Glass") { }
            .buttonStyle(.glass)
        
        // Glass Prominent
        Button("Prominent") { }
            .buttonStyle(.glassProminent)
        
        // Shapes
        Button("Capsule") { }
            .buttonStyle(.glass)
            .buttonBorderShape(.capsule)
        
        Button { } label: {
            Image(systemName: "plus")
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        
        // Tinted
        Button("Tinted") { }
            .buttonStyle(.glassProminent)
            .tint(.purple)
        
        // Sizes
        Button("Large") { }
            .buttonStyle(.glass)
            .controlSize(.large)
        
        // With Label
        Button { } label: {
            Label("Share", systemImage: "square.and.arrow.up")
        }
        .buttonStyle(.glass)
        """
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    NavigationStack {
        Experiment09_GlassButton()
    }
}
