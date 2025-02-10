//
//  SurveyResult.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 05/02/2025.
//

import SwiftUI

struct SurveyResult: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Ваши ответы").font(.title)
                Text("Имя: \(viewModel.name)")
                Text("Возраст: \(viewModel.age ?? 0)")
                Text("Пол: \(viewModel.gender ?? .male)")
                Text("Рост: \(viewModel.height ?? 0) см")
                Text("Вес: \(viewModel.weight ?? 0) кг")
                Text("Цель: \(viewModel.goal?.rawValue ?? "—")")
                Text("Опыт: \(viewModel.level ?? .lowActivity)")
                Text("Диета: \(viewModel.diet ?? .keto)")
                Text("Желаемый вес: \(viewModel.targetWeight ?? 0) кг")
                
                // Изменение для правильной работы с кнопкой
                Button(action: {
                    showingAlert = true
                }) {
                    CustomButton(title: "Завершить", state: .normal, destination: AnyView(MainView()))
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .customBackButton()
//        .alert(isPresented: $showingAlert) {
//            Alert(
//                title: Text("Ваш план составлен"),
//                message: Text("Вы можете просмотреть его в разделе 'Мой план' на главном экране."),
//                dismissButton: .default(Text("Ок"), action: {
//                    // По нажатию на "Ок" выполняем переход
//                    currentStep = 0 // Если нужно сбросить шаги
//                })
//            )
//        }
    }
}




#Preview {
    let viewModel = SurveyViewModel()
    return SurveyResult(viewModel: viewModel, currentStep: .constant(6))
}
