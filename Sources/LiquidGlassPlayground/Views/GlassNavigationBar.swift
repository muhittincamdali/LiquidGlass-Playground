//
//  GlassNavigationBar.swift
//  LiquidGlass-Playground
//
//  Custom navigation bar components with iOS 26 Liquid Glass effects.
//  Supports custom layouts, morphing, and adaptive theming.
//

import SwiftUI

// MARK: - GlassNavigationBarStyle

/// Style variants for glass navigation bars
public enum GlassNavigationBarStyle: String, CaseIterable, Identifiable, Sendable {
    case standard
    case large
    case compact
    case floating
    case transparent
    case prominent
    
    public var id: String { rawValue }
    
    public var height: CGFloat {
        switch self {
        case .standard: return 44
        case .large: return 96
        case .compact: return 36
        case .floating: return 52
        case .transparent: return 44
        case .prominent: return 64
        }
    }
    
    public var titleSize: Font {
        switch self {
        case .standard, .compact, .transparent: return .headline
        case .large: return .largeTitle
        case .floating, .prominent: return .title3
        }
    }
    
    public var showsGlass: Bool {
        switch self {
        case .transparent: return false
        default: return true
        }
    }
}

// MARK: - GlassNavigationBarConfiguration

/// Complete configuration for a glass navigation bar
public struct GlassNavigationBarConfiguration: Equatable, Sendable {
    public var style: GlassNavigationBarStyle
    public var tintColor: Color?
    public var showsShadow: Bool
    public var showsBackButton: Bool
    public var showsDivider: Bool
    public var blurRadius: CGFloat
    public var cornerRadius: CGFloat
    public var horizontalPadding: CGFloat
    
    public init(
        style: GlassNavigationBarStyle = .standard,
        tintColor: Color? = nil,
        showsShadow: Bool = true,
        showsBackButton: Bool = true,
        showsDivider: Bool = false,
        blurRadius: CGFloat = 20,
        cornerRadius: CGFloat = 0,
        horizontalPadding: CGFloat = 16
    ) {
        self.style = style
        self.tintColor = tintColor
        self.showsShadow = showsShadow
        self.showsBackButton = showsBackButton
        self.showsDivider = showsDivider
        self.blurRadius = blurRadius
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
    }
    
    public static let `default` = GlassNavigationBarConfiguration()
    public static let floating = GlassNavigationBarConfiguration(style: .floating, cornerRadius: 24)
    public static let large = GlassNavigationBarConfiguration(style: .large)
    public static let compact = GlassNavigationBarConfiguration(style: .compact)
}

// MARK: - GlassNavigationBar

/// A customizable navigation bar with Liquid Glass effects
@available(iOS 26.0, macOS 26.0, *)
public struct GlassNavigationBar<LeadingContent: View, TrailingContent: View>: View {
    // MARK: Properties
    
    private let title: String
    private let subtitle: String?
    private let configuration: GlassNavigationBarConfiguration
    private let leadingContent: LeadingContent
    private let trailingContent: TrailingContent
    private let onBack: (() -> Void)?
    
    @Namespace private var namespace
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    // MARK: Initialization
    
    public init(
        title: String,
        subtitle: String? = nil,
        configuration: GlassNavigationBarConfiguration = .default,
        onBack: (() -> Void)? = nil,
        @ViewBuilder leading: () -> LeadingContent,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.title = title
        self.subtitle = subtitle
        self.configuration = configuration
        self.onBack = onBack
        self.leadingContent = leading()
        self.trailingContent = trailing()
    }
    
    // MARK: Body
    
    public var body: some View {
        GlassEffectContainer(spacing: 12) {
            VStack(spacing: 0) {
                mainContent
                
                if configuration.showsDivider {
                    Divider()
                        .overlay(Color.white.opacity(0.2))
                }
            }
            .frame(height: configuration.style.height)
            .padding(.horizontal, configuration.horizontalPadding)
            .background(backgroundView)
            .clipShape(navBarShape)
            .shadow(
                color: configuration.showsShadow ? .black.opacity(0.1) : .clear,
                radius: 8,
                y: 4
            )
        }
    }
    
    // MARK: Main Content
    
    @ViewBuilder
    private var mainContent: some View {
        switch configuration.style {
        case .large:
            largeStyleContent
        case .floating:
            floatingStyleContent
        default:
            standardContent
        }
    }
    
    @ViewBuilder
    private var standardContent: some View {
        HStack(spacing: 12) {
            // Leading
            HStack(spacing: 8) {
                if configuration.showsBackButton, let onBack = onBack {
                    backButton(action: onBack)
                }
                leadingContent
            }
            .frame(minWidth: 44, alignment: .leading)
            
            Spacer()
            
            // Title
            titleView
            
            Spacer()
            
            // Trailing
            trailingContent
                .frame(minWidth: 44, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var largeStyleContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Top row with buttons
            HStack {
                if configuration.showsBackButton, let onBack = onBack {
                    backButton(action: onBack)
                }
                leadingContent
                
                Spacer()
                
                trailingContent
            }
            
            Spacer()
            
            // Large title
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var floatingStyleContent: some View {
        HStack(spacing: 16) {
            if configuration.showsBackButton, let onBack = onBack {
                backButton(action: onBack)
            }
            leadingContent
            
            titleView
            
            Spacer()
            
            trailingContent
        }
    }
    
    // MARK: Subviews
    
    @ViewBuilder
    private var titleView: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(configuration.style.titleSize.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            if let subtitle = subtitle, configuration.style != .large {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }
    
    @ViewBuilder
    private func backButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 36, height: 36)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .glassEffectID("back", in: namespace)
    }
    
    // MARK: Background
    
    @ViewBuilder
    private var backgroundView: some View {
        if configuration.style.showsGlass && !reduceTransparency {
            Color.clear
                .glassEffect(glassType, in: navBarShape)
        } else if reduceTransparency {
            Color(UIColor.systemBackground)
        } else {
            Color.clear
        }
    }
    
    private var glassType: Glass {
        if let tint = configuration.tintColor {
            return .regular.tint(tint)
        }
        return .regular
    }
    
    private var navBarShape: some Shape {
        if configuration.cornerRadius > 0 {
            return AnyShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        }
        return AnyShape(Rectangle())
    }
}

// MARK: - Convenience Initializers

@available(iOS 26.0, macOS 26.0, *)
extension GlassNavigationBar where LeadingContent == EmptyView, TrailingContent == EmptyView {
    public init(
        title: String,
        subtitle: String? = nil,
        configuration: GlassNavigationBarConfiguration = .default,
        onBack: (() -> Void)? = nil
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            configuration: configuration,
            onBack: onBack,
            leading: { EmptyView() },
            trailing: { EmptyView() }
        )
    }
}

@available(iOS 26.0, macOS 26.0, *)
extension GlassNavigationBar where LeadingContent == EmptyView {
    public init(
        title: String,
        subtitle: String? = nil,
        configuration: GlassNavigationBarConfiguration = .default,
        onBack: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            configuration: configuration,
            onBack: onBack,
            leading: { EmptyView() },
            trailing: trailing
        )
    }
}

@available(iOS 26.0, macOS 26.0, *)
extension GlassNavigationBar where TrailingContent == EmptyView {
    public init(
        title: String,
        subtitle: String? = nil,
        configuration: GlassNavigationBarConfiguration = .default,
        onBack: (() -> Void)? = nil,
        @ViewBuilder leading: () -> LeadingContent
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            configuration: configuration,
            onBack: onBack,
            leading: leading,
            trailing: { EmptyView() }
        )
    }
}

// MARK: - GlassNavigationToolbar

/// A toolbar component with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassNavigationToolbar<Content: View>: View {
    private let content: Content
    private let spacing: CGFloat
    private let showsGlass: Bool
    
    public init(
        spacing: CGFloat = 12,
        showsGlass: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.spacing = spacing
        self.showsGlass = showsGlass
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: spacing) {
            HStack(spacing: spacing) {
                content
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                if showsGlass {
                    Capsule()
                        .fill(.clear)
                        .glassEffect(.regular, in: .capsule)
                }
            }
        }
    }
}

// MARK: - GlassSearchBar

/// A search bar with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassSearchBar: View {
    @Binding var text: String
    let placeholder: String
    let showsCancelButton: Bool
    let onSubmit: (() -> Void)?
    let onCancel: (() -> Void)?
    
    @FocusState private var isFocused: Bool
    @Namespace private var namespace
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        text: Binding<String>,
        placeholder: String = "Search",
        showsCancelButton: Bool = true,
        onSubmit: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.showsCancelButton = showsCancelButton
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: 12) {
            HStack(spacing: 12) {
                // Search field
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                    
                    TextField(placeholder, text: $text)
                        .font(.body)
                        .focused($isFocused)
                        .submitLabel(.search)
                        .onSubmit {
                            onSubmit?()
                        }
                    
                    if !text.isEmpty {
                        Button {
                            withAnimation(reduceMotion ? .none : .spring(response: 0.2, dampingFraction: 0.8)) {
                                text = ""
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .glassEffect(.regular, in: .capsule)
                .glassEffectID("searchField", in: namespace)
                
                // Cancel button
                if showsCancelButton && isFocused {
                    Button("Cancel") {
                        withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7)) {
                            isFocused = false
                            text = ""
                            onCancel?()
                        }
                    }
                    .font(.body)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .glassEffectID("cancel", in: namespace)
                }
            }
            .animation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
    }
}

// MARK: - GlassNavLink

/// A navigation link styled with glass effects
@available(iOS 26.0, macOS 26.0, *)
public struct GlassNavLink<Destination: View, Label: View>: View {
    private let destination: Destination
    private let label: Label
    
    @Namespace private var namespace
    
    public init(
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder label: () -> Label
    ) {
        self.destination = destination()
        self.label = label()
    }
    
    public var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack {
                label
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .glassEffectID(UUID().uuidString, in: namespace)
    }
}

// MARK: - GlassBreadcrumb

/// A breadcrumb navigation component with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassBreadcrumb: View {
    let items: [BreadcrumbItem]
    let onSelect: (Int) -> Void
    
    @Namespace private var namespace
    
    public struct BreadcrumbItem: Identifiable {
        public let id = UUID()
        public let title: String
        public let icon: String?
        
        public init(title: String, icon: String? = nil) {
            self.title = title
            self.icon = icon
        }
    }
    
    public init(items: [BreadcrumbItem], onSelect: @escaping (Int) -> Void) {
        self.items = items
        self.onSelect = onSelect
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: 4) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        breadcrumbItem(item, at: index)
                        
                        if index < items.count - 1 {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
        }
    }
    
    @ViewBuilder
    private func breadcrumbItem(_ item: BreadcrumbItem, at index: Int) -> some View {
        let isLast = index == items.count - 1
        
        Button {
            onSelect(index)
        } label: {
            HStack(spacing: 4) {
                if let icon = item.icon {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium))
                }
                
                Text(item.title)
                    .font(.system(size: 13, weight: isLast ? .semibold : .regular))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .foregroundStyle(isLast ? .primary : .secondary)
        }
        .buttonStyle(.plain)
        .glassEffect(isLast ? .regular : .clear, in: .capsule)
        .glassEffectID("breadcrumb-\(index)", in: namespace)
    }
}

// MARK: - GlassPageIndicator

/// A page indicator with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassPageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    let tintColor: Color
    
    @Namespace private var namespace
    
    public init(
        currentPage: Int,
        totalPages: Int,
        tintColor: Color = .white
    ) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.tintColor = tintColor
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: 6) {
            HStack(spacing: 6) {
                ForEach(0..<totalPages, id: \.self) { page in
                    Capsule()
                        .fill(page == currentPage ? tintColor : tintColor.opacity(0.3))
                        .frame(width: page == currentPage ? 20 : 8, height: 8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        .glassEffectID("page-\(page)", in: namespace)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .glassEffect(.regular, in: .capsule)
        }
    }
}

// MARK: - AnyShape Helper

struct AnyShape: Shape {
    private let pathBuilder: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        pathBuilder = { rect in
            shape.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
struct GlassNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Standard nav bar
                GlassNavigationBar(
                    title: "Settings",
                    subtitle: "Configure your app",
                    onBack: { }
                ) {
                    Button {
                    } label: {
                        Image(systemName: "gear")
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                }
                
                // Search bar
                GlassSearchBar(text: .constant(""))
                
                // Floating nav bar
                GlassNavigationBar(
                    title: "Floating",
                    configuration: .floating,
                    onBack: { }
                )
                
                // Large nav bar
                GlassNavigationBar(
                    title: "Large Title",
                    subtitle: "With subtitle",
                    configuration: .large
                )
                
                // Page indicator
                GlassPageIndicator(currentPage: 2, totalPages: 5)
                
                Spacer()
            }
            .padding()
        }
    }
}
