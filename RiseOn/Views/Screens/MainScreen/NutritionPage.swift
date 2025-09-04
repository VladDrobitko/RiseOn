//
//  NutritionView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 16/02/2025.
//

import SwiftUI

struct NutritionPage: View {
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.xl) {
                // Заголовок секции
                VStack(spacing: DesignTokens.Spacing.md) {
                    Text("Nutrition Plan")
                        .riseOnHeading1()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Healthy meals and nutrition tracking")
                        .riseOnBody()
                        .foregroundColor(.typographyGrey)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, DesignTokens.Padding.screen)
                
                // Карточки питания
                VStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(["Breakfast", "Lunch", "Dinner", "Snacks"], id: \.self) { meal in
                        RiseOnCard(style: .basic, size: .medium) {
                            HStack {
                                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                                    Text(meal)
                                        .riseOnBodySmall(.semibold)
                                        .foregroundColor(.typographyPrimary)
                                    
                                    Text("Plan your \(meal.lowercased())")
                                        .riseOnCaption()
                                        .foregroundColor(.typographyGrey)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.primaryButton)
                            }
                            .padding(.horizontal, DesignTokens.Spacing.md)
                            .frame(height: 60)
                        }
                    }
                }
                .padding(.horizontal, DesignTokens.Padding.screen)
            }
            .padding(.top, DesignTokens.Spacing.xl)
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    NutritionPage()
}
