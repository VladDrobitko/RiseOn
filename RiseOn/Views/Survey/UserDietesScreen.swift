//
//  UserDietesScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserDietesScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            SurveyStepCard(
                title: "Do you follow any of these diets?",
                subtitle: "This helps us suggest appropriate meal plans and recipes"
            ) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(Diet.allCases, id: \.self) { diet in
                        DietOptionCard(
                            diet: diet,
                            isSelected: viewModel.diet == diet
                        ) {
                            viewModel.saveDiet(diet)
                            viewModel.canProceedFromCurrentStep = true
                        }
                        .padding(.horizontal, DesignTokens.Padding.screen)
                    }
                }
            }
        }
        .onAppear {
            viewModel.canProceedFromCurrentStep = viewModel.diet != nil
        }
    }
}

// MARK: - Diet Option Card
struct DietOptionCard: View {
    let diet: Diet
    let isSelected: Bool
    let action: () -> Void
    
    private var icon: String {
        switch diet {
        case .vegetarian: return "leaf.fill"
        case .vegan: return "carrot.fill"
        case .keto: return "fish.fill"
        case .mediterranean: return "drop.fill"
        case .noAnyDietes: return "xmark.circle"
        }
    }
    
    private var color: Color {
        switch diet {
        case .vegetarian: return .green
        case .vegan: return .mint
        case .keto: return .orange
        case .mediterranean: return .blue
        case .noAnyDietes: return .gray
        }
    }
    
    private var tag: String? {
        switch diet {
        case .vegetarian: return "Popular"
        case .keto: return "Low Carb"
        case .mediterranean: return "Heart Healthy"
        default: return nil
        }
    }
    
    var body: some View {
        RiseOnCard(
            style: isSelected ? .gradient : .basic,
            size: .large,
            onTap: action
        ) {
            HStack(spacing: DesignTokens.Spacing.lg) {
                // Icon
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: DesignTokens.Sizes.iconMedium))
                        .foregroundColor(isSelected ? color : .typographyGrey)
                }
                
                // Content
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    HStack {
                        Text(diet.rawValue)
                            .riseOnHeading4()
                            .foregroundColor(.typographyPrimary)
                        
                        if let tag = tag {
                            Text(tag)
                                .riseOnCaption(.medium)
                                .foregroundColor(color)
                                .padding(.horizontal, DesignTokens.Spacing.sm)
                                .padding(.vertical, DesignTokens.Spacing.xs)
                                .background(color.opacity(0.2))
                                .cornerRadius(DesignTokens.CornerRadius.xs)
                        }
                        
                        Spacer()
                    }
                    
                    Text(diet.description)
                        .riseOnBodySmall()
                        .foregroundColor(.typographyGrey)
                        .lineLimit(2)
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.primaryButton)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .stroke(isSelected ? color : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserDietesScreen(viewModel: viewModel, currentStep: .constant(6))
        .preferredColorScheme(.dark)
}
