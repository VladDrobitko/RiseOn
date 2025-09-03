//
//  UserGoalScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserGoalScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            SurveyStepCard(
                title: "What is your goal?",
                subtitle: "Choose your primary fitness objective to get personalized recommendations"
            ) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(Goal.allCases, id: \.self) { goal in
                        SurveyOptionCard(
                            title: goal.rawValue,
                            subtitle: goal.description,
                            isSelected: viewModel.goal == goal
                        ) {
                            viewModel.saveGoal(goal)
                            viewModel.canProceedFromCurrentStep = true
                        }
                        .padding(.horizontal, DesignTokens.Padding.screen)
                    }
                }
            }
        }
        .onAppear {
            viewModel.canProceedFromCurrentStep = viewModel.goal != nil
        }
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserGoalScreen(viewModel: viewModel, currentStep: .constant(3))
        .preferredColorScheme(.dark)
}
