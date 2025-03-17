//
//  WelcomeToSurvey.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct WelcomeToSurvey: View {
    @ObservedObject var viewModel: SurveyViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack(alignment: .bottom) { // Задаем выравнивание ZStack по нижнему краю
            // Фоновое изображение
            Image("Welcom ro Riseon!")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                // Логотип вверху экрана
                VStack {
                    Image("logoRiseOn")
                }
                .padding(.top, 70)
                
                Spacer()
                
                // Текстовый блок снизу экрана
                VStack(alignment: .leading, spacing: 20) {
                    Text("Welcome to RiseOn!")
                        .font(.largeTitle)
                        .foregroundStyle(.typographyPrimary)
                    
                    Text("We will ask you some questions to better help you achieve your goal.")
                        .font(.title2)
                        .foregroundStyle(.typographyPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 140) // Увеличиваем отступ снизу для кнопки
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            // Кнопка будет размещена внизу благодаря alignment: .bottom у ZStack
            CustomButton(
                title: "Продолжить",
                state: .normal
            ) {
                coordinator.currentSurveyStep += 1
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
        .onAppear {
            // Активируем кнопку "Продолжить"
            viewModel.canProceedFromCurrentStep = true
        }
    }
}

// Предварительный просмотр для разработки
#Preview {
    let viewModel = SurveyViewModel()
    return WelcomeToSurvey(viewModel: viewModel)
        .background(Color.black)
        .preferredColorScheme(.dark)
}
