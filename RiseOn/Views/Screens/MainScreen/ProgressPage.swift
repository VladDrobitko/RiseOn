//
//  ProgressView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 16/02/2025.
//

import SwiftUI

struct ProgressPage: View {
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.xl) {
                // Заголовок секции
                VStack(spacing: DesignTokens.Spacing.md) {
                    Text("Your Progress")
                        .riseOnHeading1()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Track your achievements and goals")
                        .riseOnBody()
                        .foregroundColor(.typographyGrey)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, DesignTokens.Padding.screen)
                
                // Статистические карточки
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: DesignTokens.Spacing.md) {
                    
                    // Вес
                    RiseOnCard(style: .basic, size: .medium) {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            Image(systemName: "scalemass.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.primaryButton)
                            
                            Text("Weight")
                                .riseOnBodySmall(.semibold)
                                .foregroundColor(.typographyPrimary)
                            
                            Text("-- kg")
                                .riseOnCaption()
                                .foregroundColor(.typographyGrey)
                        }
                        .frame(height: 80)
                    }
                    
                    // Тренировки
                    RiseOnCard(style: .basic, size: .medium) {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.primaryButton)
                            
                            Text("Workouts")
                                .riseOnBodySmall(.semibold)
                                .foregroundColor(.typographyPrimary)
                            
                            Text("0 this week")
                                .riseOnCaption()
                                .foregroundColor(.typographyGrey)
                        }
                        .frame(height: 80)
                    }
                    
                    // Калории
                    RiseOnCard(style: .basic, size: .medium) {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 24))
                                .foregroundColor(.primaryButton)
                            
                            Text("Calories")
                                .riseOnBodySmall(.semibold)
                                .foregroundColor(.typographyPrimary)
                            
                            Text("-- kcal")
                                .riseOnCaption()
                                .foregroundColor(.typographyGrey)
                        }
                        .frame(height: 80)
                    }
                    
                    // Цель
                    RiseOnCard(style: .basic, size: .medium) {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            Image(systemName: "target")
                                .font(.system(size: 24))
                                .foregroundColor(.primaryButton)
                            
                            Text("Goal")
                                .riseOnBodySmall(.semibold)
                                .foregroundColor(.typographyPrimary)
                            
                            Text("Set target")
                                .riseOnCaption()
                                .foregroundColor(.typographyGrey)
                        }
                        .frame(height: 80)
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
    ProgressPage()
}
