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
                        GoalOptionCard(
                            goal: goal,
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

// MARK: - Goal Option Card
struct GoalOptionCard: View {
    let goal: Goal
    let isSelected: Bool
    let action: () -> Void
    
    private var icon: String {
        switch goal {
        case .loseWeight: return "arrow.down.circle"
        case .buildMuscle: return "dumbbell"
        case .maintainWeight: return "equal.circle"
        case .developFlexibility: return "figure.flexibility"
        }
    }
    
    var body: some View {
        RiseOnCard(
            style: .selectable,
            size: .medium,
            isSelected: isSelected,
            onTap: action
        ) {
            HStack(spacing: DesignTokens.Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.typographyGrey.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(isSelected ? .white : .typographyGrey)
                }
                
                // Content
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(goal.rawValue)
                        .riseOnBodySmall(.medium)
                        .foregroundColor(isSelected ? .white : .typographyPrimary)
                    
                    Text(goal.description)
                        .riseOnCaption()
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .typographyGrey)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.primaryButton)
                }
            }
            .frame(height: 60)
        }
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserGoalScreen(viewModel: viewModel, currentStep: .constant(3))
        .preferredColorScheme(.dark)
}
