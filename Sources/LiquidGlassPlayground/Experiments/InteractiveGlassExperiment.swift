// InteractiveGlassExperiment.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Interactive Glass Experiment

/// An experiment demonstrating touch-responsive glass effects.
///
/// This experiment shows how to create glass interfaces that respond
/// to user gestures with smooth, delightful interactions.
///
/// ## Features
/// - Tap interactions
/// - Drag gestures
/// - Long press effects
/// - Haptic feedback integration
struct InteractiveGlassExperiment: View {
    
    // MARK: - Properties
    
    @Binding var parameters: GlassParameters
    @EnvironmentObject private var appState: AppState
    @State private var selectedInteraction: InteractionType = .tap
    @State private var interactionState = InteractionState()
    @State private var showHapticSettings = false
    @GestureState private var dragOffset: CGSize = .zero
    @GestureState private var isPressing = false
    @GestureState private var magnification: CGFloat = 1.0
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                interactionPreview
                
                interactionSelector
                
                interactionControls
                
                gestureGuide
                
                hapticSettings
            }
            .padding()
        }
        .navigationTitle("Interactive Glass")
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "hand.tap.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.cyan.gradient)
                
                VStack(alignment: .leading) {
                    Text("Interactive Glass Effects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Touch-responsive interfaces")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Build engaging glass interfaces that respond to touch. Combine gestures with visual feedback for delightful user experiences.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.glassEffect)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Interaction Preview
    
    private var interactionPreview: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Try It!")
                    .font(.headline)
                
                Spacer()
                
                Text(interactionHint)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            ZStack {
                interactiveBackground
                
                interactiveGlassElement
            }
            .frame(height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var interactiveBackground: some View {
        ZStack {
            LinearGradient(
                colors: [.teal, .cyan, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<6) { index in
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .offset(
                        x: CGFloat.random(in: -100...100),
                        y: CGFloat.random(in: -140...140)
                    )
                    .blur(radius: 30)
            }
        }
    }
    
    private var interactiveGlassElement: some View {
        let scale = computeScale()
        let offset = computeOffset()
        let cornerRadius = computeCornerRadius()
        let tintOpacity = computeTintOpacity()
        
        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(parameters.tintColor.color.opacity(tintOpacity))
            }
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: selectedInteraction.systemImage)
                        .font(.largeTitle)
                        .rotationEffect(.degrees(interactionState.rotation))
                    
                    Text(selectedInteraction.displayName)
                        .font(.headline)
                    
                    Text(interactionState.feedbackText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .animation(.none, value: interactionState.feedbackText)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        .linearGradient(
                            colors: [.white.opacity(0.6), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: parameters.borderWidth
                    )
            }
            .frame(width: 200, height: 180)
            .scaleEffect(scale)
            .offset(offset)
            .shadow(
                color: .black.opacity(interactionState.isActive ? 0.3 : 0.15),
                radius: interactionState.isActive ? 20 : parameters.shadowRadius,
                y: interactionState.isActive ? 10 : 5
            )
            .animation(.spring(duration: 0.3), value: interactionState.isActive)
            .gesture(currentGesture)
    }
    
    // MARK: - Computed Values
    
    private func computeScale() -> CGFloat {
        switch selectedInteraction {
        case .tap:
            return interactionState.isActive ? 0.95 : 1.0
        case .longPress:
            return isPressing ? 0.9 : 1.0
        case .drag:
            return 1.0
        case .pinch:
            return magnification
        case .rotation:
            return 1.0
        case .combined:
            return magnification * (interactionState.isActive ? 0.95 : 1.0)
        }
    }
    
    private func computeOffset() -> CGSize {
        switch selectedInteraction {
        case .drag, .combined:
            return CGSize(
                width: dragOffset.width + interactionState.offset.width,
                height: dragOffset.height + interactionState.offset.height
            )
        default:
            return .zero
        }
    }
    
    private func computeCornerRadius() -> Double {
        switch selectedInteraction {
        case .longPress:
            return isPressing ? parameters.cornerRadius + 10 : parameters.cornerRadius
        default:
            return parameters.cornerRadius
        }
    }
    
    private func computeTintOpacity() -> Double {
        switch selectedInteraction {
        case .tap:
            return interactionState.isActive ? parameters.tintOpacity * 1.5 : parameters.tintOpacity
        case .longPress:
            return isPressing ? parameters.tintOpacity * 2 : parameters.tintOpacity
        default:
            return parameters.tintOpacity
        }
    }
    
    // MARK: - Gestures
    
    private var currentGesture: some Gesture {
        switch selectedInteraction {
        case .tap:
            return AnyGesture(tapGesture.map { _ in () })
        case .longPress:
            return AnyGesture(longPressGesture.map { _ in () })
        case .drag:
            return AnyGesture(dragGesture.map { _ in () })
        case .pinch:
            return AnyGesture(pinchGesture.map { _ in () })
        case .rotation:
            return AnyGesture(rotationGesture.map { _ in () })
        case .combined:
            return AnyGesture(combinedGesture.map { _ in () })
        }
    }
    
    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                withAnimation(.spring(duration: 0.2)) {
                    interactionState.isActive = true
                    interactionState.tapCount += 1
                    interactionState.feedbackText = "Tap #\(interactionState.tapCount)"
                }
                provideHaptic(.impact(.light))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation {
                        interactionState.isActive = false
                    }
                }
            }
    }
    
    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.5)
            .updating($isPressing) { currentState, gestureState, _ in
                gestureState = currentState
                if currentState {
                    interactionState.feedbackText = "Pressing..."
                }
            }
            .onEnded { _ in
                interactionState.feedbackText = "Long press detected!"
                interactionState.longPressCount += 1
                provideHaptic(.notification(.success))
            }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation
                interactionState.feedbackText = "Dragging..."
            }
            .onEnded { value in
                interactionState.offset.width += value.translation.width
                interactionState.offset.height += value.translation.height
                interactionState.feedbackText = "Dropped!"
                provideHaptic(.impact(.medium))
            }
    }
    
    private var pinchGesture: some Gesture {
        MagnifyGesture()
            .updating($magnification) { value, state, _ in
                state = value.magnification
                interactionState.feedbackText = String(format: "Scale: %.2fx", value.magnification)
            }
            .onEnded { _ in
                interactionState.feedbackText = "Pinch complete"
                provideHaptic(.impact(.light))
            }
    }
    
    private var rotationGesture: some Gesture {
        RotateGesture()
            .onChanged { value in
                interactionState.rotation = value.rotation.degrees
                interactionState.feedbackText = String(format: "%.0f°", value.rotation.degrees)
            }
            .onEnded { _ in
                interactionState.feedbackText = "Rotation complete"
                provideHaptic(.impact(.light))
            }
    }
    
    private var combinedGesture: some Gesture {
        SimultaneousGesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    interactionState.offset.width += value.translation.width
                    interactionState.offset.height += value.translation.height
                },
            MagnifyGesture()
                .updating($magnification) { value, state, _ in
                    state = value.magnification
                }
        )
    }
    
    private var interactionHint: String {
        switch selectedInteraction {
        case .tap: return "Tap the glass"
        case .longPress: return "Press and hold"
        case .drag: return "Drag to move"
        case .pinch: return "Pinch to scale"
        case .rotation: return "Rotate with two fingers"
        case .combined: return "Try multiple gestures"
        }
    }
    
    // MARK: - Interaction Selector
    
    private var interactionSelector: some View {
        VStack(spacing: 12) {
            Text("Interaction Type")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(InteractionType.allCases) { interaction in
                    InteractionButton(
                        interaction: interaction,
                        isSelected: selectedInteraction == interaction
                    ) {
                        withAnimation {
                            selectedInteraction = interaction
                            resetInteractionState()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Interaction Controls
    
    private var interactionControls: some View {
        VStack(spacing: 16) {
            Text("Visual Feedback")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                GlassSlider(
                    value: $parameters.cornerRadius,
                    range: 0...50,
                    label: "Corner Radius",
                    format: "%.0f"
                )
                
                GlassSlider(
                    value: $parameters.tintOpacity,
                    range: 0...1,
                    label: "Tint Opacity",
                    format: "%.2f"
                )
                
                GlassSlider(
                    value: $parameters.shadowRadius,
                    range: 0...30,
                    label: "Shadow Radius",
                    format: "%.0f"
                )
                
                Button("Reset Position") {
                    withAnimation(.spring) {
                        resetInteractionState()
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Gesture Guide
    
    private var gestureGuide: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Gesture Guide")
                .font(.headline)
            
            VStack(spacing: 12) {
                GestureGuideRow(
                    gesture: "Tap",
                    description: "Quick touch for selection feedback",
                    icon: "hand.tap"
                )
                
                GestureGuideRow(
                    gesture: "Long Press",
                    description: "Hold for contextual actions",
                    icon: "hand.point.down"
                )
                
                GestureGuideRow(
                    gesture: "Drag",
                    description: "Move elements around the screen",
                    icon: "arrow.up.and.down.and.arrow.left.and.right"
                )
                
                GestureGuideRow(
                    gesture: "Pinch",
                    description: "Scale elements larger or smaller",
                    icon: "arrow.up.left.and.arrow.down.right"
                )
                
                GestureGuideRow(
                    gesture: "Rotation",
                    description: "Rotate with two-finger twist",
                    icon: "arrow.triangle.2.circlepath"
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Haptic Settings
    
    private var hapticSettings: some View {
        VStack(spacing: 12) {
            Button {
                showHapticSettings.toggle()
            } label: {
                HStack {
                    Label("Haptic Feedback", systemImage: "iphone.radiowaves.left.and.right")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: showHapticSettings ? "chevron.up" : "chevron.down")
                }
            }
            .buttonStyle(.plain)
            
            if showHapticSettings {
                VStack(spacing: 16) {
                    GlassToggle(
                        isOn: $appState.hapticsEnabled,
                        label: "Enable Haptics"
                    )
                    
                    Text("Haptic feedback provides tactile responses to user interactions, making the interface feel more responsive.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 12) {
                        HapticTestButton(style: .light, label: "Light")
                        HapticTestButton(style: .medium, label: "Medium")
                        HapticTestButton(style: .heavy, label: "Heavy")
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Methods
    
    private func resetInteractionState() {
        interactionState = InteractionState()
    }
    
    private func provideHaptic(_ type: HapticFeedbackType) {
        appState.provideHapticFeedback(type)
    }
}

// MARK: - Interaction Type

enum InteractionType: String, CaseIterable, Identifiable {
    case tap
    case longPress
    case drag
    case pinch
    case rotation
    case combined
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .tap: return "Tap"
        case .longPress: return "Long Press"
        case .drag: return "Drag"
        case .pinch: return "Pinch"
        case .rotation: return "Rotation"
        case .combined: return "Combined"
        }
    }
    
    var systemImage: String {
        switch self {
        case .tap: return "hand.tap"
        case .longPress: return "hand.point.down.fill"
        case .drag: return "arrow.up.and.down.and.arrow.left.and.right"
        case .pinch: return "arrow.up.left.and.arrow.down.right"
        case .rotation: return "arrow.triangle.2.circlepath"
        case .combined: return "hand.draw"
        }
    }
}

// MARK: - Interaction State

struct InteractionState {
    var isActive = false
    var tapCount = 0
    var longPressCount = 0
    var offset: CGSize = .zero
    var rotation: Double = 0
    var feedbackText = "Interact with the glass"
}

// MARK: - Interaction Button

struct InteractionButton: View {
    let interaction: InteractionType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: interaction.systemImage)
                    .font(.title3)
                
                Text(interaction.displayName)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.accentColor.opacity(0.2) : .clear)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Gesture Guide Row

struct GestureGuideRow: View {
    let gesture: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.cyan)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(gesture)
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

// MARK: - Haptic Test Button

struct HapticTestButton: View {
    let style: UIImpactFeedbackGenerator.FeedbackStyle
    let label: String
    
    var body: some View {
        Button(label) {
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        }
        .buttonStyle(.bordered)
        .font(.caption)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        InteractiveGlassExperiment(parameters: .constant(GlassParameters()))
            .environmentObject(AppState())
    }
}
