//
//  BackButtonView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 05/02/2025.
//

import SwiftUI

// Кастомный стиль для кнопки назад, который теперь реализует ViewModifier
struct BackButtonStyle: ViewModifier {
    @Environment(\.presentationMode) var presentationMode

    var textColor: Color = .blue
    var image: String = "chevron.left"
    var buttonText: String = "Назад"

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Действие для возврата на предыдущий экран
                    }) {
                        HStack {
                            Image(systemName: image)
                                .foregroundColor(textColor)
                            Text(buttonText)
                                .foregroundColor(textColor)
                        }
                    }
                }
            }
    }
}

// Расширение для удобства использования
extension View {
    func customBackButton(textColor: Color = .typographyPrimary, image: String = "chevron.left", buttonText: String = "") -> some View {
        self.modifier(BackButtonStyle(textColor: textColor, image: image, buttonText: buttonText))
    }
}

#Preview {
    Text("Пример текста").customBackButton()
}

