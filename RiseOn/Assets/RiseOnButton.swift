//
//  RiseOnButton.swift
//  RiseOn
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI

// MARK: - Button Style Enum
enum RiseOnButtonStyle {
    case primary        // Основная зеленая кнопка
    case secondary      // Вторичная кнопка с обводкой
    case ghost          // Прозрачная кнопка
    case danger         // Красная кнопка для удаления
    case disabled       // Неактивная кнопка
    
    var backgroundColor: Color {
        switch self {
        case .primary: return .primaryButton
        case .secondary: return .clear
        case .ghost: return .clear
        case .danger: return .red
        case .disabled: return .disabledButton
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary: return .black
        case .secondary: return .primaryButton
        case .ghost: return .typographyPrimary
        case .danger: return .white
        case .disabled: return .disabled
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary: return .clear
        case .secondary: return .primaryButton
        case .ghost: return .clear
        case .danger: return .clear
        case .disabled: return .clear
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .secondary: return 1
        default: return 0
        }
    }
}

// MARK: - Button Size Enum
enum RiseOnButtonSize {
    case small          // Компактные кнопки
    case medium         // Стандартные кнопки
    case large          // Большие кнопки (основные действия)
    
    var height: CGFloat {
        switch self {
        case .small: return DesignTokens.Sizes.buttonHeightSmall
        case .medium: return DesignTokens.Sizes.buttonHeight - 8
        case .large: return DesignTokens.Sizes.buttonHeight
        }
    }
    
    var padding: EdgeInsets {
        switch self {
        case .small: return EdgeInsets(top: DesignTokens.Spacing.sm, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.sm, trailing: DesignTokens.Spacing.md)
        case .medium: return EdgeInsets(top: DesignTokens.Spacing.md, leading: DesignTokens.Spacing.lg, bottom: DesignTokens.Spacing.md, trailing: DesignTokens.Spacing.lg)
        case .large: return EdgeInsets(top: DesignTokens.Spacing.lg, leading: DesignTokens.Spacing.xl, bottom: DesignTokens.Spacing.lg, trailing: DesignTokens.Spacing.xl)
        }
    }
    
    var font: Font {
        switch self {
        case .small: return RiseOnTypography.bodySmall(.medium)
        case .medium: return RiseOnTypography.body(.medium)
        case .large: return RiseOnTypography.button
        }
    }
}

// MARK: - RiseOn Button Component
struct RiseOnButton: View {
    let title: String
    let style: RiseOnButtonStyle
    let size: RiseOnButtonSize
    let isLoading: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    // MARK: - Initializers
    init(
        _ title: String,
        style: RiseOnButtonStyle = .primary,
        size: RiseOnButtonSize = .large,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if style != .disabled && !isLoading {
                action()
            }
        }) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(size.font)
                        .foregroundColor(style.foregroundColor)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .background(style.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
            .cornerRadius(DesignTokens.Radius.button)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .opacity(style == .disabled ? DesignTokens.Opacity.disabled : 1.0)
        }
        .disabled(style == .disabled || isLoading)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: DesignTokens.Animation.fast)) {
                isPressed = pressing
            }
        }) {
            // Действие при длинном нажатии (не используется)
        }
    }
}

// MARK: - Convenience Initializers
extension RiseOnButton {
    
    /// Основная кнопка (зеленая)
    static func primary(
        _ title: String,
        size: RiseOnButtonSize = .large,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> RiseOnButton {
        RiseOnButton(title, style: .primary, size: size, isLoading: isLoading, action: action)
    }
    
    /// Вторичная кнопка (с обводкой)
    static func secondary(
        _ title: String,
        size: RiseOnButtonSize = .medium,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> RiseOnButton {
        RiseOnButton(title, style: .secondary, size: size, isLoading: isLoading, action: action)
    }
    
    /// Прозрачная кнопка
    static func ghost(
        _ title: String,
        size: RiseOnButtonSize = .medium,
        action: @escaping () -> Void
    ) -> RiseOnButton {
        RiseOnButton(title, style: .ghost, size: size, action: action)
    }
    
    /// Опасная кнопка (красная)
    static func danger(
        _ title: String,
        size: RiseOnButtonSize = .medium,
        action: @escaping () -> Void
    ) -> RiseOnButton {
        RiseOnButton(title, style: .danger, size: size, action: action)
    }
    
    /// Неактивная кнопка
    static func disabled(_ title: String, size: RiseOnButtonSize = .large) -> RiseOnButton {
        RiseOnButton(title, style: .disabled, size: size) { }
    }
}

// MARK: - Preview
struct RiseOnButtonPreview: View {
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                Group {
                    Text("Button Styles")
                        .riseOnHeading2()
                        .foregroundColor(.typographyPrimary)
                    
                    RiseOnButton.primary("Primary Button") {
                        print("Primary button tapped")
                    }
                    
                    RiseOnButton.secondary("Secondary Button") {
                        print("Secondary button tapped")
                    }
                    
                    RiseOnButton.ghost("Ghost Button") {
                        print("Ghost button tapped")
                    }
                    
                    RiseOnButton.danger("Delete Account") {
                        print("Danger button tapped")
                    }
                    
                    RiseOnButton.disabled("Disabled Button")
                }
                
                Divider()
                    .background(Color.typographyGrey)
                
                Group {
                    Text("Button Sizes")
                        .riseOnHeading2()
                        .foregroundColor(.typographyPrimary)
                    
                    RiseOnButton("Large Button", size: .large) {
                        print("Large button tapped")
                    }
                    
                    RiseOnButton("Medium Button", size: .medium) {
                        print("Medium button tapped")
                    }
                    
                    RiseOnButton("Small Button", size: .small) {
                        print("Small button tapped")
                    }
                }
                
                Divider()
                    .background(Color.typographyGrey)
                
                Group {
                    Text("Loading State")
                        .riseOnHeading2()
                        .foregroundColor(.typographyPrimary)
                    
                    RiseOnButton("Loading Button", isLoading: isLoading) {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
                    
                    RiseOnButton.secondary("Loading Secondary", isLoading: true) {
                        print("Secondary loading")
                    }
                }
            }
            .padding(DesignTokens.Padding.screen)
        }
        .background(Color.black)
    }
}

#Preview {
    RiseOnButtonPreview()
        .preferredColorScheme(.dark)
}
