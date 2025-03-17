//
//  SurveyCoordinatorView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

struct SurveyCoordinatorView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var viewModel: SurveyViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                // Отображаем нужный экран в зависимости от текущего шага опроса
                Group {
                    switch coordinator.currentSurveyStep {
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
                    if coordinator.currentSurveyStep > 1 {
                        CustomToolbar(currentStep: coordinator.currentSurveyStep - 1, totalSteps: 7) {
                            if coordinator.currentSurveyStep > 1 {
                                withAnimation {
                                    coordinator.currentSurveyStep -= 1
                                }
                            }
                        }
                        .zIndex(1) // Чтобы тулбар был над контентом
                    }
                    
                    Spacer()
                    
                    // Кнопка "Продолжить"/"Завершить"
                    // Кнопка "Продолжить"/"Завершить"
                    if coordinator.currentSurveyStep > 1 {
                        CustomButton(
                            title: coordinator.currentSurveyStep == 8 ? "Завершить" : "Продолжить",
                            state: coordinator.currentSurveyStep == 1 || viewModel.canProceedFromCurrentStep ? .normal : .disabled
                        ) {
                            if coordinator.currentSurveyStep < 8 {
                                // На первом экране кнопка всегда активна
                                if coordinator.currentSurveyStep == 1 {
                                    viewModel.canProceedFromCurrentStep = false
                                }
                                
                                // Переходим к следующему шагу
                                withAnimation {
                                    coordinator.currentSurveyStep += 1
                                }
                            } else {
                                // Завершаем опрос
                                viewModel.saveResults()
                                coordinator.completeSurvey()
                            }
                        }
                        .padding(.horizontal)  // Одинаковый отступ по горизонтали как в других экранах
                        .padding(.bottom, 30)  // Нижний отступ, чтобы кнопка не была слишком близко к краю
                    }
                    
                }
                .padding(.horizontal) 
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // При появлении экрана активируем кнопку для первого шага
            if coordinator.currentSurveyStep == 1 {
                viewModel.canProceedFromCurrentStep = true
            }
        }
    }
}

#Preview {
    let surveyViewModel = SurveyViewModel()
    let coordinator = AppCoordinator()
    
    // Настраиваем начальный шаг опроса для тестирования
    coordinator.currentSurveyStep = 2
    
    return SurveyCoordinatorView(viewModel: surveyViewModel)
        .environmentObject(coordinator)
        .preferredColorScheme(.dark)
}
