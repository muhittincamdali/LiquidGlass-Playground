//
//  Experiment10_GlassModal.swift
//  LiquidGlass-Playground
//
//  Experiment #10: Glass Modal
//  Create sheets, alerts, and modals with Liquid Glass effects.
//

import SwiftUI

// MARK: - Glass Modal Experiment

/// Demonstrates modal presentations with Liquid Glass effects.
///
/// iOS 26 automatically applies Liquid Glass to sheets and modals.
/// This experiment shows how to customize and create your own
/// glass modal presentations.
///
/// ## Key Concepts:
/// - Sheets with glass backgrounds
/// - Custom alert dialogs
/// - Floating popup menus
/// - Drawer and action sheet patterns
///
@available(iOS 26.0, macOS 26.0, *)
public struct Experiment10_GlassModal: View {
    
    // MARK: - State
    
    @State private var showSheet = false
    @State private var showAlert = false
    @State private var showPopup = false
    @State private var showActionSheet = false
    @State private var showCode = false
    @Namespace private var modalNamespace
    
    // MARK: - Body
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    sheetSection
                    alertSection
                    popupSection
                    actionSheetSection
                    codeSection
                }
                .padding()
            }
            
            // Custom popup overlay
            if showPopup {
                popupOverlay
            }
            
            // Custom alert overlay
            if showAlert {
                alertOverlay
            }
            
            // Custom action sheet overlay
            if showActionSheet {
                actionSheetOverlay
            }
        }
        .background(backgroundGradient)
        .navigationTitle("Glass Modal")
        .sheet(isPresented: $showSheet) {
            sheetContent
                .presentationBackground(.ultraThinMaterial)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.portrait.bottomhalf.inset.filled")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("Experiment #10")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Glass Modal")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Sheets, alerts, and popups")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    private var sheetSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sheet")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Partial height sheets automatically get Liquid Glass backgrounds in iOS 26.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button {
                showSheet = true
            } label: {
                Label("Present Sheet", systemImage: "rectangle.bottomhalf.inset.filled")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var alertSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Custom Alert")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Create beautiful glass alert dialogs for confirmations and messages.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    showAlert = true
                }
            } label: {
                Label("Show Alert", systemImage: "exclamationmark.triangle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .tint(.orange)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var popupSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popup Menu")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Floating popup menus with glass effects for contextual actions.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    showPopup = true
                }
            } label: {
                Label("Show Popup", systemImage: "bubble.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .tint(.purple)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var actionSheetSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Action Sheet")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Glass action sheets for presenting multiple options.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    showActionSheet = true
                }
            } label: {
                Label("Show Action Sheet", systemImage: "list.bullet")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .tint(.green)
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
    
    // MARK: - Sheet Content
    
    private var sheetContent: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 48))
                    .foregroundStyle(.blue)
                
                Text("Glass Sheet")
                    .font(.title2.bold())
                
                Text("This sheet has a Liquid Glass background")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
            
            // Content
            VStack(spacing: 12) {
                ForEach(["Option A", "Option B", "Option C"], id: \.self) { option in
                    Button {
                        showSheet = false
                    } label: {
                        HStack {
                            Text(option)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.tertiary)
                        }
                        .padding()
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.roundedRectangle(radius: 12))
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Close button
            Button("Dismiss") {
                showSheet = false
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .padding()
        }
    }
    
    // MARK: - Overlays
    
    private var alertOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showAlert = false
                    }
                }
            
            GlassEffectContainer {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.orange)
                        .frame(width: 80, height: 80)
                        .glassEffect(.regular.tint(.orange.opacity(0.2)), in: .circle)
                    
                    VStack(spacing: 8) {
                        Text("Confirm Action")
                            .font(.headline)
                        
                        Text("Are you sure you want to proceed? This action cannot be undone.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(spacing: 8) {
                        Button {
                            withAnimation {
                                showAlert = false
                            }
                        } label: {
                            Text("Confirm")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.glassProminent)
                        .tint(.orange)
                        
                        Button {
                            withAnimation {
                                showAlert = false
                            }
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.glass)
                    }
                }
                .padding(24)
                .frame(maxWidth: 320)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
                .shadow(color: .black.opacity(0.2), radius: 20)
                .glassEffectID("alert", in: modalNamespace)
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
    }
    
    private var popupOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showPopup = false
                    }
                }
            
            GlassEffectContainer(spacing: 4) {
                VStack(spacing: 4) {
                    ForEach([
                        ("square.and.arrow.up", "Share"),
                        ("doc.on.doc", "Copy"),
                        ("pencil", "Edit"),
                        ("trash", "Delete")
                    ], id: \.1) { item in
                        Button {
                            withAnimation {
                                showPopup = false
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: item.0)
                                    .frame(width: 24)
                                Text(item.1)
                                Spacer()
                            }
                            .foregroundStyle(item.1 == "Delete" ? .red : .primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)
                        .glassEffectID("popup-\(item.1)", in: modalNamespace)
                        
                        if item.1 != "Delete" {
                            Divider()
                                .overlay(Color.white.opacity(0.1))
                        }
                    }
                }
                .frame(width: 200)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.2), radius: 16)
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.85)))
    }
    
    private var actionSheetOverlay: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        showActionSheet = false
                    }
                }
            
            VStack(spacing: 8) {
                GlassEffectContainer(spacing: 0) {
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: 4) {
                            Text("Choose Action")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.secondary)
                            
                            Text("Select what you want to do")
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 12)
                        
                        Divider().overlay(Color.white.opacity(0.1))
                        
                        // Actions
                        ForEach([
                            ("camera.fill", "Take Photo"),
                            ("photo.fill", "Choose from Library"),
                            ("doc.fill", "Browse Files")
                        ], id: \.1) { item in
                            Button {
                                withAnimation {
                                    showActionSheet = false
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: item.0)
                                        .font(.title3)
                                        .frame(width: 30)
                                    Text(item.1)
                                        .font(.title3)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .frame(height: 56)
                            }
                            .buttonStyle(.plain)
                            .glassEffectID("action-\(item.1)", in: modalNamespace)
                            
                            if item.1 != "Browse Files" {
                                Divider().overlay(Color.white.opacity(0.1))
                            }
                        }
                    }
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14))
                }
                
                // Cancel
                GlassEffectContainer {
                    Button {
                        withAnimation {
                            showActionSheet = false
                        }
                    } label: {
                        Text("Cancel")
                            .font(.title3.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14))
                    .glassEffectID("cancel", in: modalNamespace)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
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
            colors: [.pink, .purple, .indigo],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Sheet with Glass Background
        .sheet(isPresented: $showSheet) {
            SheetContent()
                .presentationBackground(.ultraThinMaterial)
                .presentationDetents([.medium, .large])
        }
        
        // Custom Glass Alert
        ZStack {
            Color.black.opacity(0.4)
                .onTapGesture { showAlert = false }
            
            GlassEffectContainer {
                VStack {
                    Text("Alert Title")
                    Button("OK") { showAlert = false }
                        .buttonStyle(.glassProminent)
                }
                .padding()
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
            }
        }
        
        // Action Sheet
        VStack(spacing: 0) {
            ForEach(actions) { action in
                Button(action.title) { }
                    .glassEffectID(action.id, in: namespace)
            }
        }
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14))
        """
    }
}

// MARK: - Preview

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    NavigationStack {
        Experiment10_GlassModal()
    }
}
