// PlaygroundApp.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Main Application Entry Point

/// The main entry point for the Liquid Glass Playground application.
///
/// This application provides an interactive environment for experimenting
/// with iOS 26 Liquid Glass effects in real-time.
///
/// ## Overview
/// The playground allows developers to:
/// - Experiment with glass effect parameters
/// - Preview changes in real-time
/// - Export generated Swift code
/// - Learn through interactive tutorials
///
/// ## Topics
/// ### Getting Started
/// - ``PlaygroundApp/body``
/// - ``AppState``
@main
struct PlaygroundApp: App {
    
    // MARK: - Properties
    
    /// The shared application state observable object.
    @StateObject private var appState = AppState()
    
    /// Environment value for the current color scheme.
    @Environment(\.colorScheme) private var colorScheme
    
    /// Storage for user preferences.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    /// Storage for preferred appearance mode.
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system
    
    /// Storage for haptic feedback preference.
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environment(\.glassEnvironment, GlassEnvironment.current)
                .preferredColorScheme(preferredColorScheme)
                .onAppear {
                    configureApplication()
                }
        }
        .commands {
            PlaygroundCommands(appState: appState)
        }
        
        #if os(macOS)
        Settings {
            SettingsView()
                .environmentObject(appState)
        }
        
        Window("Code Preview", id: "code-preview") {
            CodePreview(parameters: appState.currentParameters)
                .environmentObject(appState)
        }
        
        Window("Experiment Gallery", id: "experiment-gallery") {
            ExperimentList(selectedExperiment: $appState.selectedExperiment)
                .environmentObject(appState)
        }
        #endif
    }
    
    // MARK: - Private Methods
    
    /// Configures the application on launch.
    private func configureApplication() {
        configureAppearance()
        loadUserPreferences()
        registerNotifications()
    }
    
    /// Configures the global appearance settings.
    private func configureAppearance() {
        #if os(iOS)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        #endif
    }
    
    /// Loads saved user preferences from storage.
    private func loadUserPreferences() {
        appState.hapticsEnabled = hapticsEnabled
        appState.hasCompletedOnboarding = hasCompletedOnboarding
    }
    
    /// Registers for system notifications.
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            appState.applicationDidBecomeActive()
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            appState.applicationWillResignActive()
        }
    }
    
    /// Computes the preferred color scheme based on user settings.
    private var preferredColorScheme: ColorScheme? {
        switch appearanceMode {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

// MARK: - Root View

/// The root view that handles navigation and onboarding.
struct RootView: View {
    
    @EnvironmentObject private var appState: AppState
    @State private var showOnboarding = false
    
    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView(isPresented: $showOnboarding)
            }
        }
        .onAppear {
            showOnboarding = !appState.hasCompletedOnboarding
        }
    }
}

// MARK: - Onboarding View

/// The onboarding view shown on first launch.
struct OnboardingView: View {
    
    @Binding var isPresented: Bool
    @EnvironmentObject private var appState: AppState
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Liquid Glass Playground",
            description: "Explore and experiment with iOS 26's stunning glass effects.",
            systemImage: "sparkles.rectangle.stack"
        ),
        OnboardingPage(
            title: "Real-time Preview",
            description: "See your changes instantly with live previews.",
            systemImage: "eye.fill"
        ),
        OnboardingPage(
            title: "Export Your Code",
            description: "Generate production-ready Swift code for your projects.",
            systemImage: "doc.text.fill"
        )
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            Button(action: completeOnboarding) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.glassEffect)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 40)
        }
        .padding(.vertical)
    }
    
    private func completeOnboarding() {
        if currentPage < pages.count - 1 {
            withAnimation {
                currentPage += 1
            }
        } else {
            appState.hasCompletedOnboarding = true
            isPresented = false
        }
    }
}

// MARK: - Onboarding Page Model

/// Model representing an onboarding page.
struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let systemImage: String
}

// MARK: - Onboarding Page View

/// View for displaying a single onboarding page.
struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: page.systemImage)
                .font(.system(size: 80))
                .foregroundStyle(.tint)
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

// MARK: - Playground Commands

/// Custom menu commands for the playground.
struct PlaygroundCommands: Commands {
    
    @ObservedObject var appState: AppState
    
    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Button("New Experiment") {
                appState.createNewExperiment()
            }
            .keyboardShortcut("n", modifiers: .command)
            
            Divider()
            
            Button("Reset to Defaults") {
                appState.resetToDefaults()
            }
            .keyboardShortcut("r", modifiers: [.command, .shift])
        }
        
        CommandMenu("Playground") {
            Button("Toggle Preview") {
                appState.isPreviewVisible.toggle()
            }
            .keyboardShortcut("p", modifiers: .command)
            
            Button("Toggle Controls") {
                appState.isControlPanelVisible.toggle()
            }
            .keyboardShortcut("k", modifiers: .command)
            
            Divider()
            
            Button("Export Code") {
                appState.exportCode()
            }
            .keyboardShortcut("e", modifiers: [.command, .shift])
        }
    }
}

// MARK: - Appearance Mode

/// The available appearance modes for the application.
enum AppearanceMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}
