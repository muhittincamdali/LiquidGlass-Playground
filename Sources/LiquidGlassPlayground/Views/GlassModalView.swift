//
//  GlassModalView.swift
//  LiquidGlass-Playground
//
//  Modal and sheet components with iOS 26 Liquid Glass effects.
//  Supports various presentation styles and morphing transitions.
//

import SwiftUI

// MARK: - GlassModalStyle

/// Style variants for glass modals
public enum GlassModalStyle: String, CaseIterable, Identifiable, Sendable {
    case sheet
    case alert
    case dialog
    case fullscreen
    case popup
    case card
    case actionSheet
    case drawer
    
    public var id: String { rawValue }
    
    public var cornerRadius: CGFloat {
        switch self {
        case .sheet: return 32
        case .alert, .dialog: return 24
        case .fullscreen: return 0
        case .popup, .card: return 20
        case .actionSheet: return 28
        case .drawer: return 24
        }
    }
    
    public var defaultDetent: PresentationDetent {
        switch self {
        case .sheet: return .medium
        case .alert, .dialog, .popup: return .height(300)
        case .fullscreen: return .large
        case .card: return .height(400)
        case .actionSheet: return .height(250)
        case .drawer: return .fraction(0.4)
        }
    }
}

// MARK: - GlassModalConfiguration

/// Configuration for glass modals
public struct GlassModalConfiguration: Equatable, Sendable {
    public var style: GlassModalStyle
    public var showsDragIndicator: Bool
    public var showsCloseButton: Bool
    public var allowsDismiss: Bool
    public var backgroundOpacity: CGFloat
    public var tintColor: Color?
    
    public init(
        style: GlassModalStyle = .sheet,
        showsDragIndicator: Bool = true,
        showsCloseButton: Bool = false,
        allowsDismiss: Bool = true,
        backgroundOpacity: CGFloat = 0.4,
        tintColor: Color? = nil
    ) {
        self.style = style
        self.showsDragIndicator = showsDragIndicator
        self.showsCloseButton = showsCloseButton
        self.allowsDismiss = allowsDismiss
        self.backgroundOpacity = backgroundOpacity
        self.tintColor = tintColor
    }
    
    public static let `default` = GlassModalConfiguration()
    public static let alert = GlassModalConfiguration(style: .alert, showsDragIndicator: false, showsCloseButton: false)
    public static let dialog = GlassModalConfiguration(style: .dialog, showsDragIndicator: false, showsCloseButton: true)
    public static let popup = GlassModalConfiguration(style: .popup, showsDragIndicator: false)
    public static let actionSheet = GlassModalConfiguration(style: .actionSheet)
    public static let drawer = GlassModalConfiguration(style: .drawer)
}

// MARK: - GlassSheet

/// A sheet presentation with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let configuration: GlassModalConfiguration
    let content: Content
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    public init(
        isPresented: Binding<Bool>,
        configuration: GlassModalConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.configuration = configuration
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            if isPresented {
                // Dimming background
                Color.black
                    .opacity(configuration.backgroundOpacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if configuration.allowsDismiss {
                            dismiss()
                        }
                    }
                    .transition(.opacity)
                
                // Sheet content
                VStack(spacing: 0) {
                    Spacer()
                    
                    sheetContent
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea(.container, edges: .bottom)
            }
        }
        .animation(reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.85), value: isPresented)
    }
    
    @ViewBuilder
    private var sheetContent: some View {
        GlassEffectContainer {
            VStack(spacing: 0) {
                // Drag indicator
                if configuration.showsDragIndicator {
                    dragIndicator
                }
                
                // Header with close button
                if configuration.showsCloseButton {
                    headerView
                }
                
                // Content
                content
            }
            .frame(maxWidth: .infinity)
            .background(glassBackground)
            .clipShape(sheetShape)
            .shadow(color: .black.opacity(0.2), radius: 20, y: -10)
            .glassEffectID("sheet", in: namespace)
        }
    }
    
    @ViewBuilder
    private var dragIndicator: some View {
        Capsule()
            .fill(Color.secondary.opacity(0.5))
            .frame(width: 36, height: 5)
            .padding(.top, 8)
            .padding(.bottom, 4)
    }
    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .padding(16)
        }
    }
    
    @ViewBuilder
    private var glassBackground: some View {
        if !reduceTransparency {
            if let tint = configuration.tintColor {
                Color.clear.glassEffect(.regular.tint(tint), in: sheetShape)
            } else {
                Color.clear.glassEffect(.regular, in: sheetShape)
            }
        } else {
            Color(UIColor.systemBackground)
        }
    }
    
    private var sheetShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: configuration.style.cornerRadius,
            topTrailingRadius: configuration.style.cornerRadius
        )
    }
    
    private func dismiss() {
        withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.8)) {
            isPresented = false
        }
    }
}

// MARK: - GlassAlert

/// An alert dialog with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassAlert: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let icon: String?
    let iconColor: Color
    let primaryButton: AlertButton?
    let secondaryButton: AlertButton?
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public struct AlertButton {
        let title: String
        let role: ButtonRole?
        let action: () -> Void
        
        public init(_ title: String, role: ButtonRole? = nil, action: @escaping () -> Void = {}) {
            self.title = title
            self.role = role
            self.action = action
        }
        
        public static func `default`(_ title: String, action: @escaping () -> Void = {}) -> AlertButton {
            AlertButton(title, action: action)
        }
        
        public static func destructive(_ title: String, action: @escaping () -> Void = {}) -> AlertButton {
            AlertButton(title, role: .destructive, action: action)
        }
        
        public static func cancel(_ title: String = "Cancel", action: @escaping () -> Void = {}) -> AlertButton {
            AlertButton(title, role: .cancel, action: action)
        }
    }
    
    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        icon: String? = nil,
        iconColor: Color = .blue,
        primaryButton: AlertButton? = nil,
        secondaryButton: AlertButton? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.icon = icon
        self.iconColor = iconColor
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
    
    public var body: some View {
        ZStack {
            if isPresented {
                // Background
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)
                
                // Alert
                alertContent
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .animation(reduceMotion ? .none : .spring(response: 0.35, dampingFraction: 0.8), value: isPresented)
    }
    
    @ViewBuilder
    private var alertContent: some View {
        GlassEffectContainer {
            VStack(spacing: 20) {
                // Icon
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 48, weight: .medium))
                        .foregroundStyle(iconColor)
                        .frame(width: 64, height: 64)
                        .glassEffect(.regular.tint(iconColor.opacity(0.3)), in: .circle)
                }
                
                // Text
                VStack(spacing: 8) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    
                    if let message = message {
                        Text(message)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Buttons
                buttonStack
            }
            .padding(24)
            .frame(maxWidth: 320)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 20)
            .glassEffectID("alert", in: namespace)
        }
    }
    
    @ViewBuilder
    private var buttonStack: some View {
        if let primary = primaryButton {
            VStack(spacing: 8) {
                // Primary button
                Button {
                    primary.action()
                    dismiss()
                } label: {
                    Text(primary.title)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.glassProminent)
                .tint(primary.role == .destructive ? .red : .blue)
                
                // Secondary button
                if let secondary = secondaryButton {
                    Button {
                        secondary.action()
                        dismiss()
                    } label: {
                        Text(secondary.title)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                    }
                    .buttonStyle(.glass)
                }
            }
        }
    }
    
    private func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
}

// MARK: - GlassPopup

/// A centered popup with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassPopup<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    let maxWidth: CGFloat
    let cornerRadius: CGFloat
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        isPresented: Binding<Bool>,
        maxWidth: CGFloat = 340,
        cornerRadius: CGFloat = 24,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.maxWidth = maxWidth
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)
                
                GlassEffectContainer {
                    content
                        .frame(maxWidth: maxWidth)
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                        .shadow(color: .black.opacity(0.25), radius: 24)
                        .glassEffectID("popup", in: namespace)
                }
                .transition(.scale(scale: 0.85).combined(with: .opacity))
            }
        }
        .animation(reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.75), value: isPresented)
    }
    
    private func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
}

// MARK: - GlassActionSheet

/// An action sheet with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassActionSheet: View {
    @Binding var isPresented: Bool
    let title: String?
    let message: String?
    let actions: [ActionItem]
    let cancelAction: ActionItem?
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public struct ActionItem: Identifiable {
        public let id = UUID()
        public let title: String
        public let icon: String?
        public let role: ButtonRole?
        public let action: () -> Void
        
        public init(
            _ title: String,
            icon: String? = nil,
            role: ButtonRole? = nil,
            action: @escaping () -> Void = {}
        ) {
            self.title = title
            self.icon = icon
            self.role = role
            self.action = action
        }
        
        public static func destructive(_ title: String, icon: String? = nil, action: @escaping () -> Void = {}) -> ActionItem {
            ActionItem(title, icon: icon, role: .destructive, action: action)
        }
        
        public static func cancel(_ title: String = "Cancel", action: @escaping () -> Void = {}) -> ActionItem {
            ActionItem(title, role: .cancel, action: action)
        }
    }
    
    public init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        message: String? = nil,
        actions: [ActionItem],
        cancelAction: ActionItem? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.actions = actions
        self.cancelAction = cancelAction
    }
    
    public var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)
                
                VStack(spacing: 8) {
                    Spacer()
                    
                    // Actions group
                    actionsGroup
                    
                    // Cancel button
                    if let cancel = cancelAction {
                        cancelButton(cancel)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.85), value: isPresented)
    }
    
    @ViewBuilder
    private var actionsGroup: some View {
        GlassEffectContainer(spacing: 0) {
            VStack(spacing: 0) {
                // Header
                if title != nil || message != nil {
                    VStack(spacing: 4) {
                        if let title = title {
                            Text(title)
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                        
                        if let message = message {
                            Text(message)
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    
                    Divider().overlay(Color.white.opacity(0.1))
                }
                
                // Action buttons
                ForEach(Array(actions.enumerated()), id: \.element.id) { index, action in
                    actionButton(action)
                    
                    if index < actions.count - 1 {
                        Divider().overlay(Color.white.opacity(0.1))
                    }
                }
            }
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .glassEffectID("actions", in: namespace)
        }
    }
    
    @ViewBuilder
    private func actionButton(_ action: ActionItem) -> some View {
        Button {
            action.action()
            dismiss()
        } label: {
            HStack(spacing: 8) {
                if let icon = action.icon {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                }
                
                Text(action.title)
                    .font(.title3)
            }
            .foregroundStyle(action.role == .destructive ? .red : .primary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func cancelButton(_ action: ActionItem) -> some View {
        GlassEffectContainer {
            Button {
                action.action()
                dismiss()
            } label: {
                Text(action.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .buttonStyle(.plain)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .glassEffectID("cancel", in: namespace)
        }
    }
    
    private func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
}

// MARK: - GlassDrawer

/// A drawer that slides from an edge
@available(iOS 26.0, macOS 26.0, *)
public struct GlassDrawer<Content: View>: View {
    @Binding var isPresented: Bool
    let edge: Edge
    let width: CGFloat?
    let content: Content
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @GestureState private var dragOffset: CGFloat = 0
    
    public init(
        isPresented: Binding<Bool>,
        edge: Edge = .leading,
        width: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.edge = edge
        self.width = width
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)
                
                drawerContent
            }
        }
        .animation(reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.85), value: isPresented)
    }
    
    @ViewBuilder
    private var drawerContent: some View {
        GlassEffectContainer {
            HStack(spacing: 0) {
                if edge == .trailing {
                    Spacer()
                }
                
                content
                    .frame(width: drawerWidth)
                    .frame(maxHeight: .infinity)
                    .glassEffect(.regular, in: drawerShape)
                    .offset(x: currentOffset)
                    .gesture(dragGesture)
                    .glassEffectID("drawer", in: namespace)
                
                if edge == .leading {
                    Spacer()
                }
            }
        }
        .transition(.move(edge: edge))
    }
    
    private var drawerWidth: CGFloat {
        width ?? (UIScreen.main.bounds.width * 0.8)
    }
    
    private var drawerShape: UnevenRoundedRectangle {
        switch edge {
        case .leading:
            return UnevenRoundedRectangle(
                topTrailingRadius: 24,
                bottomTrailingRadius: 24
            )
        case .trailing:
            return UnevenRoundedRectangle(
                topLeadingRadius: 24,
                bottomLeadingRadius: 24
            )
        default:
            return UnevenRoundedRectangle()
        }
    }
    
    private var currentOffset: CGFloat {
        switch edge {
        case .leading:
            return min(0, dragOffset)
        case .trailing:
            return max(0, dragOffset)
        default:
            return 0
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                let translation = edge == .leading ? value.translation.width : -value.translation.width
                if translation < 0 {
                    state = translation
                }
            }
            .onEnded { value in
                let threshold: CGFloat = 100
                let velocity = edge == .leading ? value.velocity.width : -value.velocity.width
                let translation = edge == .leading ? value.translation.width : -value.translation.width
                
                if translation < -threshold || velocity < -500 {
                    dismiss()
                }
            }
    }
    
    private func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
}

// MARK: - GlassToast

/// A toast notification with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassToast: View {
    let message: String
    let icon: String?
    let iconColor: Color
    @Binding var isPresented: Bool
    let duration: Double
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        _ message: String,
        icon: String? = nil,
        iconColor: Color = .blue,
        isPresented: Binding<Bool>,
        duration: Double = 3.0
    ) {
        self.message = message
        self.icon = icon
        self.iconColor = iconColor
        self._isPresented = isPresented
        self.duration = duration
    }
    
    public var body: some View {
        ZStack {
            if isPresented {
                GlassEffectContainer {
                    HStack(spacing: 12) {
                        if let icon = icon {
                            Image(systemName: icon)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(iconColor)
                        }
                        
                        Text(message)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .glassEffect(.regular, in: .capsule)
                    .shadow(color: .black.opacity(0.15), radius: 12)
                    .glassEffectID("toast", in: namespace)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        dismiss()
                    }
                }
            }
        }
        .animation(reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.8), value: isPresented)
    }
    
    private func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
}

// MARK: - View Extension for Modals

@available(iOS 26.0, macOS 26.0, *)
extension View {
    /// Presents a glass sheet
    public func glassSheet<Content: View>(
        isPresented: Binding<Bool>,
        configuration: GlassModalConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.overlay {
            GlassSheet(
                isPresented: isPresented,
                configuration: configuration,
                content: content
            )
        }
    }
    
    /// Presents a glass alert
    public func glassAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        icon: String? = nil,
        iconColor: Color = .blue,
        primaryButton: GlassAlert.AlertButton? = nil,
        secondaryButton: GlassAlert.AlertButton? = nil
    ) -> some View {
        self.overlay {
            GlassAlert(
                isPresented: isPresented,
                title: title,
                message: message,
                icon: icon,
                iconColor: iconColor,
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
        }
    }
    
    /// Presents a glass toast
    public func glassToast(
        _ message: String,
        icon: String? = nil,
        isPresented: Binding<Bool>,
        duration: Double = 3.0
    ) -> some View {
        self.overlay(alignment: .top) {
            GlassToast(
                message,
                icon: icon,
                isPresented: isPresented,
                duration: duration
            )
            .padding(.top, 60)
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
struct GlassModalView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.orange, .pink, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Modal Demo")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
            }
            
            // Demo alert
            GlassAlert(
                isPresented: .constant(true),
                title: "Delete Item?",
                message: "This action cannot be undone.",
                icon: "trash",
                iconColor: .red,
                primaryButton: .destructive("Delete"),
                secondaryButton: .cancel()
            )
        }
    }
}
