//
//  Experiment07_GlassTabBar.swift
//  LiquidGlass-Playground
//
//  Experiment #7: Glass Tab Bar
//  Create stunning tab bars with Liquid Glass and morphing.
//

import SwiftUI

// MARK: - Glass Tab Bar Experiment

/// Demonstrates creating tab bars with Liquid Glass effects.
///
/// Tab bars are essential navigation components. With Liquid Glass,
/// they become floating, translucent elements that morph as users
/// switch between tabs.
///
/// ## Key Concepts:
/// - GlassEffectContainer for tab morphing
/// - Selection indicators with matchedGeometryEffect
/// - Floating vs docked tab bar styles
///
@available(iOS 26.0, macOS 26.0, *)
public struct Experiment07_GlassTabBar: View {
    
    // MARK: - State
    
    @State private var selectedTab = 0
    @State private var tabStyle: TabStyle = .floating
    @State private var showCode = false
    @Namespace private var tabNamespace
    
    // MARK: - Types
    
    enum TabStyle: String, CaseIterable, Identifiable {
        case floating = "Floating"
        case docked = "Docked"
        case pill = "Pill"
        case minimal = "Minimal"
        
        var id: String { rawValue }
    }
    
    // MARK: - Constants
    
    private let tabs: [(icon: String, label: String)] = [
        ("house.fill", "Home"),
        ("magnifyingglass", "Search"),
        ("plus.circle.fill", "Create"),
        ("heart.fill", "Activity"),
        ("person.fill", "Profile")
    ]
    
    // MARK: - Body
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    styleSelector
                    tabPreview
                    badgeDemo
                    codeSection
                    
                    // Extra space for tab bar
                    Color.clear.frame(height: 100)
                }
                .padding()
            }
            
            // Tab Bar
            currentTabBar
        }
        .background(backgroundGradient)
    }
    
    // MARK: - Tab Bars
    
    @ViewBuilder
    private var currentTabBar: some View {
        switch tabStyle {
        case .floating:
            floatingTabBar
        case .docked:
            dockedTabBar
        case .pill:
            pillTabBar
        case .minimal:
            minimalTabBar
        }
    }
    
    private var floatingTabBar: some View {
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    tabButton(index: index, showLabel: true)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .glassEffect(.regular, in: Capsule())
            .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    private var dockedTabBar: some View {
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    tabButton(index: index, showLabel: true)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 28)
            .glassEffect(.regular, in: UnevenRoundedRectangle(
                topLeadingRadius: 24,
                topTrailingRadius: 24
            ))
        }
    }
    
    private var pillTabBar: some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    pillTabButton(index: index)
                }
            }
            .padding(8)
            .glassEffect(.regular, in: Capsule())
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    private var minimalTabBar: some View {
        GlassEffectContainer(spacing: 16) {
            HStack(spacing: 16) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    minimalTabButton(index: index)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Tab Buttons
    
    private func tabButton(index: Int, showLabel: Bool) -> some View {
        let isSelected = selectedTab == index
        let tab = tabs[index]
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .symbolEffect(.bounce, value: isSelected)
                
                if showLabel {
                    Text(tab.label)
                        .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                }
            }
            .foregroundStyle(isSelected ? .blue : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background {
                if isSelected {
                    Capsule()
                        .fill(.blue.opacity(0.15))
                        .matchedGeometryEffect(id: "tabSelection", in: tabNamespace)
                }
            }
        }
        .buttonStyle(.plain)
        .glassEffectID("tab-\(index)", in: tabNamespace)
    }
    
    private func pillTabButton(index: Int) -> some View {
        let isSelected = selectedTab == index
        let tab = tabs[index]
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: 18, weight: isSelected ? .semibold : .regular))
                
                if isSelected {
                    Text(tab.label)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, isSelected ? 16 : 12)
            .padding(.vertical, 12)
            .background {
                if isSelected {
                    Capsule()
                        .fill(.blue)
                        .matchedGeometryEffect(id: "pillSelection", in: tabNamespace)
                }
            }
        }
        .buttonStyle(.plain)
        .glassEffectID("pill-\(index)", in: tabNamespace)
    }
    
    private func minimalTabButton(index: Int) -> some View {
        let isSelected = selectedTab == index
        let tab = tabs[index]
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .blue : .secondary)
                
                Circle()
                    .fill(isSelected ? .blue : .clear)
                    .frame(width: 5, height: 5)
            }
        }
        .buttonStyle(.plain)
        .glassEffectID("minimal-\(index)", in: tabNamespace)
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "dock.rectangle")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("Experiment #7")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Glass Tab Bar")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Selected: \(tabs[selectedTab].label)")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    private var styleSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tab Bar Style")
                .font(.headline)
                .foregroundStyle(.white)
            
            Picker("Style", selection: $tabStyle.animation(.spring(response: 0.3, dampingFraction: 0.7))) {
                ForEach(TabStyle.allCases) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var tabPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Tab: \(tabs[selectedTab].label)")
                .font(.headline)
                .foregroundStyle(.white)
            
            // Tab content preview
            VStack(spacing: 16) {
                Image(systemName: tabs[selectedTab].icon)
                    .font(.system(size: 48))
                    .foregroundStyle(.blue)
                    .contentTransition(.symbolEffect(.replace))
                
                Text(tabs[selectedTab].label)
                    .font(.title2.bold())
                    .contentTransition(.numericText())
                
                Text("This is the content for the \(tabs[selectedTab].label) tab.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .glassEffect(.regular.tint(.blue.opacity(0.1)), in: RoundedRectangle(cornerRadius: 20))
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
    }
    
    private var badgeDemo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("With Badges")
                .font(.headline)
                .foregroundStyle(.white)
            
            GlassEffectContainer(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(0..<4, id: \.self) { index in
                        let badge = index == 1 ? "5" : (index == 3 ? "99+" : nil)
                        
                        Button {
                            // Action
                        } label: {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: tabs[index].icon)
                                    .font(.title2)
                                    .frame(width: 56, height: 44)
                                
                                if let badge = badge {
                                    Text(badge)
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(.red)
                                        .clipShape(Capsule())
                                        .offset(x: 8, y: -4)
                                }
                            }
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.roundedRectangle(radius: 12))
                    }
                }
                .padding(8)
                .glassEffect(.regular, in: Capsule())
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
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
    
    // MARK: - Helpers
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.green, .teal, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        @State private var selectedTab = 0
        @Namespace private var namespace
        
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(tabs.indices) { index in
                    Button {
                        withAnimation(.spring()) {
                            selectedTab = index
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tabs[index].icon)
                            Text(tabs[index].label)
                        }
                        .background {
                            if selectedTab == index {
                                Capsule()
                                    .fill(.blue.opacity(0.15))
                                    .matchedGeometryEffect(
                                        id: "selection",
                                        in: namespace
                                    )
                            }
                        }
                    }
                    .glassEffectID("tab-\\(index)", in: namespace)
                }
            }
            .glassEffect(.regular, in: Capsule())
        }
        """
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    Experiment07_GlassTabBar()
}
