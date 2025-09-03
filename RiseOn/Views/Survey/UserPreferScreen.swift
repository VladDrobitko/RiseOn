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
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            SurveyStepCard(
                title: "What do you prefer?",
                subtitle: "Select your preferred training types (you can choose multiple)"
            ) {
                VStack(spacing: DesignTokens.Spacing.lg) {
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
                                
                                Text("\(viewModel.selectedTrainingTypes.count) types selected")
                                    .riseOnBodySmall(.medium)
                                    .foregroundColor(.typographyPrimary)
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, DesignTokens.Padding.screen)
                    }
                }
            }
        }
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
    
    private var color: Color {
        switch type {
        case .balance: return .blue
        case .fitness: return .green
        case .strength: return .red
        case .cardio: return .pink
        case .yoga: return .purple
        case .stretching: return .orange
        case .endurance: return .cyan
        case .weightlifting: return .brown
        case .hit: return .yellow
        case .running: return .mint
        }
    }
    
    var body: some View {
        RiseOnCard(
            style: isSelected ? .gradient : .basic,
            size: .medium,
            onTap: action
        ) {
            VStack(spacing: DesignTokens.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill((isSelected ? color : Color.typographyGrey).opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: DesignTokens.Sizes.iconSmall))
                        .foregroundColor(isSelected ? color : .typographyGrey)
                }
                
                Text(type.rawValue)
                    .riseOnBodySmall(.medium)
                    .foregroundColor(isSelected ? .typographyPrimary : .typographyGrey)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.primaryButton)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
        }
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .stroke(isSelected ? color : Color.clear, lineWidth: 2)
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
