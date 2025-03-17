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

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Ваши ответы")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        resultRow(title: "Имя:", value: viewModel.name)
                        resultRow(title: "Возраст:", value: "\(viewModel.age ?? 0)")
                        resultRow(title: "Пол:", value: "\(viewModel.gender?.description ?? "—")")
                        resultRow(title: "Рост:", value: "\(viewModel.height ?? 0) см")
                        resultRow(title: "Вес:", value: "\(viewModel.weight ?? 0) кг")
                        resultRow(title: "Цель:", value: viewModel.goal?.rawValue ?? "—")
                        resultRow(title: "Опыт:", value: viewModel.level?.rawValue ?? "—")
                        resultRow(title: "Диета:", value: viewModel.diet?.rawValue ?? "—")
                        resultRow(title: "Желаемый вес:", value: "\(viewModel.targetWeight ?? 0) кг")
                        
                        if !viewModel.selectedTrainingTypes.isEmpty {
                            Text("Предпочтения тренировок:")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                            
                            ForEach(Array(viewModel.selectedTrainingTypes), id: \.self) { type in
                                Text("• \(type.rawValue)")
                                    .foregroundColor(.white)
                                    .padding(.leading)
                            }
                        }
                    }
                    .padding()
                    .background(Color.card)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
            .padding()
            .onAppear {
                // Разрешаем завершение опроса
                viewModel.canProceedFromCurrentStep = true
            }
        }
    }
    
    private func resultRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return SurveyResult(viewModel: viewModel, currentStep: .constant(8))
        .background(Color.black)
}
