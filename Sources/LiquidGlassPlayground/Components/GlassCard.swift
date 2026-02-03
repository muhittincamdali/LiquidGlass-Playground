// GlassCard.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Glass Card

/// A versatile card component with Liquid Glass styling.
///
/// Glass cards provide beautiful containers for content with
/// blur effects, borders, and shadows.
///
/// ## Usage
/// ```swift
/// GlassCard {
///     Text("Content goes here")
/// }
/// ```
struct GlassCard<Content: View>: View {
    
    // MARK: - Properties
    
    /// The content to display inside the card.
    let content: Content
    
    /// The corner radius of the card.
    var cornerRadius: CGFloat = 16
    
    /// The padding inside the card.
    var padding: CGFloat = 16
    
    /// Whether to show a border.
    var showBorder: Bool = true
    
    /// Whether to show a shadow.
    var showShadow: Bool = true
    
    /// The tint color overlay.
    var tintColor: Color? = nil
    
    /// The tint opacity.
    var tintOpacity: Double = 0.1
    
    // MARK: - Initialization
    
    init(
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        showBorder: Bool = true,
        showShadow: Bool = true,
        tintColor: Color? = nil,
        tintOpacity: Double = 0.1,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.showBorder = showBorder
        self.showShadow = showShadow
        self.tintColor = tintColor
        self.tintOpacity = tintOpacity
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        content
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            }
            .background {
                if let tint = tintColor {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(tint.opacity(tintOpacity))
                }
            }
            .overlay {
                if showBorder {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.5),
                                    .white.opacity(0.1),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                }
            }
            .if(showShadow) { view in
                view.shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Glass Info Card

/// A card for displaying information with an icon and title.
struct GlassInfoCard: View {
    
    let icon: String
    let title: String
    let subtitle: String?
    var iconColor: Color = .accentColor
    
    init(icon: String, title: String, subtitle: String? = nil, iconColor: Color = .accentColor) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.iconColor = iconColor
    }
    
    var body: some View {
        GlassCard {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(iconColor)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Glass Stat Card

/// A card for displaying statistics.
struct GlassStatCard: View {
    
    let title: String
    let value: String
    let icon: String
    var trend: StatTrend? = nil
    var color: Color = .accentColor
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(color)
                    
                    Spacer()
                    
                    if let trend = trend {
                        trendBadge(trend)
                    }
                }
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private func trendBadge(_ trend: StatTrend) -> some View {
        HStack(spacing: 2) {
            Image(systemName: trend.icon)
            Text(trend.value)
        }
        .font(.caption2)
        .foregroundStyle(trend.color)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(trend.color.opacity(0.1))
        .clipShape(Capsule())
    }
}

/// Trend information for stat cards.
struct StatTrend {
    let value: String
    let isPositive: Bool
    
    var icon: String {
        isPositive ? "arrow.up.right" : "arrow.down.right"
    }
    
    var color: Color {
        isPositive ? .green : .red
    }
}

// MARK: - Glass Feature Card

/// A card for highlighting features.
struct GlassFeatureCard: View {
    
    let icon: String
    let title: String
    let description: String
    var iconColor: Color = .accentColor
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            action?()
        } label: {
            GlassCard {
                VStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .foregroundStyle(iconColor)
                    
                    Text(title)
                        .font(.headline)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.plain)
        .disabled(action == nil)
    }
}

// MARK: - Glass List Card

/// A card optimized for list items.
struct GlassListCard<Accessory: View>: View {
    
    let title: String
    let subtitle: String?
    let icon: String?
    let accessory: Accessory
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        @ViewBuilder accessory: () -> Accessory = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.accessory = accessory()
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.accentColor)
                    .frame(width: 32)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            accessory
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Glass Expandable Card

/// A card that can expand to show more content.
struct GlassExpandableCard<Header: View, Content: View>: View {
    
    let header: Header
    let content: Content
    
    @State private var isExpanded = false
    
    init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.content = content()
    }
    
    var body: some View {
        GlassCard(padding: 0) {
            VStack(spacing: 0) {
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack {
                        header
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                .buttonStyle(.plain)
                
                if isExpanded {
                    Divider()
                    
                    content
                        .padding()
                }
            }
        }
    }
}

// MARK: - View Extension

extension View {
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Preview

#Preview("Glass Cards") {
    ScrollView {
        VStack(spacing: 16) {
            GlassCard {
                Text("Basic Glass Card")
                    .frame(maxWidth: .infinity)
            }
            
            GlassInfoCard(
                icon: "sparkles",
                title: "New Feature",
                subtitle: "Check out the latest updates",
                iconColor: .yellow
            )
            
            HStack {
                GlassStatCard(
                    title: "Users",
                    value: "1.2K",
                    icon: "person.2",
                    trend: StatTrend(value: "+12%", isPositive: true)
                )
                
                GlassStatCard(
                    title: "Revenue",
                    value: "$5.4K",
                    icon: "dollarsign.circle",
                    trend: StatTrend(value: "-3%", isPositive: false)
                )
            }
            
            GlassFeatureCard(
                icon: "wand.and.stars",
                title: "Magic Effects",
                description: "Create stunning visual effects with ease"
            )
        }
        .padding()
    }
}
