//
//  SurveyCoordinatorView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

struct SurveyCoordinatorView: View {
    @ObservedObject var viewModel: SurveyViewModel
    @State private var currentStep: Int = 1
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                // Отображаем нужный экран в зависимости от текущего шага опроса
                Group {
                    switch currentStep {
                    case 1:
                        WelcomeToSurvey(viewModel: viewModel)
                            .transition(.opacity)
                    case 2:
                        AboutUserScreen(viewModel: viewModel, currentStep: .constant(2))
                            .transition(.opacity)
                    case 3:
                        UserGoalScreen(viewModel: viewModel, currentStep: .constant(3))
                            .transition(.opacity)
                    case 4:
                        UserLevelScreen(viewModel: viewModel, currentStep: .constant(4))
                            .transition(.opacity)
                    case 5:
                        UserPreferScreen(viewModel: viewModel, currentStep: .constant(5))
                            .transition(.opacity)
                    case 6:
                        UserDietesScreen(viewModel: viewModel, currentStep: .constant(6))
                            .transition(.opacity)
                    case 7:
                        WorkoutDaysScreen(viewModel: viewModel, currentStep: .constant(7))
                            .transition(.opacity)
                    case 8:
                        SurveyResult(viewModel: viewModel, currentStep: .constant(8))
                            .transition(.opacity)
                    default:
                        EmptyView()
                    }
                }
                
                VStack {
                    // Тулбар для шагов 2-8
                    if currentStep > 1 {
                        CustomToolbar(currentStep: currentStep - 1, totalSteps: 7) {
                            if currentStep > 1 {
                                withAnimation {
                                    currentStep -= 1
                                }
                            }
                        }
                        .zIndex(1) // Чтобы тулбар был над контентом
                    }
                    
                    Spacer()
                    
                    // Кнопка "Продолжить"/"Завершить"
                    if currentStep > 1 {
                        CustomButton(
                            title: currentStep == 8 ? "Завершить" : "Продолжить",
                            state: currentStep == 1 || viewModel.canProceedFromCurrentStep ? .normal : .disabled
                        ) {
                            if currentStep < 8 {
                                // На первом экране кнопка всегда активна
                                if currentStep == 1 {
                                    viewModel.canProceedFromCurrentStep = false
                                }
                                
                                // Переходим к следующему шагу
                                withAnimation {
                                    currentStep += 1
                                }
                            } else {
                                // Завершаем опрос
                                self.viewModel.saveResults()
                                // TODO: Сохранить результаты в профиль
                                dismiss()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // При появлении экрана активируем кнопку для первого шага
            if currentStep == 1 {
                viewModel.canProceedFromCurrentStep = true
            }
        }
    }
}

#Preview {
    let surveyViewModel = SurveyViewModel()
    
    return SurveyCoordinatorView(viewModel: surveyViewModel)
        .preferredColorScheme(.dark)
}
