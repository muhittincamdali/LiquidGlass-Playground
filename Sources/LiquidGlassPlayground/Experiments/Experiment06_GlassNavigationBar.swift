//
//  Experiment06_GlassNavigationBar.swift
//  LiquidGlass-Playground
//
//  Experiment #6: Glass Navigation Bar
//  Build beautiful navigation components with Liquid Glass.
//

import SwiftUI

// MARK: - Glass Navigation Bar Experiment

/// Demonstrates creating navigation bars with Liquid Glass effects.
///
/// Navigation bars are perfect candidates for Liquid Glass since they
/// sit in the "navigation layer" above content. iOS 26 automatically
/// applies glass to system navigation, but you can create custom ones.
///
/// ## Key Concepts:
/// - Glass navigation bars float above content
/// - Back buttons with morphing transitions
/// - Toolbar items with glass styling
///
@available(iOS 26.0, macOS 26.0, *)
public struct Experiment06_GlassNavigationBar: View {
    
    // MARK: - State
    
    @State private var navStyle: NavStyle = .standard
    @State private var showSettings = false
    @State private var searchText = ""
    @State private var showCode = false
    @Namespace private var navNamespace
    
    // MARK: - Types
    
    enum NavStyle: String, CaseIterable, Identifiable {
        case standard = "Standard"
        case large = "Large"
        case floating = "Floating"
        case search = "Search"
        
        var id: String { rawValue }
    }
    
    // MARK: - Body
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .top) {
            // Background content
            ScrollView {
                VStack(spacing: 24) {
                    // Spacer for nav bar
                    Color.clear.frame(height: navBarHeight)
                    
                    headerSection
                    styleSelector
                    navBarPreview
                    toolbarDemo
                    codeSection
                    
                    // Extra content for scrolling
                    ForEach(0..<10, id: \.self) { index in
                        sampleContentCard(index: index)
                    }
                }
                .padding()
            }
            
            // Custom navigation bar
            currentNavBar
        }
        .background(backgroundGradient)
    }
    
    // MARK: - Navigation Bars
    
    @ViewBuilder
    private var currentNavBar: some View {
        switch navStyle {
        case .standard:
            standardNavBar
        case .large:
            largeNavBar
        case .floating:
            floatingNavBar
        case .search:
            searchNavBar
        }
    }
    
    private var standardNavBar: some View {
        GlassEffectContainer {
            HStack(spacing: 16) {
                Button {
                    // Back action
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .glassEffectID("back", in: navNamespace)
                
                Spacer()
                
                Text("Navigation")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .glassEffectID("more", in: navNamespace)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassEffect(.regular, in: Rectangle())
        }
    }
    
    private var largeNavBar: some View {
        GlassEffectContainer {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Button {
                        // Back
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .glassEffectID("back-large", in: navNamespace)
                    
                    Spacer()
                    
                    Button {
                        // Settings
                    } label: {
                        Image(systemName: "gear")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .glassEffectID("settings-large", in: navNamespace)
                }
                
                Text("Large Title")
                    .font(.largeTitle.bold())
                    .padding(.top, 8)
                
                Text("With subtitle text")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular, in: UnevenRoundedRectangle(
                bottomLeadingRadius: 24,
                bottomTrailingRadius: 24
            ))
        }
    }
    
    private var floatingNavBar: some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                Button {
                    // Back
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .glassEffectID("back-float", in: navNamespace)
                
                Text("Floating")
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .glassEffectID("title-float", in: navNamespace)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Button {
                        // Search
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .glassEffectID("search-float", in: navNamespace)
                    
                    Button {
                        // More
                    } label: {
                        Image(systemName: "ellipsis")
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .glassEffectID("more-float", in: navNamespace)
                }
            }
            .padding(8)
            .glassEffect(.regular, in: Capsule())
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var searchNavBar: some View {
        GlassEffectContainer(spacing: 12) {
            HStack(spacing: 12) {
                Button {
                    // Back
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .glassEffectID("back-search", in: navNamespace)
                
                // Search field
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(.plain)
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .glassEffect(.regular, in: Capsule())
                .glassEffectID("searchfield", in: navNamespace)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassEffect(.regular, in: Rectangle())
        }
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "menubar.rectangle")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("Experiment #6")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Glass Navigation Bar")
                .font(.title.bold())
                .foregroundStyle(.white)
        }
        .padding(.top, 20)
    }
    
    private var styleSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Navigation Style")
                .font(.headline)
                .foregroundStyle(.white)
            
            Picker("Style", selection: $navStyle.animation(.spring(response: 0.3, dampingFraction: 0.7))) {
                ForEach(NavStyle.allCases) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var navBarPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Style: \(navStyle.rawValue)")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Look at the navigation bar at the top of the screen. Change styles to see different glass navigation patterns.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var toolbarDemo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Toolbar Items")
                .font(.headline)
                .foregroundStyle(.white)
            
            GlassEffectContainer(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(["house", "magnifyingglass", "plus", "heart", "person"], id: \.self) { icon in
                        Button {
                            // Action
                        } label: {
                            Image(systemName: icon)
                                .font(.title3)
                                .frame(width: 48, height: 48)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.roundedRectangle(radius: 12))
                        .glassEffectID("toolbar-\(icon)", in: navNamespace)
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
    
    private func sampleContentCard(index: Int) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white.opacity(0.2))
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Item \(index + 1)")
                    .font(.headline)
                Text("Sample content for scrolling")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Helpers
    
    private var navBarHeight: CGFloat {
        switch navStyle {
        case .standard, .search: return 60
        case .large: return 140
        case .floating: return 70
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.teal, .blue, .indigo],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Glass Navigation Bar
        GlassEffectContainer {
            HStack {
                Button { } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .glassEffectID("back", in: namespace)
                
                Spacer()
                Text("Title")
                Spacer()
                
                Button { } label: {
                    Image(systemName: "ellipsis")
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
            }
            .padding()
            .glassEffect(.regular, in: Rectangle())
        }
        
        // Floating Style
        HStack {
            // ... buttons
        }
        .padding(8)
        .glassEffect(.regular, in: Capsule())
        """
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    Experiment06_GlassNavigationBar()
}
