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
            style: .basic,
            size: .medium,
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
                    HStack {
                        Text(diet.rawValue)
                            .riseOnBodySmall(.medium)
                            .foregroundColor(.typographyPrimary)
                        
                        if let tag = tag {
                            Text(tag)
                                .font(.system(size: 10))
                                .foregroundColor(isSelected ? .white : .typographyGrey)
                                .padding(.horizontal, DesignTokens.Spacing.xs)
                                .padding(.vertical, 2)
                                .background(Color.typographyGrey.opacity(0.2))
                                .cornerRadius(DesignTokens.CornerRadius.xs)
                        }
                        
                        Spacer()
                    }
                    
                    Text(diet.description)
                        .riseOnCaption()
                        .foregroundColor(.typographyGrey)
                        .lineLimit(2)
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.primaryButton)
                }
            }
            .frame(height: 60)
        }
        .background(isSelected ? .primaryButton : .clear)
        .cornerRadius(DesignTokens.CornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                .stroke(isSelected ? .primaryButton : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserDietesScreen(viewModel: viewModel, currentStep: .constant(6))
        .preferredColorScheme(.dark)
}
