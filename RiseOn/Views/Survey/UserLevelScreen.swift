//
//  UserLevelScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserLevelScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            SurveyStepCard(
                title: "What is your activity level?",
                subtitle: "This helps us create the right workout intensity for you"
            ) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(Level.allCases, id: \.self) { level in
                        ActivityLevelCard(
                            level: level,
                            isSelected: viewModel.level == level
                        ) {
                            viewModel.saveLevel(level)
                            viewModel.canProceedFromCurrentStep = true
                        }
                        .padding(.horizontal, DesignTokens.Padding.screen)
                    }
                }
            }
        }
        .onAppear {
            viewModel.canProceedFromCurrentStep = viewModel.level != nil
        }
    }
}

// MARK: - Activity Level Card
struct ActivityLevelCard: View {
    let level: Level
    let isSelected: Bool
    let action: () -> Void
    
    private var icon: String {
        switch level {
        case .lowActivity: return "figure.walk"
        case .averageActivity: return "figure.run"
        case .highActivity: return "figure.strengthtraining.traditional"
        case .veryHighActivity: return "figure.mixed.cardio"
        }
    }
    
    private var intensityIndicator: (Color, String) {
        switch level {
        case .lowActivity: return (.gray, "Low")
        case .averageActivity: return (.yellow, "Medium")
        case .highActivity: return (.orange, "High")
        case .veryHighActivity: return (.red, "Very High")
        }
    }
    
    var body: some View {
        RiseOnCard(
            style: isSelected ? .gradient : .basic,
            size: .large,
            onTap: action
        ) {
            HStack(spacing: DesignTokens.Spacing.lg) {
                // Icon and intensity indicator
                VStack(spacing: DesignTokens.Spacing.sm) {
                    ZStack {
                        Circle()
                            .fill(intensityIndicator.0.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: icon)
                            .font(.system(size: DesignTokens.Sizes.iconMedium))
                            .foregroundColor(isSelected ? .primaryButton : intensityIndicator.0)
                    }
                    
                    Text(intensityIndicator.1)
                        .riseOnCaption(.medium)
                        .foregroundColor(intensityIndicator.0)
                }
                
                // Content
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(level.rawValue)
                        .riseOnHeading4()
                        .foregroundColor(.typographyPrimary)
                    
                    Text(level.description)
                        .riseOnBodySmall()
                        .foregroundColor(.typographyGrey)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.primaryButton)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .stroke(isSelected ? Color.primaryButton : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserLevelScreen(viewModel: viewModel, currentStep: .constant(4))
        .preferredColorScheme(.dark)
}
