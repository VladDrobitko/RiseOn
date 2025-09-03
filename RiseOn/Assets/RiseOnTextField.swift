//
//  RiseOnTextField.swift
//  RiseOn
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI

// MARK: - TextField State Enum
enum RiseOnTextFieldState {
    case normal         // Обычное состояние
    case focused        // В фокусе
    case error          // Ошибка
    case disabled       // Неактивное
    case success        // Успешно заполнено
    
    var borderColor: Color {
        switch self {
        case .normal: return .clear
        case .focused: return .primaryButton
        case .error: return .red
        case .disabled: return .clear
        case .success: return .green
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .disabled: return .typographyDisabled.opacity(0.3)
        default: return .card
        }
    }
    
    var textColor: Color {
        switch self {
        case .disabled: return .typographyDisabled
        default: return .typographyPrimary
        }
    }
}

// MARK: - TextField Style Enum
enum RiseOnTextFieldStyle {
    case standard       // Обычное поле
    case outlined       // С обводкой
    case filled         // С заливкой
    
    var borderWidth: CGFloat {
        switch self {
        case .standard: return 0
        case .outlined, .filled: return 1
        }
    }
}

// MARK: - RiseOn TextField Component
struct RiseOnTextField: View {
    // MARK: - Properties
    let title: String
    @Binding var text: String
    let placeholder: String
    let style: RiseOnTextFieldStyle
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let errorMessage: String?
    let helperText: String?
    let leadingIcon: String?
    let trailingIcon: String?
    let trailingAction: (() -> Void)?
    
    @FocusState private var isFocused: Bool
    @State private var isSecureVisible: Bool = false
    
    // MARK: - Computed Properties
    private var currentState: RiseOnTextFieldState {
        if !text.isEmpty && errorMessage == nil {
            return .success
        } else if errorMessage != nil {
            return .error
        } else if isFocused {
            return .focused
        } else {
            return .normal
        }
    }
    
    // MARK: - Initializers
    init(
        title: String = "",
        text: Binding<String>,
        placeholder: String = "",
        style: RiseOnTextFieldStyle = .standard,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false,
        errorMessage: String? = nil,
        helperText: String? = nil,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        trailingAction: (() -> Void)? = nil
    ) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.style = style
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        self.errorMessage = errorMessage
        self.helperText = helperText
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.trailingAction = trailingAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            // Title
            if !title.isEmpty {
                Text(title)
                    .riseOnBodySmall(.medium)
                    .foregroundColor(.typographyPrimary)
            }
            
            // Text Field Container
            HStack(spacing: DesignTokens.Spacing.sm) {
                // Leading Icon
                if let leadingIcon = leadingIcon {
                    Image(systemName: leadingIcon)
                        .foregroundColor(.typographyGrey)
                        .font(.system(size: DesignTokens.Sizes.iconSmall))
                        .frame(width: DesignTokens.Sizes.iconSmall)
                }
                
                // Text Field
                Group {
                    if isSecure && !isSecureVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .foregroundColor(currentState.textColor)
                .keyboardType(keyboardType)
                .focused($isFocused)
                .disabled(currentState == .disabled)
                
                // Trailing Content
                HStack(spacing: DesignTokens.Spacing.xs) {
                    // Secure visibility toggle
                    if isSecure {
                        Button {
                            isSecureVisible.toggle()
                        } label: {
                            Image(systemName: isSecureVisible ? "eye.slash" : "eye")
                                .foregroundColor(.typographyGrey)
                                .font(.system(size: DesignTokens.Sizes.iconSmall))
                        }
                    }
                    
                    // Trailing Icon/Action
                    if let trailingIcon = trailingIcon {
                        Button {
                            trailingAction?()
                        } label: {
                            Image(systemName: trailingIcon)
                                .foregroundColor(.typographyGrey)
                                .font(.system(size: DesignTokens.Sizes.iconSmall))
                        }
                    }
                    
                    // Success/Error Indicator
                    if currentState == .success {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: DesignTokens.Sizes.iconSmall))
                    } else if currentState == .error {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: DesignTokens.Sizes.iconSmall))
                    }
                }
            }
            .padding(DesignTokens.Spacing.md)
            .background(currentState.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                    .stroke(currentState.borderColor, lineWidth: style.borderWidth)
            )
            .cornerRadius(DesignTokens.CornerRadius.sm)
            .animation(.easeInOut(duration: DesignTokens.Animation.fast), value: currentState)
            
            // Helper Text / Error Message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .riseOnCaption()
                    .foregroundColor(.red)
                    .transition(.opacity)
            } else if let helperText = helperText {
                Text(helperText)
                    .riseOnCaption()
                    .foregroundColor(.typographyGrey)
            }
        }
        .animation(.easeInOut(duration: DesignTokens.Animation.normal), value: errorMessage)
    }
}

// MARK: - Convenience Initializers
extension RiseOnTextField {
    
    /// Email поле
    static func email(
        title: String = "Email",
        text: Binding<String>,
        placeholder: String = "Enter your email",
        errorMessage: String? = nil
    ) -> RiseOnTextField {
        RiseOnTextField(
            title: title,
            text: text,
            placeholder: placeholder,
            keyboardType: .emailAddress,
            leadingIcon: "envelope"
        )
    }
    
    /// Password поле
    static func password(
        title: String = "Password",
        text: Binding<String>,
        placeholder: String = "Enter your password",
        errorMessage: String? = nil
    ) -> RiseOnTextField {
        RiseOnTextField(
            title: title,
            text: text,
            placeholder: placeholder,
            isSecure: true,
            errorMessage: errorMessage,
            leadingIcon: "lock"
        )
    }
    
    /// Search поле
    static func search(
        text: Binding<String>,
        placeholder: String = "Search...",
        onClear: (() -> Void)? = nil
    ) -> RiseOnTextField {
        RiseOnTextField(
            text: text,
            placeholder: placeholder,
            leadingIcon: "magnifyingglass",
            trailingIcon: text.wrappedValue.isEmpty ? nil : "xmark.circle.fill",
            trailingAction: onClear
        )
    }
    
    /// Числовое поле
    static func number(
        title: String,
        text: Binding<String>,
        placeholder: String,
        unit: String? = nil,
        errorMessage: String? = nil
    ) -> RiseOnTextField {
        RiseOnTextField(
            title: title,
            text: text,
            placeholder: placeholder,
            keyboardType: .decimalPad,
            errorMessage: errorMessage,
            helperText: unit
        )
    }
}

// MARK: - Specialized Text Fields

/// Поле для ввода имени
struct NameTextField: View {
    @Binding var text: String
    let errorMessage: String?
    
    var body: some View {
        RiseOnTextField(
            title: "What is your name?",
            text: $text,
            placeholder: "Enter your name",
            errorMessage: errorMessage,
            leadingIcon: "person"
        )
    }
}

/// Поле для ввода возраста
struct AgeTextField: View {
    @Binding var text: String
    let errorMessage: String?
    
    var body: some View {
        RiseOnTextField(
            title: "How old are you?",
            text: $text,
            placeholder: "Enter your age",
            keyboardType: .numberPad,
            errorMessage: errorMessage,
            helperText: "years",
            leadingIcon: "calendar"
        )
    }
}

/// Поле для ввода веса/роста с единицами измерения
struct MeasurementTextField: View {
    let title: String
    @Binding var text: String
    let unit: String
    let placeholder: String
    let errorMessage: String?
    
    var body: some View {
        HStack {
            RiseOnTextField(
                title: title,
                text: $text,
                placeholder: placeholder,
                keyboardType: .decimalPad,
                errorMessage: errorMessage
            )
            
            Text(unit)
                .riseOnBodySmall(.medium)
                .foregroundColor(.typographyGrey)
                .padding(.trailing, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Preview
struct RiseOnTextFieldPreview: View {
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var searchText = ""
    @State private var nameText = ""
    @State private var ageText = ""
    @State private var weightText = ""
    @State private var heightText = ""
    @State private var errorText = "Invalid input"
    @State private var showError = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                Text("Text Field Styles")
                    .riseOnHeading2()
                    .foregroundColor(.typographyPrimary)
                
                Group {
                    RiseOnTextField.email(
                        text: $emailText,
                        errorMessage: showError ? "Invalid email format" : nil
                    )
                    
                    RiseOnTextField.password(
                        text: $passwordText,
                        errorMessage: showError ? "Password too short" : nil
                    )
                    
                    RiseOnTextField.search(
                        text: $searchText,
                        placeholder: "Search workouts..."
                    ) {
                        searchText = ""
                    }
                    
                    RiseOnTextField(
                        title: "Standard Field",
                        text: $nameText,
                        placeholder: "Enter text...",
                        helperText: "This is helper text"
                    )
                    
                    RiseOnTextField(
                        title: "Outlined Field",
                        text: $ageText,
                        placeholder: "Outlined style",
                        style: .outlined,
                        leadingIcon: "star"
                    )
                }
                
                Divider()
                    .background(Color.typographyGrey)
                
                Text("Specialized Fields")
                    .riseOnHeading2()
                    .foregroundColor(.typographyPrimary)
                
                Group {
                    NameTextField(
                        text: $nameText,
                        errorMessage: showError ? "Name is required" : nil
                    )
                    
                    AgeTextField(
                        text: $ageText,
                        errorMessage: showError ? "Age must be between 16-100" : nil
                    )
                    
                    MeasurementTextField(
                        title: "Your weight",
                        text: $weightText,
                        unit: "kg",
                        placeholder: "Enter weight",
                        errorMessage: showError ? "Weight must be positive" : nil
                    )
                    
                    MeasurementTextField(
                        title: "Your height",
                        text: $heightText,
                        unit: "cm",
                        placeholder: "Enter height",
                        errorMessage: nil
                    )
                }
                
                RiseOnButton.secondary("Toggle Errors") {
                    showError.toggle()
                }
            }
            .padding(DesignTokens.Padding.screen)
        }
        .background(Color.black)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    RiseOnTextFieldPreview()
        .preferredColorScheme(.dark)
}
