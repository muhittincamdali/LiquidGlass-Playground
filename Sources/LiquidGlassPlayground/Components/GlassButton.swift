// GlassButton.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Glass Button

/// A button component with Liquid Glass styling.
///
/// Glass buttons provide beautiful, tactile controls that match
/// iOS 26's design language with support for various styles.
///
/// ## Usage
/// ```swift
/// GlassButton("Submit") {
///     submitForm()
/// }
/// ```
struct GlassButton: View {
    
    // MARK: - Properties
    
    let title: String
    let icon: String?
    let style: GlassButtonStyle
    let action: () -> Void
    
    @State private var isPressed = false
    
    // MARK: - Initialization
    
    init(
        _ title: String,
        icon: String? = nil,
        style: GlassButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: performAction) {
            buttonContent
        }
        .buttonStyle(GlassButtonPressStyle(style: style))
    }
    
    // MARK: - Button Content
    
    private var buttonContent: some View {
        HStack(spacing: 8) {
            if let icon = icon {
                Image(systemName: icon)
            }
            
            Text(title)
                .fontWeight(.semibold)
        }
        .font(.body)
        .foregroundStyle(style.foregroundColor)
        .padding(.horizontal, style.horizontalPadding)
        .padding(.vertical, style.verticalPadding)
        .frame(maxWidth: style == .fullWidth ? .infinity : nil)
        .background {
            style.background
        }
        .clipShape(style.shape)
        .overlay {
            style.border
        }
    }
    
    // MARK: - Methods
    
    private func performAction() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        action()
    }
}

// MARK: - Glass Button Style

/// The available styles for glass buttons.
enum GlassButtonStyle {
    case primary
    case secondary
    case tertiary
    case destructive
    case fullWidth
    case compact
    case icon
    
    var foregroundColor: Color {
        switch self {
        case .primary: return .white
        case .secondary: return .primary
        case .tertiary: return .accentColor
        case .destructive: return .white
        case .fullWidth: return .white
        case .compact: return .primary
        case .icon: return .primary
        }
    }
    
    @ViewBuilder
    var background: some View {
        switch self {
        case .primary, .fullWidth:
            Color.accentColor
        case .secondary:
            Color.clear.background(.ultraThinMaterial)
        case .tertiary:
            Color.accentColor.opacity(0.1)
        case .destructive:
            Color.red
        case .compact, .icon:
            Color.clear.background(.ultraThinMaterial)
        }
    }
    
    @ViewBuilder
    var border: some View {
        switch self {
        case .secondary, .compact, .icon:
            shape.strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
        default:
            EmptyView()
        }
    }
    
    var shape: some InsettableShape {
        switch self {
        case .icon:
            return AnyInsettableShape(Circle())
        default:
            return AnyInsettableShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .compact: return 8
        case .icon: return 22
        default: return 12
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .compact: return 12
        case .icon: return 0
        default: return 20
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .compact: return 8
        case .icon: return 0
        default: return 14
        }
    }
}

// MARK: - Glass Button Press Style

/// A button style that adds press feedback to glass buttons.
struct GlassButtonPressStyle: ButtonStyle {
    
    let style: GlassButtonStyle
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Any Insettable Shape

/// A type-erased insettable shape for use in glass button styles.
struct AnyInsettableShape: InsettableShape {
    
    private let _path: (CGRect) -> Path
    private let _inset: (CGFloat) -> AnyInsettableShape
    
    init<S: InsettableShape>(_ shape: S) {
        _path = { shape.path(in: $0) }
        _inset = { AnyInsettableShape(shape.inset(by: $0)) }
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
    
    func inset(by amount: CGFloat) -> AnyInsettableShape {
        _inset(amount)
    }
}

// MARK: - Glass Icon Button

/// A circular icon button with glass styling.
struct GlassIconButton: View {
    
    let icon: String
    let action: () -> Void
    var size: CGFloat = 44
    var iconSize: CGFloat = 20
    var tint: Color = .primary
    var isActive: Bool = false
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: iconSize))
                .foregroundStyle(isActive ? .white : tint)
                .frame(width: size, height: size)
                .background(isActive ? Color.accentColor : .clear)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
                }
        }
        .buttonStyle(GlassButtonPressStyle(style: .icon))
    }
}

// MARK: - Glass Pill Button

/// A pill-shaped button with glass styling.
struct GlassPillButton: View {
    
    let title: String
    let icon: String?
    let action: () -> Void
    var isSelected: Bool = false
    var tint: Color = .accentColor
    
    init(
        _ title: String,
        icon: String? = nil,
        isSelected: Bool = false,
        tint: Color = .accentColor,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.tint = tint
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            UISelectionFeedbackGenerator().selectionChanged()
            action()
        }) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? tint : .clear)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(isSelected ? tint : .white.opacity(0.2), lineWidth: isSelected ? 0 : 0.5)
            }
        }
        .buttonStyle(GlassButtonPressStyle(style: .compact))
    }
}

// MARK: - Glass Loading Button

/// A button that shows a loading indicator.
struct GlassLoadingButton: View {
    
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            guard !isLoading else { return }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                
                Text(isLoading ? "Loading..." : title)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color.accentColor.opacity(isLoading ? 0.7 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(GlassButtonPressStyle(style: .primary))
        .disabled(isLoading)
    }
}

// MARK: - Glass Floating Action Button

/// A floating action button with glass styling.
struct GlassFloatingButton: View {
    
    let icon: String
    let action: () -> Void
    var size: CGFloat = 56
    var tint: Color = .accentColor
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        }) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(tint)
                .clipShape(Circle())
                .shadow(color: tint.opacity(0.3), radius: 10, y: 5)
        }
        .buttonStyle(GlassButtonPressStyle(style: .primary))
    }
}

// MARK: - Preview

#Preview("Glass Buttons") {
    VStack(spacing: 20) {
        GlassButton("Primary Button", icon: "star.fill") {
            print("Tapped")
        }
        
        GlassButton("Secondary", style: .secondary) {
            print("Tapped")
        }
        
        GlassButton("Tertiary", style: .tertiary) {
            print("Tapped")
        }
        
        GlassButton("Delete", icon: "trash", style: .destructive) {
            print("Tapped")
        }
        
        GlassButton("Full Width", style: .fullWidth) {
            print("Tapped")
        }
        
        HStack(spacing: 12) {
            GlassIconButton(icon: "heart.fill", action: {})
            GlassIconButton(icon: "bookmark", action: {})
            GlassIconButton(icon: "square.and.arrow.up", action: {})
        }
        
        HStack {
            GlassPillButton("All", isSelected: true) {}
            GlassPillButton("Recent") {}
            GlassPillButton("Favorites", icon: "star") {}
        }
        
        GlassLoadingButton(title: "Submit", isLoading: false) {}
        
        GlassFloatingButton(icon: "plus") {}
    }
    .padding()
}
