//
//  ExperimentsIndex.swift
//  LiquidGlass-Playground
//
//  Central index for all Liquid Glass experiments.
//  Navigate through 10 interactive learning modules.
//

import SwiftUI

// MARK: - Experiment Definition

/// Represents a single experiment in the playground.
public struct ExperimentItem: Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let subtitle: String
    public let icon: String
    public let color: Color
    public let difficulty: Difficulty
    
    public enum Difficulty: String, CaseIterable, Sendable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        
        public var color: Color {
            switch self {
            case .beginner: return .green
            case .intermediate: return .orange
            case .advanced: return .red
            }
        }
    }
}

// MARK: - Experiments Catalog

/// All available experiments in the playground.
@available(iOS 26.0, macOS 26.0, *)
public enum ExperimentsCatalog {
    
    /// The complete list of experiments.
    public static let all: [ExperimentItem] = [
        ExperimentItem(
            id: 1,
            title: "Basic Glass Effect",
            subtitle: "Learn the fundamentals of .glassEffect()",
            icon: "square.on.square.squareshape.controlhandles",
            color: .indigo,
            difficulty: .beginner
        ),
        ExperimentItem(
            id: 2,
            title: "Interactive Glass",
            subtitle: "Touch-responsive glass with .interactive()",
            icon: "hand.tap.fill",
            color: .cyan,
            difficulty: .beginner
        ),
        ExperimentItem(
            id: 3,
            title: "Morphing Glass",
            subtitle: "Fluid transitions with GlassEffectContainer",
            icon: "wand.and.stars",
            color: .purple,
            difficulty: .intermediate
        ),
        ExperimentItem(
            id: 4,
            title: "Glass with Blur",
            subtitle: "Understand blur depth and intensity",
            icon: "aqi.medium",
            color: .blue,
            difficulty: .beginner
        ),
        ExperimentItem(
            id: 5,
            title: "Glass with Tint",
            subtitle: "Add color personality to your glass",
            icon: "paintpalette.fill",
            color: .pink,
            difficulty: .beginner
        ),
        ExperimentItem(
            id: 6,
            title: "Glass Navigation Bar",
            subtitle: "Build beautiful nav components",
            icon: "menubar.rectangle",
            color: .teal,
            difficulty: .intermediate
        ),
        ExperimentItem(
            id: 7,
            title: "Glass Tab Bar",
            subtitle: "Create stunning tab bars with morphing",
            icon: "dock.rectangle",
            color: .green,
            difficulty: .intermediate
        ),
        ExperimentItem(
            id: 8,
            title: "Glass Card",
            subtitle: "Design beautiful content containers",
            icon: "rectangle.portrait.on.rectangle.portrait.fill",
            color: .orange,
            difficulty: .beginner
        ),
        ExperimentItem(
            id: 9,
            title: "Glass Button",
            subtitle: "Master all button styles and configs",
            icon: "button.horizontal.fill",
            color: .blue,
            difficulty: .beginner
        ),
        ExperimentItem(
            id: 10,
            title: "Glass Modal",
            subtitle: "Sheets, alerts, and popup menus",
            icon: "rectangle.portrait.bottomhalf.inset.filled",
            color: .purple,
            difficulty: .advanced
        )
    ]
    
    /// Experiments filtered by difficulty.
    public static func experiments(for difficulty: ExperimentItem.Difficulty) -> [ExperimentItem] {
        all.filter { $0.difficulty == difficulty }
    }
}

// MARK: - Experiments Index View

/// The main navigation view for all experiments.
@available(iOS 26.0, macOS 26.0, *)
public struct ExperimentsIndexView: View {
    
    @State private var selectedDifficulty: ExperimentItem.Difficulty?
    @State private var searchText = ""
    @Namespace private var namespace
    
    public init() {}
    
    private var filteredExperiments: [ExperimentItem] {
        var experiments = ExperimentsCatalog.all
        
        if let difficulty = selectedDifficulty {
            experiments = experiments.filter { $0.difficulty == difficulty }
        }
        
        if !searchText.isEmpty {
            experiments = experiments.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return experiments
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    filterSection
                    experimentsList
                }
                .padding()
            }
            .background(backgroundGradient)
            .navigationTitle("Experiments")
            .searchable(text: $searchText, prompt: "Search experiments...")
        }
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "flask.fill")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Text("Liquid Glass Experiments")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("10 interactive modules to master iOS 26's Liquid Glass design language")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
        .padding(.bottom, 8)
    }
    
    private var filterSection: some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                filterButton(title: "All", difficulty: nil)
                
                ForEach(ExperimentItem.Difficulty.allCases, id: \.rawValue) { difficulty in
                    filterButton(title: difficulty.rawValue, difficulty: difficulty)
                }
            }
            .padding(8)
            .glassEffect(.regular, in: Capsule())
        }
    }
    
    private func filterButton(title: String, difficulty: ExperimentItem.Difficulty?) -> some View {
        let isSelected = selectedDifficulty == difficulty
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedDifficulty = difficulty
            }
        } label: {
            Text(title)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : .secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background {
                    if isSelected {
                        Capsule()
                            .fill(difficulty?.color ?? .blue)
                            .matchedGeometryEffect(id: "filter", in: namespace)
                    }
                }
        }
        .buttonStyle(.plain)
        .glassEffectID("filter-\(title)", in: namespace)
    }
    
    private var experimentsList: some View {
        LazyVStack(spacing: 12) {
            ForEach(filteredExperiments) { experiment in
                NavigationLink {
                    experimentDestination(for: experiment)
                } label: {
                    experimentCard(experiment)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func experimentCard(_ experiment: ExperimentItem) -> some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: experiment.icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .glassEffect(.regular.tint(experiment.color.opacity(0.4)), in: RoundedRectangle(cornerRadius: 14))
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Experiment \(experiment.id)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(experiment.color)
                    
                    Text("•")
                        .foregroundStyle(.tertiary)
                    
                    Text(experiment.difficulty.rawValue)
                        .font(.caption)
                        .foregroundStyle(experiment.difficulty.color)
                }
                
                Text(experiment.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(experiment.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }
    
    @ViewBuilder
    private func experimentDestination(for experiment: ExperimentItem) -> some View {
        switch experiment.id {
        case 1: Experiment01_BasicGlassEffect()
        case 2: Experiment02_InteractiveGlass()
        case 3: Experiment03_MorphingGlass()
        case 4: Experiment04_GlassWithBlur()
        case 5: Experiment05_GlassWithTint()
        case 6: Experiment06_GlassNavigationBar()
        case 7: Experiment07_GlassTabBar()
        case 8: Experiment08_GlassCard()
        case 9: Experiment09_GlassButton()
        case 10: Experiment10_GlassModal()
        default: Text("Experiment not found")
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.indigo, .purple, .pink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    ExperimentsIndexView()
}
