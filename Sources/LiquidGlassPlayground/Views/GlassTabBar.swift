//
//  GlassTabBar.swift
//  LiquidGlass-Playground
//
//  Custom tab bar components with iOS 26 Liquid Glass effects.
//  Supports morphing animations, badges, and custom layouts.
//

import SwiftUI

// MARK: - GlassTabBarStyle

/// Style variants for glass tab bars
public enum GlassTabBarStyle: String, CaseIterable, Identifiable, Sendable {
    case standard
    case floating
    case compact
    case minimal
    case pill
    case dock
    
    public var id: String { rawValue }
    
    public var height: CGFloat {
        switch self {
        case .standard: return 83
        case .floating: return 64
        case .compact: return 56
        case .minimal: return 48
        case .pill: return 60
        case .dock: return 72
        }
    }
    
    public var cornerRadius: CGFloat {
        switch self {
        case .standard: return 0
        case .floating: return 32
        case .compact: return 24
        case .minimal: return 0
        case .pill: return 30
        case .dock: return 28
        }
    }
    
    public var showsLabels: Bool {
        switch self {
        case .minimal, .pill: return false
        default: return true
        }
    }
}

// MARK: - GlassTabItem

/// Represents a single tab in the tab bar
public struct GlassTabItem: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let icon: String
    public let selectedIcon: String?
    public let badge: String?
    public let tintColor: Color?
    
    public init(
        id: String,
        title: String,
        icon: String,
        selectedIcon: String? = nil,
        badge: String? = nil,
        tintColor: Color? = nil
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon ?? icon + ".fill"
        self.badge = badge
        self.tintColor = tintColor
    }
    
    public static func == (lhs: GlassTabItem, rhs: GlassTabItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - GlassTabBarConfiguration

/// Configuration options for the glass tab bar
public struct GlassTabBarConfiguration: Equatable, Sendable {
    public var style: GlassTabBarStyle
    public var tintColor: Color
    public var unselectedColor: Color
    public var showsShadow: Bool
    public var showsGlassBackground: Bool
    public var horizontalPadding: CGFloat
    public var bottomPadding: CGFloat
    public var animationDuration: Double
    
    public init(
        style: GlassTabBarStyle = .floating,
        tintColor: Color = .blue,
        unselectedColor: Color = .gray,
        showsShadow: Bool = true,
        showsGlassBackground: Bool = true,
        horizontalPadding: CGFloat = 24,
        bottomPadding: CGFloat = 0,
        animationDuration: Double = 0.3
    ) {
        self.style = style
        self.tintColor = tintColor
        self.unselectedColor = unselectedColor
        self.showsShadow = showsShadow
        self.showsGlassBackground = showsGlassBackground
        self.horizontalPadding = horizontalPadding
        self.bottomPadding = bottomPadding
        self.animationDuration = animationDuration
    }
    
    public static let `default` = GlassTabBarConfiguration()
    public static let standard = GlassTabBarConfiguration(style: .standard, horizontalPadding: 0)
    public static let compact = GlassTabBarConfiguration(style: .compact)
    public static let minimal = GlassTabBarConfiguration(style: .minimal)
    public static let pill = GlassTabBarConfiguration(style: .pill)
    public static let dock = GlassTabBarConfiguration(style: .dock, bottomPadding: 8)
}

// MARK: - GlassTabBar

/// A customizable tab bar with Liquid Glass effects
@available(iOS 26.0, macOS 26.0, *)
public struct GlassTabBar: View {
    // MARK: Properties
    
    @Binding var selectedTab: String
    let tabs: [GlassTabItem]
    let configuration: GlassTabBarConfiguration
    let onTabSelected: ((GlassTabItem) -> Void)?
    
    @Namespace private var namespace
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    // MARK: Initialization
    
    public init(
        selectedTab: Binding<String>,
        tabs: [GlassTabItem],
        configuration: GlassTabBarConfiguration = .default,
        onTabSelected: ((GlassTabItem) -> Void)? = nil
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.configuration = configuration
        self.onTabSelected = onTabSelected
    }
    
    // MARK: Body
    
    public var body: some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: tabSpacing) {
                ForEach(tabs) { tab in
                    tabButton(for: tab)
                }
            }
            .padding(.horizontal, configuration.horizontalPadding)
            .frame(height: configuration.style.height)
            .background(backgroundView)
            .clipShape(tabBarShape)
            .shadow(
                color: configuration.showsShadow ? shadowColor : .clear,
                radius: 12,
                y: -4
            )
            .padding(.bottom, configuration.bottomPadding)
        }
    }
    
    // MARK: Tab Button
    
    @ViewBuilder
    private func tabButton(for tab: GlassTabItem) -> some View {
        let isSelected = selectedTab == tab.id
        let effectiveTint = tab.tintColor ?? configuration.tintColor
        
        Button {
            selectTab(tab)
        } label: {
            tabContent(for: tab, isSelected: isSelected, tint: effectiveTint)
        }
        .buttonStyle(.plain)
        .glassEffectID(tab.id, in: namespace)
    }
    
    @ViewBuilder
    private func tabContent(for tab: GlassTabItem, isSelected: Bool, tint: Color) -> some View {
        VStack(spacing: configuration.style.showsLabels ? 4 : 0) {
            ZStack(alignment: .topTrailing) {
                // Icon
                Image(systemName: isSelected ? (tab.selectedIcon ?? tab.icon) : tab.icon)
                    .font(.system(size: iconSize, weight: isSelected ? .semibold : .regular))
                    .symbolEffect(.bounce, value: isSelected)
                    .frame(width: iconContainerSize, height: iconContainerSize)
                    .background {
                        if isSelected && configuration.style == .pill {
                            Capsule()
                                .fill(tint.opacity(0.2))
                                .matchedGeometryEffect(id: "selection", in: namespace)
                        }
                    }
                
                // Badge
                if let badge = tab.badge {
                    badgeView(badge)
                }
            }
            
            // Label
            if configuration.style.showsLabels {
                Text(tab.title)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .lineLimit(1)
            }
        }
        .foregroundStyle(isSelected ? tint : configuration.unselectedColor)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private func badgeView(_ badge: String) -> some View {
        Text(badge)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, badge.count > 1 ? 5 : 0)
            .frame(minWidth: 16, minHeight: 16)
            .background(Color.red)
            .clipShape(Capsule())
            .offset(x: 8, y: -4)
    }
    
    // MARK: Background
    
    @ViewBuilder
    private var backgroundView: some View {
        if configuration.showsGlassBackground && !reduceTransparency {
            Color.clear
                .glassEffect(.regular, in: tabBarShape)
        } else if reduceTransparency {
            Color(UIColor.secondarySystemBackground)
        } else {
            Color.clear
        }
    }
    
    // MARK: Computed Properties
    
    private var tabBarShape: some Shape {
        if configuration.style.cornerRadius > 0 {
            return AnyShape(RoundedRectangle(cornerRadius: configuration.style.cornerRadius, style: .continuous))
        }
        return AnyShape(Rectangle())
    }
    
    private var tabSpacing: CGFloat {
        switch configuration.style {
        case .pill: return 8
        case .minimal: return 16
        default: return 0
        }
    }
    
    private var iconSize: CGFloat {
        switch configuration.style {
        case .compact, .minimal: return 20
        case .dock: return 26
        default: return 22
        }
    }
    
    private var iconContainerSize: CGFloat {
        switch configuration.style {
        case .pill: return 44
        case .dock: return 48
        default: return 28
        }
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? .black.opacity(0.5) : .black.opacity(0.15)
    }
    
    // MARK: Actions
    
    private func selectTab(_ tab: GlassTabItem) {
        let animation: Animation? = reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7)
        
        withAnimation(animation) {
            selectedTab = tab.id
        }
        
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
        
        onTabSelected?(tab)
    }
}

// MARK: - GlassTabView

/// A complete tab view with glass tab bar
@available(iOS 26.0, macOS 26.0, *)
public struct GlassTabView<Content: View>: View {
    @Binding var selectedTab: String
    let tabs: [GlassTabItem]
    let configuration: GlassTabBarConfiguration
    let content: (String) -> Content
    
    public init(
        selectedTab: Binding<String>,
        tabs: [GlassTabItem],
        configuration: GlassTabBarConfiguration = .default,
        @ViewBuilder content: @escaping (String) -> Content
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.configuration = configuration
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            content(selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Tab bar
            GlassTabBar(
                selectedTab: $selectedTab,
                tabs: tabs,
                configuration: configuration
            )
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - GlassFloatingTabBar

/// A floating tab bar that can be positioned anywhere
@available(iOS 26.0, macOS 26.0, *)
public struct GlassFloatingTabBar: View {
    @Binding var selectedTab: String
    let tabs: [GlassTabItem]
    let tintColor: Color
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        selectedTab: Binding<String>,
        tabs: [GlassTabItem],
        tintColor: Color = .blue
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.tintColor = tintColor
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(tabs) { tab in
                    floatingTabButton(for: tab)
                }
            }
            .padding(8)
            .glassEffect(.regular, in: .capsule)
        }
    }
    
    @ViewBuilder
    private func floatingTabButton(for tab: GlassTabItem) -> some View {
        let isSelected = selectedTab == tab.id
        let effectiveTint = tab.tintColor ?? tintColor
        
        Button {
            withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab.id
            }
        } label: {
            Image(systemName: isSelected ? (tab.selectedIcon ?? tab.icon) : tab.icon)
                .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : .secondary)
                .frame(width: 44, height: 44)
                .background {
                    if isSelected {
                        Circle()
                            .fill(effectiveTint)
                            .matchedGeometryEffect(id: "floatingSelection", in: namespace)
                    }
                }
        }
        .buttonStyle(.plain)
        .glassEffectID("floating-\(tab.id)", in: namespace)
    }
}

// MARK: - GlassSideTabBar

/// A vertical sidebar tab bar with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassSideTabBar: View {
    @Binding var selectedTab: String
    let tabs: [GlassTabItem]
    let width: CGFloat
    let showsLabels: Bool
    let tintColor: Color
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        selectedTab: Binding<String>,
        tabs: [GlassTabItem],
        width: CGFloat = 72,
        showsLabels: Bool = true,
        tintColor: Color = .blue
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.width = width
        self.showsLabels = showsLabels
        self.tintColor = tintColor
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: 8) {
            VStack(spacing: 8) {
                ForEach(tabs) { tab in
                    sideTabButton(for: tab)
                }
                
                Spacer()
            }
            .padding(.vertical, 16)
            .frame(width: width)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
    
    @ViewBuilder
    private func sideTabButton(for tab: GlassTabItem) -> some View {
        let isSelected = selectedTab == tab.id
        let effectiveTint = tab.tintColor ?? tintColor
        
        Button {
            withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab.id
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? (tab.selectedIcon ?? tab.icon) : tab.icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .symbolEffect(.bounce, value: isSelected)
                
                if showsLabels {
                    Text(tab.title)
                        .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                        .lineLimit(1)
                }
            }
            .foregroundStyle(isSelected ? effectiveTint : .secondary)
            .frame(width: width - 16, height: showsLabels ? 56 : 44)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(effectiveTint.opacity(0.15))
                        .matchedGeometryEffect(id: "sideSelection", in: namespace)
                }
            }
        }
        .buttonStyle(.plain)
        .glassEffectID("side-\(tab.id)", in: namespace)
    }
}

// MARK: - GlassTabBarAccessory

/// An accessory view that appears above the tab bar
@available(iOS 26.0, macOS 26.0, *)
public struct GlassTabBarAccessory<Content: View>: View {
    let content: Content
    let isExpanded: Bool
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        isExpanded: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.isExpanded = isExpanded
        self.content = content()
    }
    
    public var body: some View {
        if isExpanded {
            GlassEffectContainer {
                content
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            ))
            .glassEffectID("accessory", in: namespace)
        }
    }
}

// MARK: - GlassTabIndicator

/// A minimal tab indicator with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassTabIndicator: View {
    let currentIndex: Int
    let totalCount: Int
    let tintColor: Color
    
    @Namespace private var namespace
    
    public init(
        currentIndex: Int,
        totalCount: Int,
        tintColor: Color = .blue
    ) {
        self.currentIndex = currentIndex
        self.totalCount = totalCount
        self.tintColor = tintColor
    }
    
    public var body: some View {
        GlassEffectContainer(spacing: 4) {
            HStack(spacing: 4) {
                ForEach(0..<totalCount, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? tintColor : tintColor.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentIndex ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
                        .glassEffectID("indicator-\(index)", in: namespace)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .glassEffect(.regular, in: .capsule)
        }
    }
}

// MARK: - GlassScrollingTabBar

/// A horizontally scrolling tab bar for many tabs
@available(iOS 26.0, macOS 26.0, *)
public struct GlassScrollingTabBar: View {
    @Binding var selectedTab: String
    let tabs: [GlassTabItem]
    let tintColor: Color
    
    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        selectedTab: Binding<String>,
        tabs: [GlassTabItem],
        tintColor: Color = .blue
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.tintColor = tintColor
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            GlassEffectContainer(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(tabs) { tab in
                        scrollingTabButton(for: tab)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .frame(height: 56)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
    
    @ViewBuilder
    private func scrollingTabButton(for tab: GlassTabItem) -> some View {
        let isSelected = selectedTab == tab.id
        let effectiveTint = tab.tintColor ?? tintColor
        
        Button {
            withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab.id
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isSelected ? (tab.selectedIcon ?? tab.icon) : tab.icon)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                
                if isSelected {
                    Text(tab.title)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(1)
                }
            }
            .foregroundStyle(isSelected ? .white : .secondary)
            .padding(.horizontal, isSelected ? 16 : 12)
            .padding(.vertical, 8)
            .background {
                if isSelected {
                    Capsule()
                        .fill(effectiveTint)
                        .matchedGeometryEffect(id: "scrollingSelection", in: namespace)
                }
            }
        }
        .buttonStyle(.plain)
        .glassEffectID("scrolling-\(tab.id)", in: namespace)
    }
}

// MARK: - GlassBottomBar

/// A customizable bottom bar with glass styling
@available(iOS 26.0, macOS 26.0, *)
public struct GlassBottomBar<Content: View>: View {
    let content: Content
    let height: CGFloat
    let cornerRadius: CGFloat
    let showsShadow: Bool
    
    public init(
        height: CGFloat = 64,
        cornerRadius: CGFloat = 0,
        showsShadow: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.height = height
        self.cornerRadius = cornerRadius
        self.showsShadow = showsShadow
    }
    
    public var body: some View {
        GlassEffectContainer {
            content
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .glassEffect(.regular, in: bottomBarShape)
                .shadow(
                    color: showsShadow ? .black.opacity(0.1) : .clear,
                    radius: 8,
                    y: -4
                )
        }
    }
    
    private var bottomBarShape: some Shape {
        if cornerRadius > 0 {
            return AnyShape(UnevenRoundedRectangle(
                topLeadingRadius: cornerRadius,
                topTrailingRadius: cornerRadius
            ))
        }
        return AnyShape(Rectangle())
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
struct GlassTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Floating tab bar
                GlassFloatingTabBar(
                    selectedTab: .constant("home"),
                    tabs: [
                        GlassTabItem(id: "home", title: "Home", icon: "house"),
                        GlassTabItem(id: "search", title: "Search", icon: "magnifyingglass"),
                        GlassTabItem(id: "favorites", title: "Favorites", icon: "heart", badge: "3"),
                        GlassTabItem(id: "profile", title: "Profile", icon: "person")
                    ]
                )
                
                Spacer().frame(height: 20)
                
                // Standard tab bar
                GlassTabBar(
                    selectedTab: .constant("home"),
                    tabs: [
                        GlassTabItem(id: "home", title: "Home", icon: "house"),
                        GlassTabItem(id: "explore", title: "Explore", icon: "safari"),
                        GlassTabItem(id: "add", title: "Add", icon: "plus.circle", tintColor: .orange),
                        GlassTabItem(id: "inbox", title: "Inbox", icon: "envelope", badge: "12"),
                        GlassTabItem(id: "settings", title: "Settings", icon: "gear")
                    ],
                    configuration: .floating
                )
            }
            .padding()
        }
    }
}
