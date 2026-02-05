//
//  Experiment03_MorphingGlass.swift
//  LiquidGlass-Playground
//
//  Experiment #3: Morphing Glass
//  Master GlassEffectContainer and .glassEffectID() for fluid transitions.
//

import SwiftUI

// MARK: - Morphing Glass Experiment

/// Demonstrates morphing transitions between glass elements.
///
/// `GlassEffectContainer` groups glass elements that can morph into each other.
/// Combined with `@Namespace` and `.glassEffectID()`, you can create
/// fluid, liquid-like transitions.
///
/// ## Key Concepts:
/// - `GlassEffectContainer(spacing:)` - Groups morphable glass elements
/// - `.glassEffectID(_:in:)` - Identity for morphing animations
/// - `@Namespace` - Coordinate transitions across state changes
///
@available(iOS 26.0, macOS 26.0, *)
public struct Experiment03_MorphingGlass: View {
    
    // MARK: - State
    
    @State private var isExpanded = false
    @State private var selectedItem: String? = nil
    @State private var showCode = false
    @Namespace private var morphNamespace
    
    // MARK: - Body
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                expandingMenuDemo
                selectionMorphDemo
                codeSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Morphing Glass")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("Experiment #3")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Morphing Glass")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Fluid transitions between glass states")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    private var expandingMenuDemo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Expanding Menu")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Tap the button to expand/collapse")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            // Expanding menu with morphing
            GlassEffectContainer(spacing: 12) {
                VStack(spacing: 12) {
                    // Main toggle button
                    Button {
                        withAnimation(.bouncy(duration: 0.4)) {
                            isExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: isExpanded ? "xmark" : "plus")
                            .font(.title2.weight(.semibold))
                            .frame(width: 56, height: 56)
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .buttonStyle(.glassProminent)
                    .buttonBorderShape(.circle)
                    .tint(.blue)
                    .glassEffectID("mainButton", in: morphNamespace)
                    
                    // Expandable actions
                    if isExpanded {
                        ForEach(expandableItems, id: \.icon) { item in
                            Button {
                                // Action
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: item.icon)
                                        .font(.title3)
                                    Text(item.label)
                                        .font(.subheadline.weight(.medium))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .frame(height: 48)
                            }
                            .buttonStyle(.glass)
                            .buttonBorderShape(.capsule)
                            .glassEffectID(item.icon, in: morphNamespace)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var selectionMorphDemo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Selection Morphing")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Tap items to see the selection morph")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            // Selection morphing demo
            GlassEffectContainer(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(selectionItems, id: \.self) { item in
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                selectedItem = selectedItem == item ? nil : item
                            }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: iconFor(item))
                                    .font(.title2)
                                    .symbolEffect(.bounce, value: selectedItem == item)
                                
                                Text(item)
                                    .font(.caption2.weight(.medium))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .foregroundStyle(selectedItem == item ? .white : .primary)
                        }
                        .buttonStyle(.plain)
                        .glassEffect(
                            selectedItem == item ? .regular.tint(.blue) : .clear,
                            in: RoundedRectangle(cornerRadius: 16)
                        )
                        .glassEffectID("select-\(item)", in: morphNamespace)
                    }
                }
            }
            .padding()
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
            
            // Selected item display
            if let selected = selectedItem {
                HStack {
                    Image(systemName: iconFor(selected))
                    Text("Selected: \(selected)")
                }
                .font(.subheadline.weight(.medium))
                .padding()
                .frame(maxWidth: .infinity)
                .glassEffect(.regular.tint(.green.opacity(0.3)), in: .capsule)
                .transition(.scale.combined(with: .opacity))
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
    
    // MARK: - Data
    
    private var expandableItems: [(icon: String, label: String)] {
        [
            ("camera.fill", "Camera"),
            ("photo.fill", "Photos"),
            ("doc.fill", "Files"),
            ("link", "Link")
        ]
    }
    
    private var selectionItems: [String] {
        ["Home", "Search", "Add", "Profile"]
    }
    
    private func iconFor(_ item: String) -> String {
        switch item {
        case "Home": return "house.fill"
        case "Search": return "magnifyingglass"
        case "Add": return "plus.circle.fill"
        case "Profile": return "person.fill"
        default: return "circle"
        }
    }
    
    // MARK: - Helpers
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.purple, .pink, .orange],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        @Namespace private var namespace
        @State private var isExpanded = false
        
        GlassEffectContainer(spacing: 12) {
            // Main button
            Button {
                withAnimation(.bouncy) {
                    isExpanded.toggle()
                }
            } label: {
                Image(systemName: isExpanded ? "xmark" : "plus")
                    .frame(width: 56, height: 56)
            }
            .buttonStyle(.glassProminent)
            .glassEffectID("main", in: namespace)
            
            // Expandable items
            if isExpanded {
                ForEach(items, id: \\.self) { item in
                    Button(item) { }
                        .buttonStyle(.glass)
                        .glassEffectID(item, in: namespace)
                }
            }
        }
        """
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    NavigationStack {
        Experiment03_MorphingGlass()
    }
}
