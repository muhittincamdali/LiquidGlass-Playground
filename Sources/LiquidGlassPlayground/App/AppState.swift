// AppState.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI
import Combine

// MARK: - Application State

/// The central state management class for the Liquid Glass Playground.
///
/// `AppState` manages all shared state across the application, including:
/// - Current glass parameters
/// - Selected experiments
/// - User preferences
/// - Navigation state
///
/// ## Usage
/// ```swift
/// @EnvironmentObject var appState: AppState
///
/// // Access current parameters
/// let blur = appState.currentParameters.blurRadius
///
/// // Update parameters
/// appState.currentParameters.blurRadius = 20
/// ```
@MainActor
final class AppState: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The current glass effect parameters being edited.
    @Published var currentParameters = GlassParameters()
    
    /// The currently selected experiment.
    @Published var selectedExperiment: ExperimentType = .basicGlass
    
    /// The list of saved presets.
    @Published var savedPresets: [GlassPreset] = []
    
    /// Whether the preview panel is visible.
    @Published var isPreviewVisible = true
    
    /// Whether the control panel is visible.
    @Published var isControlPanelVisible = true
    
    /// Whether the code preview is visible.
    @Published var isCodePreviewVisible = false
    
    /// Whether haptic feedback is enabled.
    @Published var hapticsEnabled = true
    
    /// Whether the user has completed onboarding.
    @Published var hasCompletedOnboarding = false
    
    /// The current tutorial step, if a tutorial is active.
    @Published var currentTutorialStep: Int?
    
    /// The active tutorial, if any.
    @Published var activeTutorial: TutorialType?
    
    /// Whether an export operation is in progress.
    @Published var isExporting = false
    
    /// The current navigation path for deep linking.
    @Published var navigationPath = NavigationPath()
    
    /// Recent parameter history for undo support.
    @Published var parameterHistory: [GlassParameters] = []
    
    /// The index of the current position in parameter history.
    @Published var historyIndex: Int = -1
    
    /// Whether there are unsaved changes.
    @Published var hasUnsavedChanges = false
    
    /// The current application error, if any.
    @Published var currentError: AppError?
    
    /// Whether the settings sheet is presented.
    @Published var isSettingsPresented = false
    
    /// The selected background for the preview.
    @Published var selectedBackground: PreviewBackground = .gradient
    
    /// The animation speed multiplier.
    @Published var animationSpeed: Double = 1.0
    
    // MARK: - Private Properties
    
    /// Cancellable storage for Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// The maximum number of history entries to keep.
    private let maxHistoryCount = 50
    
    /// The preset manager instance.
    private let presetManager = PresetManager()
    
    /// The code exporter instance.
    private let codeExporter = CodeExporter()
    
    // MARK: - Initialization
    
    init() {
        setupBindings()
        loadPresets()
    }
    
    // MARK: - Public Methods
    
    /// Creates a new experiment with default parameters.
    func createNewExperiment() {
        currentParameters = GlassParameters()
        hasUnsavedChanges = false
        clearHistory()
    }
    
    /// Resets all parameters to their default values.
    func resetToDefaults() {
        addToHistory()
        currentParameters = GlassParameters()
        hasUnsavedChanges = false
    }
    
    /// Exports the current configuration as Swift code.
    func exportCode() {
        isExporting = true
        
        Task {
            do {
                let code = codeExporter.generateCode(from: currentParameters)
                await copyToClipboard(code)
                isExporting = false
            } catch {
                currentError = .exportFailed(error.localizedDescription)
                isExporting = false
            }
        }
    }
    
    /// Saves the current parameters as a preset.
    /// - Parameter name: The name for the preset.
    func saveAsPreset(name: String) {
        let preset = GlassPreset(
            id: UUID(),
            name: name,
            parameters: currentParameters,
            createdAt: Date()
        )
        savedPresets.append(preset)
        presetManager.save(presets: savedPresets)
        hasUnsavedChanges = false
    }
    
    /// Loads a preset and applies its parameters.
    /// - Parameter preset: The preset to load.
    func loadPreset(_ preset: GlassPreset) {
        addToHistory()
        currentParameters = preset.parameters
        hasUnsavedChanges = false
    }
    
    /// Deletes a saved preset.
    /// - Parameter preset: The preset to delete.
    func deletePreset(_ preset: GlassPreset) {
        savedPresets.removeAll { $0.id == preset.id }
        presetManager.save(presets: savedPresets)
    }
    
    /// Undoes the last parameter change.
    func undo() {
        guard canUndo else { return }
        historyIndex -= 1
        currentParameters = parameterHistory[historyIndex]
    }
    
    /// Redoes a previously undone parameter change.
    func redo() {
        guard canRedo else { return }
        historyIndex += 1
        currentParameters = parameterHistory[historyIndex]
    }
    
    /// Whether undo is available.
    var canUndo: Bool {
        historyIndex > 0
    }
    
    /// Whether redo is available.
    var canRedo: Bool {
        historyIndex < parameterHistory.count - 1
    }
    
    /// Called when the application becomes active.
    func applicationDidBecomeActive() {
        loadPresets()
    }
    
    /// Called when the application will resign active.
    func applicationWillResignActive() {
        saveState()
    }
    
    /// Starts a tutorial of the specified type.
    /// - Parameter type: The tutorial type to start.
    func startTutorial(_ type: TutorialType) {
        activeTutorial = type
        currentTutorialStep = 0
    }
    
    /// Advances to the next tutorial step.
    func nextTutorialStep() {
        guard let step = currentTutorialStep else { return }
        currentTutorialStep = step + 1
    }
    
    /// Exits the current tutorial.
    func exitTutorial() {
        activeTutorial = nil
        currentTutorialStep = nil
    }
    
    /// Provides haptic feedback if enabled.
    /// - Parameter type: The type of feedback to provide.
    func provideHapticFeedback(_ type: HapticFeedbackType) {
        guard hapticsEnabled else { return }
        
        #if os(iOS)
        switch type {
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .impact(let style):
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        case .notification(let type):
            UINotificationFeedbackGenerator().notificationOccurred(type)
        }
        #endif
    }
    
    // MARK: - Private Methods
    
    /// Sets up Combine bindings for reactive updates.
    private func setupBindings() {
        $currentParameters
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.hasUnsavedChanges = true
            }
            .store(in: &cancellables)
    }
    
    /// Loads saved presets from storage.
    private func loadPresets() {
        savedPresets = presetManager.loadPresets()
    }
    
    /// Saves the current application state.
    private func saveState() {
        presetManager.save(presets: savedPresets)
    }
    
    /// Adds the current parameters to history.
    private func addToHistory() {
        if historyIndex < parameterHistory.count - 1 {
            parameterHistory = Array(parameterHistory.prefix(historyIndex + 1))
        }
        
        parameterHistory.append(currentParameters)
        historyIndex = parameterHistory.count - 1
        
        if parameterHistory.count > maxHistoryCount {
            parameterHistory.removeFirst()
            historyIndex -= 1
        }
    }
    
    /// Clears the parameter history.
    private func clearHistory() {
        parameterHistory = []
        historyIndex = -1
    }
    
    /// Copies text to the system clipboard.
    /// - Parameter text: The text to copy.
    private func copyToClipboard(_ text: String) async {
        #if os(iOS)
        UIPasteboard.general.string = text
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #endif
    }
}

// MARK: - Supporting Types

/// Types of haptic feedback available.
enum HapticFeedbackType {
    case selection
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
}

/// Application-specific errors.
enum AppError: LocalizedError, Identifiable {
    case exportFailed(String)
    case loadFailed(String)
    case saveFailed(String)
    case invalidParameters
    
    var id: String {
        localizedDescription
    }
    
    var errorDescription: String? {
        switch self {
        case .exportFailed(let reason): return "Export failed: \(reason)"
        case .loadFailed(let reason): return "Load failed: \(reason)"
        case .saveFailed(let reason): return "Save failed: \(reason)"
        case .invalidParameters: return "Invalid parameters detected"
        }
    }
}

/// Available preview backgrounds.
enum PreviewBackground: String, CaseIterable, Identifiable {
    case gradient
    case image
    case solid
    case pattern
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
}

/// Available tutorial types.
enum TutorialType: String, CaseIterable, Identifiable {
    case basic
    case intermediate
    case advanced
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .basic: return "Glass Basics"
        case .intermediate: return "Intermediate Techniques"
        case .advanced: return "Advanced Effects"
        }
    }
}
