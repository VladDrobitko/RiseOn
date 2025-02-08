//
//  AboutUserTextField.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 07/02/2025.
//

import SwiftUI

struct AboutUserTextField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var errorMessage: String? = nil // Новый параметр для ошибки

    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !title.isEmpty {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.typographyPrimary)
            }

            TextField(placeholder, text: $text)
                .padding()
                .background(Color.card)
                .foregroundStyle(.typographyPrimary)
                .cornerRadius(10)
                .keyboardType(keyboardType)

            if let errorMessage = errorMessage {
                Text(errorMessage) // Отображаем ошибку, если она есть
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.2), value: errorMessage) // Анимация при изменении ошибки
    }
}


#Preview {
    AboutUserTextField(
        title: "Name",
        text: .constant("John Doe"), // Используем .constant для передачи временного Binding
        placeholder: "Enter your name",
        keyboardType: .default
    )
}
