//
//  UserGoalScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserGoalOptionView: View {
    let goal: Goal
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(goal.rawValue)
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(.typographyPrimary)
                Text(goal.description)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.typographyGrey)
            }
            Spacer()
        }
        .padding(13)
        .frame(maxWidth: .infinity)
        .background(isSelected ? LinearGradient.gradientDarkGreen : nil)
        .background(!isSelected ? Color.card : nil)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.primaryButton : Color.gray, lineWidth: 0.5)
        )
        .cornerRadius(10)
    }
}

struct UserGoalScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("What is your goal?")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.typographyPrimary)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    ForEach(Goal.allCases, id: \.self) { goal in
                        Button(action: {
                            // Сохраняем выбранную цель
                            viewModel.saveGoal(goal)
                            // Активируем кнопку "Продолжить" в основном SurveyFlowView
                            viewModel.canProceedFromCurrentStep = true
                        }) {
                            UserGoalOptionView(goal: goal, isSelected: viewModel.goal == goal)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                // При появлении экрана проверяем, выбрана ли уже цель
                viewModel.canProceedFromCurrentStep = viewModel.goal != nil
            }
        }
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserGoalScreen(viewModel: viewModel, currentStep: .constant(3))
}
