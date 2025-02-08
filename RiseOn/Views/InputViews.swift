//
//  InputViews.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 02/02/2025.
//
import SwiftUI

struct CustomTextField: View {
    enum FieldState {
        case `default`, focused, error, disabled
    }
    
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var errorMessage: String? = nil
    var state: FieldState = .default
    var keyboardType: UIKeyboardType = .default
    
    @FocusState private var isFocused: Bool // Добавим фокус

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !title.isEmpty {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(state == .disabled ? .typographyGrey : .white) // Цвет для title
            }
            
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(placeholderColor) // Используем цвет для placeholder
                }
                .focused($isFocused) // Управляем фокусом
                .padding()
                .background(fieldBackground)
                .foregroundColor(.typographyPrimary) // Явно задаем цвет текста
                .cornerRadius(10)
                .disabled(state == .disabled)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isFocused ? .primaryButton : borderColor, lineWidth: 0.3) // Добавим фокусный бордер
                )
                .keyboardType(keyboardType)
            
            if let errorMessage = errorMessage, state == .error {
                Text(errorMessage)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.red)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: state)
    }

    private var fieldBackground: Color {
        state == .disabled ? .typographyDisabled : Color.card // Фон для поля
    }
    
    private var borderColor: Color {
        switch state {
        case .default: return .clear
        case .focused: return .blue
        case .error: return .red
        case .disabled: return .clear
        }
    }

    // Цвет для placeholder с учетом твоих цветов
    private var placeholderColor: Color {
        Color.typographyGrey // Используем цвет для текста placeholder, подходящий для обоих режимов
    }
}

extension View {
    // Помощник для отображения placeholder в TextField
    @ViewBuilder
    func placeholder<Content: View>(when shouldShow: Bool, @ViewBuilder content: () -> Content) -> some View {
        ZStack(alignment: .leading) {
            if shouldShow {
                content()
            }
            self
        }
    }
}



