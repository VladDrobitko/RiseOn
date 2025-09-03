//
//  RiseOnModal.swift
//  RiseOn
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI

// MARK: - Modal Style Enum
enum RiseOnModalStyle {
    case sheet          // Стандартный sheet снизу
    case overlay        // Overlay по центру
    case fullscreen     // На весь экран
    case card           // Карточка по центру
    
    var background: Color {
        switch self {
        case .sheet, .fullscreen: return .clear
        case .overlay, .card: return .black.opacity(0.4)
        }
    }
}

// MARK: - Modal Size Enum
enum RiseOnModalSize {
    case small          // До 1/3 экрана
    case medium         // До 1/2 экрана
    case large          // До 2/3 экрана
    case auto           // По содержимому
    
    var detents: Set<PresentationDetent> {
        switch self {
        case .small: return [.height(300)]
        case .medium: return [.medium]
        case .large: return [.large]
        case .auto: return [.medium, .large]
        }
    }
}

// MARK: - RiseOn Modal Component
struct RiseOnModal<Content: View>: View {
    @Binding var isPresented: Bool
    let style: RiseOnModalStyle
    let size: RiseOnModalSize
    let title: String
    let subtitle: String?
    let showCloseButton: Bool
    let isDragIndicatorVisible: Bool
    let content: Content
    
    init(
        isPresented: Binding<Bool>,
        style: RiseOnModalStyle = .sheet,
        size: RiseOnModalSize = .medium,
        title: String = "",
        subtitle: String? = nil,
        showCloseButton: Bool = true,
        isDragIndicatorVisible: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.style = style
        self.size = size
        self.title = title
        self.subtitle = subtitle
        self.showCloseButton = showCloseButton
        self.isDragIndicatorVisible = isDragIndicatorVisible
        self.content = content()
    }
    
    var body: some View {
        switch style {
        case .sheet:
            sheetModal
        case .overlay, .card:
            overlayModal
        case .fullscreen:
            fullscreenModal
        }
    }
    
    // MARK: - Sheet Modal
    private var sheetModal: some View {
        Color.clear
            .sheet(isPresented: $isPresented) {
                modalContent
                    .presentationDetents(size.detents)
                    .presentationDragIndicator(isDragIndicatorVisible ? .visible : .hidden)
                    .presentationCornerRadius(DesignTokens.CornerRadius.xl)
                    .presentationBackground(.ultraThinMaterial)
            }
    }
    
    // MARK: - Overlay Modal
    private var overlayModal: some View {
        ZStack {
            if isPresented {
                // Background overlay
                style.background
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissModal()
                    }
                
                // Modal content
                modalContent
                    .frame(maxWidth: DesignTokens.Sizes.modalMaxWidth)
                    .background(.ultraThinMaterial)
                    .cornerRadius(DesignTokens.CornerRadius.xl)
                    .padding(DesignTokens.Spacing.lg)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: DesignTokens.Animation.normal), value: isPresented)
    }
    
    // MARK: - Fullscreen Modal
    private var fullscreenModal: some View {
        Color.clear
            .fullScreenCover(isPresented: $isPresented) {
                modalContent
                    .background(Color.black.ignoresSafeArea())
            }
    }
    
    // MARK: - Modal Content
    private var modalContent: some View {
        VStack(spacing: 0) {
            // Header
            if !title.isEmpty || showCloseButton {
                modalHeader
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.top, DesignTokens.Spacing.lg)
                    .padding(.bottom, subtitle != nil ? DesignTokens.Spacing.sm : DesignTokens.Spacing.lg)
            }
            
            // Subtitle
            if let subtitle = subtitle {
                Text(subtitle)
                    .riseOnBodySmall()
                    .foregroundColor(.typographyGrey)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.bottom, DesignTokens.Spacing.lg)
            }
            
            // Content
            content
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.bottom, DesignTokens.Spacing.lg)
        }
    }
    
    // MARK: - Modal Header
    private var modalHeader: some View {
        HStack {
            if !title.isEmpty {
                Text(title)
                    .riseOnHeading3(.semibold)
                    .foregroundColor(.typographyPrimary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            if showCloseButton {
                Button {
                    dismissModal()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: DesignTokens.Sizes.iconSmall, weight: .medium))
                        .foregroundColor(.typographyGrey)
                        .frame(width: 32, height: 32)
                        .background(Color.typographyGrey.opacity(0.2))
                        .cornerRadius(DesignTokens.CornerRadius.sm)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func dismissModal() {
        withAnimation(.easeInOut(duration: DesignTokens.Animation.fast)) {
            isPresented = false
        }
    }
}

// MARK: - Specialized Modals

/// Модальное окно подтверждения
struct ConfirmationModal: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let isDestructive: Bool
    let onConfirm: () -> Void
    let onCancel: (() -> Void)?
    
    init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        cancelTitle: String = "Cancel",
        isDestructive: Bool = false,
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self.isDestructive = isDestructive
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }
    
    var body: some View {
        RiseOnModal(
            isPresented: $isPresented,
            style: .overlay,
            size: .small,
            title: title,
            subtitle: message,
            showCloseButton: false,
            isDragIndicatorVisible: false
        ) {
            VStack(spacing: DesignTokens.Spacing.md) {
                HStack(spacing: DesignTokens.Spacing.md) {
                    RiseOnButton.secondary(cancelTitle, size: .medium) {
                        onCancel?()
                        isPresented = false
                    }
                    
                    if isDestructive {
                        RiseOnButton.danger(confirmTitle, size: .medium) {
                            onConfirm()
                            isPresented = false
                        }
                    } else {
                        RiseOnButton.primary(confirmTitle, size: .medium) {
                            onConfirm()
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}

/// Модальное окно загрузки
struct LoadingModal: View {
    @Binding var isPresented: Bool
    let message: String
    
    var body: some View {
        RiseOnModal(
            isPresented: $isPresented,
            style: .overlay,
            size: .small,
            showCloseButton: false,
            isDragIndicatorVisible: false
        ) {
            VStack(spacing: DesignTokens.Spacing.lg) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .primaryButton))
                    .scaleEffect(1.2)
                
                Text(message)
                    .riseOnBody()
                    .foregroundColor(.typographyPrimary)
                    .multilineTextAlignment(.center)
            }
            .padding(DesignTokens.Spacing.xl)
        }
    }
}

/// Модальное окно успеха
struct SuccessModal: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let buttonTitle: String
    let onDismiss: (() -> Void)?
    
    init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        buttonTitle: String = "Great!",
        onDismiss: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        RiseOnModal(
            isPresented: $isPresented,
            style: .overlay,
            size: .medium,
            showCloseButton: false,
            isDragIndicatorVisible: false
        ) {
            VStack(spacing: DesignTokens.Spacing.xl) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.green)
                
                VStack(spacing: DesignTokens.Spacing.sm) {
                    Text(title)
                        .riseOnHeading2()
                        .foregroundColor(.typographyPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(message)
                        .riseOnBody()
                        .foregroundColor(.typographyGrey)
                        .multilineTextAlignment(.center)
                }
                
                RiseOnButton.primary(buttonTitle) {
                    onDismiss?()
                    isPresented = false
                }
            }
            .padding(DesignTokens.Spacing.lg)
        }
    }
}

// MARK: - Preview
struct RiseOnModalPreview: View {
    @State private var showSheet = false
    @State private var showOverlay = false
    @State private var showConfirmation = false
    @State private var showLoading = false
    @State private var showSuccess = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                Text("Modal Examples")
                    .riseOnHeading2()
                    .foregroundColor(.typographyPrimary)
                
                VStack(spacing: DesignTokens.Spacing.md) {
                    RiseOnButton.primary("Show Sheet Modal") {
                        showSheet = true
                    }
                    
                    RiseOnButton.secondary("Show Overlay Modal") {
                        showOverlay = true
                    }
                    
                    RiseOnButton.ghost("Show Confirmation") {
                        showConfirmation = true
                    }
                    
                    RiseOnButton.secondary("Show Loading") {
                        showLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showLoading = false
                        }
                    }
                    
                    RiseOnButton.primary("Show Success") {
                        showSuccess = true
                    }
                }
            }
            .padding(DesignTokens.Padding.screen)
        }
        .background(Color.black)
        .overlay(
            Group {
                // Sheet Modal
                RiseOnModal(
                    isPresented: $showSheet,
                    style: .sheet,
                    size: .medium,
                    title: "Sheet Modal",
                    subtitle: "This is a sheet modal example"
                ) {
                    VStack(spacing: DesignTokens.Spacing.lg) {
                        Text("Sheet content goes here")
                            .riseOnBody()
                            .foregroundColor(.typographyPrimary)
                        
                        RiseOnButton.primary("Close") {
                            showSheet = false
                        }
                    }
                }
                
                // Overlay Modal
                RiseOnModal(
                    isPresented: $showOverlay,
                    style: .overlay,
                    size: .medium,
                    title: "Overlay Modal",
                    subtitle: "This modal appears over the content"
                ) {
                    VStack(spacing: DesignTokens.Spacing.lg) {
                        Text("Overlay content with some longer text to see how it wraps and displays in the modal.")
                            .riseOnBody()
                            .foregroundColor(.typographyPrimary)
                            .multilineTextAlignment(.center)
                        
                        RiseOnButton.secondary("Got it") {
                            showOverlay = false
                        }
                    }
                }
                
                // Confirmation Modal
                ConfirmationModal(
                    isPresented: $showConfirmation,
                    title: "Delete Account",
                    message: "Are you sure you want to delete your account? This action cannot be undone.",
                    confirmTitle: "Delete",
                    isDestructive: true,
                    onConfirm: {
                        print("Account deleted")
                    }
                )
                
                // Loading Modal
                LoadingModal(
                    isPresented: $showLoading,
                    message: "Analyzing your data..."
                )
                
                // Success Modal
                SuccessModal(
                    isPresented: $showSuccess,
                    title: "Workout Complete!",
                    message: "Great job! You've completed your daily workout and burned 320 calories."
                )
            }
        )
    }
}

#Preview {
    RiseOnModalPreview()
        .preferredColorScheme(.dark)
}
