// ContentView.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Content View

/// The main content view of the Liquid Glass Playground application.
///
/// This view serves as the primary container for all playground functionality,
/// organizing the interface into experiment selection, preview, and control panels.
///
/// ## Layout
/// The view adapts its layout based on the device and orientation:
/// - **iPad/Mac**: Side-by-side layout with navigation, preview, and controls
/// - **iPhone**: Tab-based navigation with swipeable panels
struct ContentView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var appState: AppState
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var selectedTab: ContentTab = .playground
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var showExperimentPicker = false
    @State private var searchText = ""
    
    // MARK: - Computed Properties
    
    /// Determines if the device has a regular width layout.
    private var isRegularWidth: Bool {
        horizontalSizeClass == .regular
    }
    
    /// Determines if the device is in landscape orientation.
    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if isRegularWidth {
                regularWidthLayout
            } else {
                compactWidthLayout
            }
        }
        .sheet(isPresented: $appState.isSettingsPresented) {
            SettingsView()
                .environmentObject(appState)
        }
        .alert(item: $appState.currentError) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
        .overlay {
            if let tutorial = appState.activeTutorial,
               let step = appState.currentTutorialStep {
                TutorialOverlay(
                    tutorial: tutorial,
                    currentStep: step
                )
            }
        }
    }
    
    // MARK: - Regular Width Layout (iPad/Mac)
    
    /// The layout for devices with regular horizontal size class.
    private var regularWidthLayout: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebarContent
        } content: {
            ExperimentDetailView(experiment: appState.selectedExperiment)
                .environmentObject(appState)
        } detail: {
            PlaygroundView()
                .environmentObject(appState)
        }
        .navigationSplitViewStyle(.balanced)
        .toolbar {
            regularWidthToolbar
        }
    }
    
    /// The sidebar content for navigation.
    private var sidebarContent: some View {
        List(selection: $appState.selectedExperiment) {
            Section("Experiments") {
                ForEach(ExperimentType.allCases) { experiment in
                    NavigationLink(value: experiment) {
                        ExperimentRow(experiment: experiment)
                    }
                }
            }
            
            Section("Presets") {
                ForEach(appState.savedPresets) { preset in
                    PresetRow(preset: preset)
                        .contextMenu {
                            Button(role: .destructive) {
                                appState.deletePreset(preset)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            
            Section("Tutorials") {
                ForEach(TutorialType.allCases) { tutorial in
                    Button {
                        appState.startTutorial(tutorial)
                    } label: {
                        Label(tutorial.displayName, systemImage: "book.fill")
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Playground")
        .searchable(text: $searchText, prompt: "Search experiments")
    }
    
    /// The toolbar items for regular width layout.
    @ToolbarContentBuilder
    private var regularWidthToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                appState.isCodePreviewVisible.toggle()
            } label: {
                Label("Code", systemImage: "chevron.left.forwardslash.chevron.right")
            }
            
            Button {
                appState.exportCode()
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }
            
            Menu {
                Button("Save as Preset") {
                    showExperimentPicker = true
                }
                
                Divider()
                
                Button("Reset to Defaults") {
                    appState.resetToDefaults()
                }
            } label: {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
        
        ToolbarItemGroup(placement: .secondaryAction) {
            Button {
                appState.undo()
            } label: {
                Label("Undo", systemImage: "arrow.uturn.backward")
            }
            .disabled(!appState.canUndo)
            
            Button {
                appState.redo()
            } label: {
                Label("Redo", systemImage: "arrow.uturn.forward")
            }
            .disabled(!appState.canRedo)
        }
    }
    
    // MARK: - Compact Width Layout (iPhone)
    
    /// The layout for devices with compact horizontal size class.
    private var compactWidthLayout: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                PlaygroundView()
                    .environmentObject(appState)
                    .navigationTitle("Playground")
                    .toolbar {
                        compactToolbar
                    }
            }
            .tabItem {
                Label("Playground", systemImage: "rectangle.3.group")
            }
            .tag(ContentTab.playground)
            
            NavigationStack {
                ExperimentList(selectedExperiment: $appState.selectedExperiment)
                    .environmentObject(appState)
            }
            .tabItem {
                Label("Experiments", systemImage: "flask")
            }
            .tag(ContentTab.experiments)
            
            NavigationStack {
                PresetLibraryView()
                    .environmentObject(appState)
            }
            .tabItem {
                Label("Presets", systemImage: "star")
            }
            .tag(ContentTab.presets)
            
            NavigationStack {
                SettingsView()
                    .environmentObject(appState)
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(ContentTab.settings)
        }
    }
    
    /// The toolbar for compact width layout.
    @ToolbarContentBuilder
    private var compactToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button {
                    appState.isCodePreviewVisible.toggle()
                } label: {
                    Label("View Code", systemImage: "chevron.left.forwardslash.chevron.right")
                }
                
                Button {
                    appState.exportCode()
                } label: {
                    Label("Export Code", systemImage: "square.and.arrow.up")
                }
                
                Divider()
                
                Button {
                    showExperimentPicker = true
                } label: {
                    Label("Save Preset", systemImage: "star")
                }
                
                Button(role: .destructive) {
                    appState.resetToDefaults()
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}

// MARK: - Content Tab

/// The available tabs in compact width layout.
enum ContentTab: String, CaseIterable {
    case playground
    case experiments
    case presets
    case settings
}

// MARK: - Experiment Row

/// A row view for displaying an experiment in the sidebar.
struct ExperimentRow: View {
    let experiment: ExperimentType
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(experiment.displayName)
                    .font(.body)
                
                Text(experiment.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: experiment.systemImage)
                .foregroundStyle(experiment.accentColor)
        }
    }
}

// MARK: - Preset Row

/// A row view for displaying a preset in the sidebar.
struct PresetRow: View {
    let preset: GlassPreset
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        Button {
            appState.loadPreset(preset)
        } label: {
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text(preset.name)
                        .font(.body)
                    
                    Text(preset.createdAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } icon: {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
        }
    }
}

// MARK: - Experiment Detail View

/// A detail view showing information about an experiment.
struct ExperimentDetailView: View {
    let experiment: ExperimentType
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: experiment.systemImage)
                        .font(.largeTitle)
                        .foregroundStyle(experiment.accentColor)
                    
                    Text(experiment.displayName)
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                Text(experiment.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                Text("Features")
                    .font(.headline)
                
                ForEach(experiment.features, id: \.self) { feature in
                    Label(feature, systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }
            .padding()
        }
        .navigationTitle(experiment.displayName)
    }
}

// MARK: - Tutorial Overlay

/// An overlay view for displaying tutorial information.
struct TutorialOverlay: View {
    let tutorial: TutorialType
    let currentStep: Int
    
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                HStack {
                    Text("Step \(currentStep + 1)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Button("Exit") {
                        appState.exitTutorial()
                    }
                    .font(.caption)
                }
                
                Text(tutorialStepText)
                    .font(.body)
                
                Button("Next") {
                    appState.nextTutorialStep()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
        }
    }
    
    private var tutorialStepText: String {
        switch (tutorial, currentStep) {
        case (.basic, 0): return "Welcome! Let's learn about glass effects."
        case (.basic, 1): return "Try adjusting the blur slider."
        case (.basic, 2): return "Now let's add some tint color."
        default: return "Continue experimenting!"
        }
    }
}

// MARK: - Preset Library View

/// A view displaying all saved presets.
struct PresetLibraryView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        List {
            if appState.savedPresets.isEmpty {
                ContentUnavailableView(
                    "No Presets",
                    systemImage: "star.slash",
                    description: Text("Save your first preset from the playground")
                )
            } else {
                ForEach(appState.savedPresets) { preset in
                    PresetCard(preset: preset)
                        .onTapGesture {
                            appState.loadPreset(preset)
                        }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        appState.deletePreset(appState.savedPresets[index])
                    }
                }
            }
        }
        .navigationTitle("Presets")
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(AppState())
}
