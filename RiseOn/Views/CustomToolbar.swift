//
//  CustomToolbar.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 11/02/2025.
//

import SwiftUI


struct CustomToolbar: View {
    let currentStep: Int
    let totalSteps: Int
    let onBack: () -> Void

    var body: some View {
        VStack {
            HStack {
                // Кнопка "Назад"
                Button(action: onBack) {
                    Image("chevronLeft")
                        .font(.title2)
                }

                Spacer()

                // Индикатор прогресса
                ProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)

                Spacer()

                // Пустой элемент для выравнивания
                Spacer().frame(width: 24)
            }
            .padding(.horizontal)
            .frame(height: 44)
        }
        .background(Color.black)
    }
}


#Preview {
    CustomToolbar(currentStep: 2, totalSteps: 6, onBack: {
        // Закрытие экрана
        print("Назад нажато") // Для проверки
    })
}

