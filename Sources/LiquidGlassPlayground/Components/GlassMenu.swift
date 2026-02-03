// GlassMenu.swift
// LiquidGlassPlayground
//
// Created by Muhittin Camdali
// Copyright © 2025. All rights reserved.

import SwiftUI

// MARK: - Glass Menu

/// A custom menu component with Liquid Glass styling.
///
/// This menu provides a dropdown selection with glass aesthetics,
/// supporting both single and multiple selections.
///
/// ## Usage
/// ```swift
/// GlassMenu(
///     selection: $selectedOption,
///     options: ["Option 1", "Option 2", "Option 3"],
///     label: "Select Option"
/// )
/// ```
struct GlassMenu<T: Hashable & CustomStringConvertible>: View {
    
    // MARK: - Properties
    
    /// The currently selected value.
    @Binding var selection: T
    
    /// The available options.
    let options: [T]
    
    /// The label for the menu.
    let label: String
    
    /// Optional icon for the menu button.
    var icon: String? = nil
    
    /// Whether to show the selected value in the button.
    var showSelection: Bool = true
    
    /// The accent color.
    var accentColor: Color = .accentColor
    
    // MARK: - Body
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button {
                    selection = option
                    UISelectionFeedbackGenerator().selectionChanged()
                } label: {
                    HStack {
                        Text(option.description)
                        
                        if selection == option {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            menuButton
        }
    }
    
    // MARK: - Menu Button
    
    private var menuButton: some View {
        HStack(spacing: 8) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundStyle(accentColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if showSelection {
                    Text(selection.description)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.up.chevron.down")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
        }
    }
}

// MARK: - Glass Picker Menu

/// A picker-style glass menu for enum types.
struct GlassPickerMenu<T: Hashable & CaseIterable & Identifiable>: View where T.AllCases: RandomAccessCollection {
    
    @Binding var selection: T
    let label: String
    let titleProvider: (T) -> String
    var iconProvider: ((T) -> String)? = nil
    
    var body: some View {
        Menu {
            ForEach(Array(T.allCases), id: \.id) { option in
                Button {
                    selection = option
                    UISelectionFeedbackGenerator().selectionChanged()
                } label: {
                    Label {
                        Text(titleProvider(option))
                    } icon: {
                        if let iconProvider = iconProvider {
                            Image(systemName: iconProvider(option))
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(titleProvider(selection))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Glass Context Menu

/// A view modifier for adding glass-styled context menus.
struct GlassContextMenu<MenuContent: View>: ViewModifier {
    
    let menuContent: () -> MenuContent
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                menuContent()
            }
    }
}

extension View {
    func glassContextMenu<MenuContent: View>(
        @ViewBuilder menuContent: @escaping () -> MenuContent
    ) -> some View {
        modifier(GlassContextMenu(menuContent: menuContent))
    }
}

// MARK: - Glass Dropdown

/// A dropdown menu with expandable options.
struct GlassDropdown<T: Hashable & Identifiable>: View {
    
    @Binding var selection: T
    let options: [T]
    let titleProvider: (T) -> String
    let iconProvider: ((T) -> String)?
    
    @State private var isExpanded = false
    
    init(
        selection: Binding<T>,
        options: [T],
        titleProvider: @escaping (T) -> String,
        iconProvider: ((T) -> String)? = nil
    ) {
        self._selection = selection
        self.options = options
        self.titleProvider = titleProvider
        self.iconProvider = iconProvider
    }
    
    var body: some View {
        VStack(spacing: 0) {
            selectedButton
            
            if isExpanded {
                optionsList
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .animation(.spring(duration: 0.3), value: isExpanded)
    }
    
    private var selectedButton: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                if let iconProvider = iconProvider {
                    Image(systemName: iconProvider(selection))
                        .foregroundStyle(.accentColor)
                }
                
                Text(titleProvider(selection))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .buttonStyle(.plain)
    }
    
    private var optionsList: some View {
        VStack(spacing: 0) {
            ForEach(options) { option in
                Button {
                    selection = option
                    withAnimation {
                        isExpanded = false
                    }
                    UISelectionFeedbackGenerator().selectionChanged()
                } label: {
                    HStack {
                        if let iconProvider = iconProvider {
                            Image(systemName: iconProvider(option))
                                .foregroundStyle(.secondary)
                                .frame(width: 24)
                        }
                        
                        Text(titleProvider(option))
                            .font(.subheadline)
                        
                        Spacer()
                        
                        if selection.id == option.id {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.accentColor)
                        }
                    }
                    .padding()
                    .background(selection.id == option.id ? Color.accentColor.opacity(0.1) : .clear)
                }
                .buttonStyle(.plain)
                
                if option.id != options.last?.id {
                    Divider()
                        .padding(.leading, 40)
                }
            }
        }
        .background(.ultraThinMaterial.opacity(0.8))
    }
}

// MARK: - Glass Action Menu

/// An action menu for presenting multiple options.
struct GlassActionMenu: View {
    
    let title: String
    let actions: [GlassAction]
    
    @State private var isPresented = false
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
        .confirmationDialog(title, isPresented: $isPresented, titleVisibility: .visible) {
            ForEach(actions) { action in
                Button(role: action.isDestructive ? .destructive : nil) {
                    action.handler()
                } label: {
                    Label(action.title, systemImage: action.icon)
                }
            }
        }
    }
}

/// An action item for the glass action menu.
struct GlassAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    var isDestructive: Bool = false
    let handler: () -> Void
}

// MARK: - Glass Sort Menu

/// A specialized menu for sorting options.
struct GlassSortMenu<T: Hashable & CaseIterable & Identifiable>: View where T.AllCases: RandomAccessCollection {
    
    @Binding var sortBy: T
    @Binding var ascending: Bool
    let titleProvider: (T) -> String
    
    var body: some View {
        Menu {
            Section("Sort By") {
                ForEach(Array(T.allCases), id: \.id) { option in
                    Button {
                        sortBy = option
                    } label: {
                        HStack {
                            Text(titleProvider(option))
                            if sortBy.id == option.id {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            Divider()
            
            Section("Order") {
                Button {
                    ascending = true
                } label: {
                    Label("Ascending", systemImage: "arrow.up")
                }
                
                Button {
                    ascending = false
                } label: {
                    Label("Descending", systemImage: "arrow.down")
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.up.arrow.down")
                Text("Sort")
            }
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
    }
}

// MARK: - Preview

#Preview("Glass Menu") {
    VStack(spacing: 20) {
        GlassMenu(
            selection: .constant("Option 2"),
            options: ["Option 1", "Option 2", "Option 3"],
            label: "Select Option",
            icon: "slider.horizontal.3"
        )
        
        GlassActionMenu(
            title: "Actions",
            actions: [
                GlassAction(title: "Edit", icon: "pencil") { },
                GlassAction(title: "Share", icon: "square.and.arrow.up") { },
                GlassAction(title: "Delete", icon: "trash", isDestructive: true) { }
            ]
        )
    }
    .padding()
}
