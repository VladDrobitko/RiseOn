//
//  UserPreferScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserPreferScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SurveyStepCard(
                title: "What do you prefer?",
                subtitle: "Select your preferred training types (you can choose multiple)"
            ) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    // Selection Grid
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: DesignTokens.Spacing.sm), count: 2),
                        spacing: DesignTokens.Spacing.sm
                    ) {
                        ForEach(Prefer.allCases, id: \.self) { type in
                            PreferenceTagCard(
                                type: type,
                                isSelected: viewModel.selectedTrainingTypes.contains(type)
                            ) {
                                viewModel.toggleSelection(for: type)
                                viewModel.canProceedFromCurrentStep = !viewModel.selectedTrainingTypes.isEmpty
                            }
                        }
                    }
                    .padding(.horizontal, DesignTokens.Padding.screen)
                    
                    // Selection counter
                    if !viewModel.selectedTrainingTypes.isEmpty {
                        RiseOnCard(style: .outlined, size: .compact) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.primaryButton)
                                    .font(.caption)
                                
                                Text("\(viewModel.selectedTrainingTypes.count) types selected")
                                    .riseOnCaption()
                                    .foregroundColor(.typographyPrimary)
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, DesignTokens.Padding.screen)
                    }
                    
                    // Добавляем отступ снизу для кнопок
                    Color.clear.frame(height: 120)
                }
            }
        }
        .background(Color.black)
        .onAppear {
            viewModel.canProceedFromCurrentStep = !viewModel.selectedTrainingTypes.isEmpty
        }
    }
}

// MARK: - Preference Tag Card
struct PreferenceTagCard: View {
    let type: Prefer
    let isSelected: Bool
    let action: () -> Void
    
    private var icon: String {
        switch type {
        case .balance: return "figure.yoga"
        case .fitness: return "figure.run"
        case .strength: return "figure.strengthtraining.traditional"
        case .cardio: return "heart.fill"
        case .yoga: return "figure.yoga"
        case .stretching: return "figure.flexibility"
        case .endurance: return "figure.outdoor.cycle"
        case .weightlifting: return "dumbbell.fill"
        case .hit: return "bolt.fill"
        case .running: return "figure.run"
        }
    }
    

    
    var body: some View {
        RiseOnCard(
            style: .basic,
            size: .compact,
            onTap: action
        ) {
            VStack(spacing: DesignTokens.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(Color.typographyGrey.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(isSelected ? .white : .typographyGrey)
                }
                
                Text(type.rawValue)
                    .riseOnBodySmall(.medium)
                    .foregroundColor(isSelected ? .white : .typographyGrey)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.primaryButton)
                } else {
                    // Пустое место для баланса
                    Color.clear.frame(height: 12)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 85)
        }
        .background(isSelected ? .primaryButton : .clear)
        .cornerRadius(DesignTokens.CornerRadius.sm)
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                .stroke(isSelected ? .primaryButton : Color.clear, lineWidth: 1)
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: DesignTokens.Animation.fast), value: isSelected)
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserPreferScreen(viewModel: viewModel, currentStep: .constant(5))
        .preferredColorScheme(.dark)
}
