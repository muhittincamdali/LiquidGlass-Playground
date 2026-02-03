//
//  GlassButtonView.swift
//  LiquidGlass-Playground
//
//  Comprehensive glass button components with iOS 26 Liquid Glass effects.
//  Supports multiple styles, sizes, and interactive states.
//

import SwiftUI

// MARK: - GlassButtonSize

/// Size presets for glass buttons
public enum GlassButtonSize: String, CaseIterable, Identifiable, Sendable {
    case mini
    case small
    case medium
    case large
    case extraLarge
    
    public var id: String { rawValue }
    
    public var height: CGFloat {
        switch self {
        case .mini: return 28
        case .small: return 36
        case .medium: return 44
        case .large: return 52
        case .extraLarge: return 64
        }
    }
    
    public var fontSize: CGFloat {
        switch self {
        case .mini: return 12
        case .small: return 14
        case .medium: return 16
        case .large: return 18
        case .extraLarge: return 22
        }
    }
    
    public var iconSize: CGFloat {
        switch self {
        case .mini: return 12
        case .small: return 14
        case .medium: return 18
        case .large: return 22
        case .extraLarge: return 28
        }
    }
    
    public var horizontalPadding: CGFloat {
        switch self {
        case .mini: return 10
        case .small: return 14
        case .medium: return 18
        case .large: return 24
        case .extraLarge: return 32
        }
    }
    
    public var cornerRadius: CGFloat {
        switch self {
        case .mini: return 6
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        case .extraLarge: return 20
        }
    }
    
    public var controlSize: ControlSize {
        switch self {
        case .mini: return .mini
        case .small: return .small
        case .medium: return .regular
        case .large: return .large
        case .extraLarge: return .extraLarge
        }
    }
}

// MARK: - GlassButtonVariant

/// Visual variants for glass buttons
public enum GlassButtonVariant: String, CaseIterable, Identifiable, Sendable {
    case primary
    case secondary
    case tertiary
    case destructive
    case success
    case warning
    case custom
    
    public var id: String { rawValue }
    
    public var defaultTint: Color {
        switch self {
        case .primary: return .blue
        case .secondary: return .gray
        case .tertiary: return .clear
        case .destructive: return .red
        case .success: return .green
        case .warning: return .orange
        case .custom: return .blue
        }
    }
    
    public var isProminent: Bool {
        switch self {
        case .primary, .destructive, .success: return true
        default: return false
        }
    }
}

// MARK: - GlassButtonShape

/// Shape options for glass buttons
public enum GlassButtonShape: String, CaseIterable, Identifiable, Sendable {
    case capsule
    case rounded
    case circle
    case rectangle
    
    public var id: String { rawValue }
    
    public var borderShape: ButtonBorderShape {
        switch self {
        case .capsule: return .capsule
        case .rounded: return .roundedRectangle(radius: 12)
        case .circle: return .circle
        case .rectangle: return .roundedRectangle(radius: 4)
        }
    }
}

// MARK: - GlassButtonConfiguration

/// Complete configuration for a glass button
public struct GlassButtonConfiguration: Equatable, Sendable {
    public var size: GlassButtonSize
    public var variant: GlassButtonVariant
    public var shape: GlassButtonShape
    public var tintColor: Color?
    public var isEnabled: Bool
    public var isLoading: Bool
    public var showShadow: Bool
    public var hapticFeedback: Bool
    
    public init(
        size: GlassButtonSize = .medium,
        variant: GlassButtonVariant = .primary,
        shape: GlassButtonShape = .capsule,
        tintColor: Color? = nil,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        showShadow: Bool = true,
        hapticFeedback: Bool = true
    ) {
        self.size = size
        self.variant = variant
        self.shape = shape
        self.tintColor = tintColor
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.showShadow = showShadow
        self.hapticFeedback = hapticFeedback
    }
    
    public static let `default` = GlassButtonConfiguration()
    
    public var effectiveTint: Color {
        tintColor ?? variant.defaultTint
    }
}

// MARK: - GlassButton

/// A versatile glass button with iOS 26 Liquid Glass effects
@available(iOS 26.0, macOS 26.0, *)
public struct GlassButton: View {
    // MARK: Properties
    
    private let title: String
    private let icon: String?
    private let configuration: GlassButtonConfiguration
    private let action: () -> Void
    
    @State private var isPressed = false
    @State private var showRipple = false
    @Namespace private var buttonNamespace
    
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    // MARK: Initialization
    
    public init(
        _ title: String,
        icon: String? = nil,
        configuration: GlassButtonConfiguration = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.configuration = configuration
        self.action = action
    }
    
    public init(
        _ title: String,
        icon: String? = nil,
        size: GlassButtonSize = .medium,
        variant: GlassButtonVariant = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.configuration = GlassButtonConfiguration(size: size, variant: variant)
        self.action = action
    }
    
    // MARK: Body
    
    public var body: some View {
        Button(action: performAction) {
            buttonContent
        }
        .buttonStyle(configuration.variant.isProminent ? .glassProminent : .glass)
        .buttonBorderShape(configuration.shape.borderShape)
        .controlSize(configuration.size.controlSize)
        .tint(configuration.effectiveTint)
        .disabled(!configuration.isEnabled || configuration.isLoading)
        .opacity(configuration.isEnabled ? 1.0 : 0.5)
        .glassEffectID("button-\(title)", in: buttonNamespace)
    }
    
    // MARK: Button Content
    
    @ViewBuilder
    private var buttonContent: some View {
        HStack(spacing: 8) {
            if configuration.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(0.8)
                    .tint(.white)
            } else if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: configuration.size.iconSize, weight: .semibold))
            }
            
            if !title.isEmpty {
                Text(title)
                    .font(.system(size: configuration.size.fontSize, weight: .semibold))
            }
        }
        .frame(height: configuration.size.height)
        .padding(.horizontal, configuration.size.horizontalPadding)
    }
    
    // MARK: Actions
    
    private func performAction() {
        if configuration.hapticFeedback {
            #if os(iOS)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            #endif
        }
        
        action()
    }
}

// MARK: - GlassIconButton

/// A circular glass button with only an icon
@available(iOS 26.0, macOS 26.0, *)
public struct GlassIconButton: View {
    private let icon: String
    private let size: GlassButtonSize
    private let variant: GlassButtonVariant
    private let tintColor: Color?
    private let action: () -> Void
    
    @Namespace private var namespace
    
    public init(
        icon: String,
        size: GlassButtonSize = .medium,
        variant: GlassButtonVariant = .secondary,
        tintColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.variant = variant
        self.tintColor = tintColor
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .medium))
                .frame(width: size.height, height: size.height)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .tint(tintColor ?? variant.defaultTint)
        .glassEffectID("icon-\(icon)", in: namespace)
    }
}

// MARK: - GlassToggleButton

/// A toggle button with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassToggleButton: View {
    private let title: String
    private let iconOn: String
    private let iconOff: String
    private let size: GlassButtonSize
    @Binding var isOn: Bool
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        _ title: String,
        iconOn: String,
        iconOff: String,
        size: GlassButtonSize = .medium,
        isOn: Binding<Bool>
    ) {
        self.title = title
        self.iconOn = iconOn
        self.iconOff = iconOff
        self.size = size
        self._isOn = isOn
    }
    
    public var body: some View {
        Button {
            withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isOn ? iconOn : iconOff)
                    .font(.system(size: size.iconSize, weight: .semibold))
                    .symbolEffect(.bounce, value: isOn)
                
                if !title.isEmpty {
                    Text(title)
                        .font(.system(size: size.fontSize, weight: .semibold))
                }
            }
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
        }
        .buttonStyle(isOn ? .glassProminent : .glass)
        .buttonBorderShape(.capsule)
        .tint(isOn ? .blue : .gray)
        .glassEffectID("toggle-\(title)", in: namespace)
    }
}

// MARK: - GlassButtonGroup

/// A group of glass buttons that morph together
@available(iOS 26.0, macOS 26.0, *)
public struct GlassButtonGroup<Content: View>: View {
    private let spacing: CGFloat
    private let axis: Axis
    private let content: Content
    
    public init(
        spacing: CGFloat = 12,
        axis: Axis = .horizontal,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.axis = axis
        self.content = content()
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: spacing) {
            Group {
                switch axis {
                case .horizontal:
                    HStack(spacing: spacing) {
                        content
                    }
                case .vertical:
                    VStack(spacing: spacing) {
                        content
                    }
                }
            }
        }
    }
}

// MARK: - GlassSegmentedControl

/// A segmented control with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassSegmentedControl<SelectionValue: Hashable>: View {
    @Binding var selection: SelectionValue
    let options: [(value: SelectionValue, label: String, icon: String?)]
    let size: GlassButtonSize
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        selection: Binding<SelectionValue>,
        options: [(SelectionValue, String, String?)],
        size: GlassButtonSize = .medium
    ) {
        self._selection = selection
        self.options = options.map { (value: $0.0, label: $0.1, icon: $0.2) }
        self.size = size
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: 4) {
            HStack(spacing: 4) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    segmentButton(for: option, at: index)
                }
            }
            .padding(4)
            .glassEffect(.regular, in: .capsule)
        }
    }
    
    @ViewBuilder
    private func segmentButton(
        for option: (value: SelectionValue, label: String, icon: String?),
        at index: Int
    ) -> some View {
        let isSelected = selection == option.value
        
        Button {
            withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.8)) {
                selection = option.value
            }
        } label: {
            HStack(spacing: 6) {
                if let icon = option.icon {
                    Image(systemName: icon)
                        .font(.system(size: size.iconSize - 2, weight: .medium))
                }
                
                Text(option.label)
                    .font(.system(size: size.fontSize - 2, weight: .medium))
            }
            .frame(height: size.height - 8)
            .padding(.horizontal, size.horizontalPadding - 4)
            .background {
                if isSelected {
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .matchedGeometryEffect(id: "segment", in: namespace)
                }
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(isSelected ? .primary : .secondary)
        .glassEffectID("segment-\(index)", in: namespace)
    }
}

// MARK: - GlassFloatingActionButton

/// A floating action button with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassFloatingActionButton: View {
    private let icon: String
    private let size: CGFloat
    private let tintColor: Color
    private let action: () -> Void
    
    @State private var isPressed = false
    @State private var isExpanded = false
    @Namespace private var namespace
    
    public init(
        icon: String,
        size: CGFloat = 56,
        tintColor: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.tintColor = tintColor
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(tintColor)
        .shadow(color: tintColor.opacity(0.4), radius: 12, y: 6)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .glassEffectID("fab", in: namespace)
    }
}

// MARK: - GlassExpandableButton

/// An expandable floating action button with multiple actions
@available(iOS 26.0, macOS 26.0, *)
public struct GlassExpandableButton: View {
    let mainIcon: String
    let expandedIcon: String
    let actions: [(icon: String, label: String, action: () -> Void)]
    let tintColor: Color
    
    @State private var isExpanded = false
    @Namespace private var namespace
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        mainIcon: String = "plus",
        expandedIcon: String = "xmark",
        tintColor: Color = .blue,
        actions: [(String, String, () -> Void)]
    ) {
        self.mainIcon = mainIcon
        self.expandedIcon = expandedIcon
        self.tintColor = tintColor
        self.actions = actions.map { (icon: $0.0, label: $0.1, action: $0.2) }
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: 16) {
            VStack(spacing: 16) {
                // Action buttons
                if isExpanded {
                    ForEach(Array(actions.enumerated()), id: \.offset) { index, action in
                        actionButton(for: action, at: index)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity).animation(.spring(response: 0.3, dampingFraction: 0.7).delay(Double(index) * 0.05)),
                                removal: .scale.combined(with: .opacity).animation(.spring(response: 0.2, dampingFraction: 0.8))
                            ))
                    }
                }
                
                // Main button
                mainButton
            }
        }
    }
    
    @ViewBuilder
    private var mainButton: some View {
        Button {
            withAnimation(reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.7)) {
                isExpanded.toggle()
            }
        } label: {
            Image(systemName: isExpanded ? expandedIcon : mainIcon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(tintColor)
        .shadow(color: tintColor.opacity(0.4), radius: 12, y: 6)
        .glassEffectID("main", in: namespace)
    }
    
    @ViewBuilder
    private func actionButton(for action: (icon: String, label: String, action: () -> Void), at index: Int) -> some View {
        HStack(spacing: 12) {
            Text(action.label)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .glassEffect(.regular, in: .capsule)
            
            Button {
                action.action()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded = false
                }
            } label: {
                Image(systemName: action.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.circle)
            .tint(tintColor.opacity(0.8))
        }
        .glassEffectID("action-\(index)", in: namespace)
    }
}

// MARK: - GlassChipButton

/// A small chip-style button with glass effect
@available(iOS 26.0, macOS 26.0, *)
public struct GlassChipButton: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    @Namespace private var namespace
    
    public init(
        _ title: String,
        icon: String? = nil,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium))
                }
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
        }
        .buttonStyle(isSelected ? .glassProminent : .glass)
        .buttonBorderShape(.capsule)
        .tint(isSelected ? .blue : .gray)
        .glassEffectID("chip-\(title)", in: namespace)
    }
}

// MARK: - GlassChipGroup

/// A horizontally scrolling group of chip buttons
@available(iOS 26.0, macOS 26.0, *)
public struct GlassChipGroup<SelectionValue: Hashable>: View {
    @Binding var selection: Set<SelectionValue>
    let options: [(value: SelectionValue, label: String, icon: String?)]
    let allowsMultipleSelection: Bool
    
    public init(
        selection: Binding<Set<SelectionValue>>,
        options: [(SelectionValue, String, String?)],
        allowsMultipleSelection: Bool = true
    ) {
        self._selection = selection
        self.options = options.map { (value: $0.0, label: $0.1, icon: $0.2) }
        self.allowsMultipleSelection = allowsMultipleSelection
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            GlassEffectContainer(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                        GlassChipButton(
                            option.label,
                            icon: option.icon,
                            isSelected: selection.contains(option.value)
                        ) {
                            toggleSelection(for: option.value)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private func toggleSelection(for value: SelectionValue) {
        if selection.contains(value) {
            selection.remove(value)
        } else {
            if !allowsMultipleSelection {
                selection.removeAll()
            }
            selection.insert(value)
        }
    }
}

// MARK: - GlassStepperButton

/// A stepper control with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassStepperButton: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    let size: GlassButtonSize
    
    @Namespace private var namespace
    
    public init(
        value: Binding<Int>,
        range: ClosedRange<Int> = 0...100,
        step: Int = 1,
        size: GlassButtonSize = .medium
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.size = size
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: 0) {
                // Decrement
                Button {
                    if value - step >= range.lowerBound {
                        value -= step
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: size.iconSize, weight: .medium))
                        .frame(width: size.height, height: size.height)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.roundedRectangle(radius: size.cornerRadius))
                .disabled(value <= range.lowerBound)
                .glassEffectID("decrement", in: namespace)
                
                // Value display
                Text("\(value)")
                    .font(.system(size: size.fontSize, weight: .semibold, design: .monospaced))
                    .frame(minWidth: size.height * 1.5)
                    .padding(.horizontal, 8)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: size.cornerRadius - 4))
                    .glassEffectID("value", in: namespace)
                
                // Increment
                Button {
                    if value + step <= range.upperBound {
                        value += step
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: size.iconSize, weight: .medium))
                        .frame(width: size.height, height: size.height)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.roundedRectangle(radius: size.cornerRadius))
                .disabled(value >= range.upperBound)
                .glassEffectID("increment", in: namespace)
            }
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
struct GlassButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Basic buttons
                    GlassButtonGroup {
                        GlassButton("Primary", icon: "star.fill", variant: .primary) { }
                        GlassButton("Secondary", icon: "heart.fill", variant: .secondary) { }
                    }
                    
                    // Icon buttons
                    GlassButtonGroup {
                        GlassIconButton(icon: "play.fill", size: .large) { }
                        GlassIconButton(icon: "pause.fill", size: .large) { }
                        GlassIconButton(icon: "forward.fill", size: .large) { }
                    }
                    
                    // FAB
                    GlassFloatingActionButton(icon: "plus", tintColor: .orange) { }
                    
                    // Chips
                    GlassButtonGroup {
                        GlassChipButton("Swift", icon: "swift", isSelected: true) { }
                        GlassChipButton("iOS", isSelected: false) { }
                        GlassChipButton("macOS", isSelected: false) { }
                    }
                }
                .padding()
            }
        }
    }
}
