// LayeredGlassExperiment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Layered Glass Experiment

/// An experiment demonstrating multi-layered glass effects with depth.
///
/// This experiment shows how to create sophisticated depth effects
/// by stacking multiple glass layers with varying properties.
///
/// ## Features
/// - Multiple glass layers
/// - Z-depth control
/// - Parallax effects
/// - Layer blending
struct LayeredGlassExperiment: View {
    
    // MARK: - Properties
    
    @Binding var parameters: GlassParameters
    @EnvironmentObject private var appState: AppState
    @State private var layers: [GlassLayer] = GlassLayer.defaultLayers
    @State private var selectedLayerIndex: Int = 0
    @State private var showLayerEditor = false
    @State private var parallaxOffset: CGSize = .zero
    @State private var enableParallax = true
    @State private var layerSpacing: CGFloat = 20
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                layeredPreview
                
                layerControls
                
                globalControls
                
                depthTechniques
            }
            .padding()
        }
        .navigationTitle("Layered Glass")
        .sheet(isPresented: $showLayerEditor) {
            LayerEditorSheet(
                layer: $layers[selectedLayerIndex],
                onDelete: {
                    layers.remove(at: selectedLayerIndex)
                    selectedLayerIndex = max(0, selectedLayerIndex - 1)
                    showLayerEditor = false
                }
            )
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "square.3.layers.3d")
                    .font(.largeTitle)
                    .foregroundStyle(.green.gradient)
                
                VStack(alignment: .leading) {
                    Text("Layered Glass Effects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Create depth with layers")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Stack multiple glass layers to create rich, dimensional interfaces. Each layer can have unique blur, tint, and positioning properties.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.glassEffect)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Layered Preview
    
    private var layeredPreview: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Live Preview")
                    .font(.headline)
                
                Spacer()
                
                Toggle("Parallax", isOn: $enableParallax)
                    .toggleStyle(.button)
            }
            
            GeometryReader { geometry in
                ZStack {
                    backgroundGradient
                    
                    layeredGlassStack
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if enableParallax {
                                withAnimation(.interactiveSpring) {
                                    parallaxOffset = CGSize(
                                        width: value.translation.width * 0.1,
                                        height: value.translation.height * 0.1
                                    )
                                }
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.spring) {
                                parallaxOffset = .zero
                            }
                        }
                )
            }
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var backgroundGradient: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<6) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.4), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .offset(
                        x: CGFloat.random(in: -100...100),
                        y: CGFloat.random(in: -150...150)
                    )
                    .blur(radius: 20)
            }
        }
    }
    
    private var layeredGlassStack: some View {
        ZStack {
            ForEach(layers.indices, id: \.self) { index in
                let layer = layers[index]
                let parallaxMultiplier = CGFloat(index + 1) * 0.3
                
                GlassLayerView(
                    layer: layer,
                    isSelected: selectedLayerIndex == index
                )
                .offset(
                    x: enableParallax ? parallaxOffset.width * parallaxMultiplier : 0,
                    y: enableParallax ? parallaxOffset.height * parallaxMultiplier : 0
                )
                .offset(y: CGFloat(index) * -layerSpacing)
                .zIndex(Double(index))
                .onTapGesture {
                    selectedLayerIndex = index
                    showLayerEditor = true
                }
            }
        }
    }
    
    // MARK: - Layer Controls
    
    private var layerControls: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Layers (\(layers.count))")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    addNewLayer()
                } label: {
                    Label("Add Layer", systemImage: "plus.circle.fill")
                }
                .disabled(layers.count >= 5)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(layers.indices, id: \.self) { index in
                        LayerThumbnail(
                            layer: layers[index],
                            index: index,
                            isSelected: selectedLayerIndex == index
                        ) {
                            selectedLayerIndex = index
                        }
                    }
                }
            }
            
            if !layers.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected: \(layers[selectedLayerIndex].name)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    HStack {
                        Button("Edit") {
                            showLayerEditor = true
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Move Up") {
                            moveLayerUp()
                        }
                        .buttonStyle(.bordered)
                        .disabled(selectedLayerIndex >= layers.count - 1)
                        
                        Button("Move Down") {
                            moveLayerDown()
                        }
                        .buttonStyle(.bordered)
                        .disabled(selectedLayerIndex <= 0)
                        
                        Spacer()
                        
                        Button("Delete", role: .destructive) {
                            deleteSelectedLayer()
                        }
                        .buttonStyle(.bordered)
                        .disabled(layers.count <= 1)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Global Controls
    
    private var globalControls: some View {
        VStack(spacing: 16) {
            Text("Global Settings")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                GlassSlider(
                    value: $layerSpacing,
                    range: 0...50,
                    label: "Layer Spacing",
                    format: "%.0f"
                )
                
                GlassToggle(
                    isOn: $enableParallax,
                    label: "Enable Parallax Effect"
                )
                
                if enableParallax {
                    Text("Drag on the preview to see parallax motion")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Depth Techniques
    
    private var depthTechniques: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Depth Techniques")
                .font(.headline)
            
            VStack(spacing: 12) {
                TechniqueRow(
                    title: "Blur Graduation",
                    description: "Increase blur on distant layers",
                    icon: "circle.hexagongrid.fill"
                )
                
                TechniqueRow(
                    title: "Size Scaling",
                    description: "Smaller elements appear further away",
                    icon: "arrow.down.right.and.arrow.up.left"
                )
                
                TechniqueRow(
                    title: "Opacity Fading",
                    description: "Reduce opacity for background layers",
                    icon: "sun.haze.fill"
                )
                
                TechniqueRow(
                    title: "Parallax Motion",
                    description: "Move layers at different speeds",
                    icon: "arrow.left.and.right"
                )
                
                TechniqueRow(
                    title: "Shadow Casting",
                    description: "Add shadows between layers",
                    icon: "shadow"
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Methods
    
    private func addNewLayer() {
        let newLayer = GlassLayer(
            id: UUID(),
            name: "Layer \(layers.count + 1)",
            blurRadius: 20,
            tintColor: CodableColor(.blue.opacity(0.1)),
            cornerRadius: 16,
            size: CGSize(width: 180, height: 140),
            offset: CGSize(width: 0, height: 0)
        )
        layers.append(newLayer)
        selectedLayerIndex = layers.count - 1
    }
    
    private func moveLayerUp() {
        guard selectedLayerIndex < layers.count - 1 else { return }
        layers.swapAt(selectedLayerIndex, selectedLayerIndex + 1)
        selectedLayerIndex += 1
    }
    
    private func moveLayerDown() {
        guard selectedLayerIndex > 0 else { return }
        layers.swapAt(selectedLayerIndex, selectedLayerIndex - 1)
        selectedLayerIndex -= 1
    }
    
    private func deleteSelectedLayer() {
        guard layers.count > 1 else { return }
        layers.remove(at: selectedLayerIndex)
        selectedLayerIndex = min(selectedLayerIndex, layers.count - 1)
    }
}

// MARK: - Glass Layer Model

struct GlassLayer: Identifiable {
    let id: UUID
    var name: String
    var blurRadius: Double
    var tintColor: CodableColor
    var cornerRadius: Double
    var size: CGSize
    var offset: CGSize
    var opacity: Double = 1.0
    var borderWidth: Double = 0.5
    
    static var defaultLayers: [GlassLayer] {
        [
            GlassLayer(
                id: UUID(),
                name: "Background",
                blurRadius: 30,
                tintColor: CodableColor(.purple.opacity(0.1)),
                cornerRadius: 24,
                size: CGSize(width: 240, height: 180),
                offset: CGSize(width: 0, height: 0),
                opacity: 0.7
            ),
            GlassLayer(
                id: UUID(),
                name: "Middle",
                blurRadius: 20,
                tintColor: CodableColor(.blue.opacity(0.15)),
                cornerRadius: 20,
                size: CGSize(width: 200, height: 150),
                offset: CGSize(width: 0, height: 0),
                opacity: 0.85
            ),
            GlassLayer(
                id: UUID(),
                name: "Foreground",
                blurRadius: 10,
                tintColor: CodableColor(.cyan.opacity(0.1)),
                cornerRadius: 16,
                size: CGSize(width: 160, height: 120),
                offset: CGSize(width: 0, height: 0),
                opacity: 1.0
            )
        ]
    }
}

// MARK: - Glass Layer View

struct GlassLayerView: View {
    let layer: GlassLayer
    let isSelected: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: layer.cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: layer.cornerRadius)
                    .fill(layer.tintColor.color)
            }
            .overlay {
                VStack {
                    Text(layer.name)
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: layer.cornerRadius)
                    .strokeBorder(
                        isSelected ? Color.accentColor : .white.opacity(0.3),
                        lineWidth: isSelected ? 2 : layer.borderWidth
                    )
            }
            .frame(width: layer.size.width, height: layer.size.height)
            .opacity(layer.opacity)
            .shadow(radius: 8)
            .offset(layer.offset)
    }
}

// MARK: - Layer Thumbnail

struct LayerThumbnail: View {
    let layer: GlassLayer
    let index: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(layer.tintColor.color)
                    }
                    .frame(width: 60, height: 45)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 2)
                    }
                
                Text(layer.name)
                    .font(.caption2)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Layer Editor Sheet

struct LayerEditorSheet: View {
    @Binding var layer: GlassLayer
    let onDelete: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Properties") {
                    TextField("Name", text: $layer.name)
                    
                    GlassSlider(
                        value: $layer.blurRadius,
                        range: 0...50,
                        label: "Blur Radius",
                        format: "%.0f"
                    )
                    
                    GlassSlider(
                        value: $layer.cornerRadius,
                        range: 0...50,
                        label: "Corner Radius",
                        format: "%.0f"
                    )
                    
                    GlassSlider(
                        value: $layer.opacity,
                        range: 0...1,
                        label: "Opacity",
                        format: "%.2f"
                    )
                }
                
                Section("Size") {
                    GlassSlider(
                        value: Binding(
                            get: { layer.size.width },
                            set: { layer.size.width = $0 }
                        ),
                        range: 80...300,
                        label: "Width",
                        format: "%.0f"
                    )
                    
                    GlassSlider(
                        value: Binding(
                            get: { layer.size.height },
                            set: { layer.size.height = $0 }
                        ),
                        range: 60...250,
                        label: "Height",
                        format: "%.0f"
                    )
                }
                
                Section("Tint") {
                    ColorPicker("Color", selection: Binding(
                        get: { layer.tintColor.color },
                        set: { layer.tintColor = CodableColor($0) }
                    ))
                }
                
                Section {
                    Button("Delete Layer", role: .destructive, action: onDelete)
                }
            }
            .navigationTitle("Edit Layer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Technique Row

struct TechniqueRow: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LayeredGlassExperiment(parameters: .constant(GlassParameters()))
            .environmentObject(AppState())
    }
}
