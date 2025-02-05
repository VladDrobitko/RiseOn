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
    @FocusState private var isInputActive: Bool // Управление фокусом
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !title.isEmpty {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(state == .disabled ? .typographyDisabled : .white)
            }
            
            TextField(placeholder, text: $text)
                .padding()
                .background(fieldBackground)
                .cornerRadius(10)
                .disabled(state == .disabled)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 2)
                )
                .keyboardType(keyboardType) // Устанавливаем тип клавиатуры
                .focused($isInputActive) // Управляем фокусом через FocusState
            
            if let errorMessage = errorMessage, state == .error {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: state)
        
    }


    // 🟢 Цвет фона
    private var fieldBackground: Color {
        state == .disabled ? .gray.opacity(0.3) : Color.card
    }
    
    // 🔴 Цвет границы
    private var borderColor: Color {
        switch state {
        case .default: return .clear
        case .focused: return .blue
        case .error: return .red
        case .disabled: return .clear
        }
    }
}

