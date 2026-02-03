// GlassToggle.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Glass Toggle

/// A custom toggle component with Liquid Glass styling.
///
/// This toggle provides a beautiful glass-styled switch that matches
/// iOS 26's design language with smooth animations.
///
/// ## Usage
/// ```swift
/// @State private var isEnabled = false
///
/// GlassToggle(
///     isOn: $isEnabled,
///     label: "Enable Feature"
/// )
/// ```
struct GlassToggle: View {
    
    // MARK: - Properties
    
    /// The binding to the toggle's state.
    @Binding var isOn: Bool
    
    /// The label displayed next to the toggle.
    let label: String
    
    /// Optional subtitle text.
    var subtitle: String? = nil
    
    /// The color when the toggle is on.
    var onColor: Color = .accentColor
    
    /// The color when the toggle is off.
    var offColor: Color = .secondary.opacity(0.3)
    
    /// Whether haptic feedback is enabled.
    var hapticsEnabled: Bool = true
    
    /// Callback when the value changes.
    var onValueChanged: ((Bool) -> Void)? = nil
    
    // MARK: - Constants
    
    private let toggleWidth: CGFloat = 52
    private let toggleHeight: CGFloat = 32
    private let thumbSize: CGFloat = 28
    private let thumbPadding: CGFloat = 2
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 12) {
            labelSection
            
            Spacer()
            
            toggleSwitch
        }
    }
    
    // MARK: - Label Section
    
    private var labelSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.body)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    // MARK: - Toggle Switch
    
    private var toggleSwitch: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            toggleTrack
            
            toggleThumb
        }
        .frame(width: toggleWidth, height: toggleHeight)
        .onTapGesture {
            toggle()
        }
    }
    
    // MARK: - Toggle Track
    
    private var toggleTrack: some View {
        Capsule()
            .fill(isOn ? onColor : offColor)
            .overlay {
                Capsule()
                    .fill(.ultraThinMaterial.opacity(isOn ? 0.2 : 0.5))
            }
            .overlay {
                Capsule()
                    .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
            }
            .animation(.spring(duration: 0.25), value: isOn)
    }
    
    // MARK: - Toggle Thumb
    
    private var toggleThumb: some View {
        Circle()
            .fill(.white)
            .frame(width: thumbSize, height: thumbSize)
            .overlay {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white, .white.opacity(0.9)],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: thumbSize
                        )
                    )
            }
            .overlay {
                Circle()
                    .strokeBorder(.white.opacity(0.3), lineWidth: 0.5)
            }
            .shadow(color: .black.opacity(0.15), radius: 3, y: 1)
            .padding(thumbPadding)
            .animation(.spring(duration: 0.25, bounce: 0.3), value: isOn)
    }
    
    // MARK: - Methods
    
    private func toggle() {
        withAnimation {
            isOn.toggle()
        }
        
        onValueChanged?(isOn)
        
        if hapticsEnabled {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}

// MARK: - Glass Toggle Style Variants

/// A large glass toggle with icon.
struct LargeGlassToggle: View {
    
    @Binding var isOn: Bool
    let label: String
    let icon: String
    var onColor: Color = .accentColor
    
    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                isOn.toggle()
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(isOn ? onColor : .secondary)
                    .frame(width: 40)
                
                Text(label)
                    .font(.body)
                
                Spacer()
                
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isOn ? onColor : .secondary)
            }
            .padding()
            .background(isOn ? onColor.opacity(0.1) : .clear)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isOn ? onColor.opacity(0.5) : .clear, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

/// A compact glass toggle for toolbars.
struct CompactGlassToggle: View {
    
    @Binding var isOn: Bool
    let icon: String
    var size: CGFloat = 44
    var onColor: Color = .accentColor
    
    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.2)) {
                isOn.toggle()
            }
            UISelectionFeedbackGenerator().selectionChanged()
        } label: {
            Image(systemName: icon)
                .font(.system(size: size * 0.4))
                .foregroundStyle(isOn ? .white : .primary)
                .frame(width: size, height: size)
                .background(isOn ? onColor : .clear)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: size * 0.25))
                .overlay {
                    RoundedRectangle(cornerRadius: size * 0.25)
                        .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
                }
        }
        .buttonStyle(.plain)
    }
}

/// A segmented toggle group.
struct GlassSegmentedToggle<T: Hashable & CaseIterable & Identifiable>: View where T.AllCases: RandomAccessCollection {
    
    @Binding var selection: T
    let options: [T]
    let titleProvider: (T) -> String
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.id) { option in
                Button {
                    withAnimation(.spring(duration: 0.2)) {
                        selection = option
                    }
                } label: {
                    Text(titleProvider(option))
                        .font(.subheadline)
                        .fontWeight(selection.id == option.id ? .semibold : .regular)
                        .foregroundStyle(selection.id == option.id ? .primary : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(selection.id == option.id ? Color.accentColor.opacity(0.2) : .clear)
                }
                .buttonStyle(.plain)
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
        }
    }
}

/// A toggle with animated icon.
struct AnimatedGlassToggle: View {
    
    @Binding var isOn: Bool
    let onIcon: String
    let offIcon: String
    let label: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.body)
            
            Spacer()
            
            Button {
                withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                    isOn.toggle()
                }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } label: {
                ZStack {
                    Image(systemName: offIcon)
                        .opacity(isOn ? 0 : 1)
                        .scaleEffect(isOn ? 0.5 : 1)
                        .rotationEffect(.degrees(isOn ? 90 : 0))
                    
                    Image(systemName: onIcon)
                        .opacity(isOn ? 1 : 0)
                        .scaleEffect(isOn ? 1 : 0.5)
                        .rotationEffect(.degrees(isOn ? 0 : -90))
                }
                .font(.title2)
                .foregroundStyle(isOn ? .accentColor : .secondary)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Preview

#Preview("Glass Toggle") {
    VStack(spacing: 20) {
        GlassToggle(
            isOn: .constant(true),
            label: "Enable Animations"
        )
        
        GlassToggle(
            isOn: .constant(false),
            label: "Auto-Reverse",
            subtitle: "Animation will play backwards"
        )
        
        LargeGlassToggle(
            isOn: .constant(true),
            label: "Show Specular Highlights",
            icon: "sparkle"
        )
        
        HStack {
            CompactGlassToggle(
                isOn: .constant(true),
                icon: "eye.fill"
            )
            
            CompactGlassToggle(
                isOn: .constant(false),
                icon: "lock.fill"
            )
        }
        
        AnimatedGlassToggle(
            isOn: .constant(true),
            onIcon: "sun.max.fill",
            offIcon: "moon.fill",
            label: "Light Mode"
        )
    }
    .padding()
}
