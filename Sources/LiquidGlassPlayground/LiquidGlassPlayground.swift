//
//  LiquidGlassPlayground.swift
//  LiquidGlass-Playground
//
//  The main entry point for the Liquid Glass Playground library.
//  A comprehensive learning resource for iOS 26's Liquid Glass design.
//
//  Created by Muhittin Camdali
//  Copyright © 2025. All rights reserved.
//

import SwiftUI

// MARK: - LiquidGlassPlayground

/// The main entry point for the Liquid Glass Playground.
///
/// Use this struct to launch the playground experience:
///
/// ```swift
/// import LiquidGlassPlayground
///
/// @main
/// struct MyApp: App {
///     var body: some Scene {
///         WindowGroup {
///             LiquidGlassPlayground.mainView
///         }
///     }
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public enum LiquidGlassPlayground {
    
    /// The current version of the playground.
    public static let version = "2.0.0"
    
    /// The minimum iOS version required.
    public static let minimumIOSVersion = "26.0"
    
    /// The main view of the playground.
    public static var mainView: some View {
        ExperimentsIndexView()
    }
    
    /// A view that shows all experiments in a list.
    public static var experimentsView: some View {
        ExperimentsIndexView()
    }
    
    /// The playground configuration view.
    public static var playgroundView: some View {
        PlaygroundView()
    }
    
    /// Information about the library.
    public static let info = LibraryInfo(
        name: "LiquidGlass-Playground",
        description: "Interactive Swift Playground for exploring iOS 26's Liquid Glass effects",
        author: "Muhittin Camdali",
        repository: "https://github.com/muhittincamdali/LiquidGlass-Playground",
        license: "MIT"
    )
    
    /// Library metadata.
    public struct LibraryInfo: Sendable {
        public let name: String
        public let description: String
        public let author: String
        public let repository: String
        public let license: String
    }
}

// MARK: - Quick Start Views

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassPlayground {
    
    /// A quick demo view showcasing Liquid Glass capabilities.
    public static var quickDemo: some View {
        QuickDemoView()
    }
}

// MARK: - Quick Demo View

@available(iOS 26.0, macOS 26.0, *)
struct QuickDemoView: View {
    
    @State private var isExpanded = false
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.white)
                    
                    Text("Liquid Glass")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    
                    Text("iOS 26")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                // Demo Card
                VStack(spacing: 16) {
                    Text("Native iOS 26 API")
                        .font(.headline)
                    
                    Text("This card uses the real .glassEffect() modifier introduced in iOS 26.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    GlassEffectContainer(spacing: 12) {
                        HStack(spacing: 12) {
                            Button {
                                withAnimation(.bouncy) {
                                    isExpanded.toggle()
                                }
                            } label: {
                                Image(systemName: isExpanded ? "minus" : "plus")
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                            }
                            .buttonStyle(.glass)
                            .buttonBorderShape(.circle)
                            .glassEffectID("demo-button", in: namespace)
                            
                            if isExpanded {
                                Text("Morphing Glass!")
                                    .font(.headline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .glassEffect(.regular.tint(.blue.opacity(0.3)), in: .capsule)
                                    .transition(.scale.combined(with: .opacity))
                                    .glassEffectID("demo-text", in: namespace)
                            }
                        }
                    }
                }
                .padding(24)
                .frame(maxWidth: 320)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
                
                // Button
                Button("Explore Experiments") {
                    // Navigation would go here
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.capsule)
            }
            .padding()
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview("Main View") {
    LiquidGlassPlayground.mainView
}

@available(iOS 26.0, macOS 26.0, *)
#Preview("Quick Demo") {
    LiquidGlassPlayground.quickDemo
}
