//
//  WorkoutView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 16/02/2025.
//

import SwiftUI

struct WorkoutPage: View {
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.xl) {
                // Заголовок секции
                VStack(spacing: DesignTokens.Spacing.md) {
                    Text("Your Workouts")
                        .riseOnHeading1()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Track your progress and discover new exercises")
                        .riseOnBody()
                        .foregroundColor(.typographyGrey)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, DesignTokens.Padding.screen)
                
                // Placeholder карточки
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: DesignTokens.Spacing.md) {
                    ForEach(0..<6, id: \.self) { index in
                        RiseOnCard(style: .basic, size: .medium) {
                            VStack(spacing: DesignTokens.Spacing.sm) {
                                Image(systemName: "dumbbell.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.primaryButton)
                                
                                Text("Workout \(index + 1)")
                                    .riseOnBodySmall(.semibold)
                                    .foregroundColor(.typographyPrimary)
                                
                                Text("Coming soon")
                                    .riseOnCaption()
                                    .foregroundColor(.typographyGrey)
                            }
                            .frame(height: 80)
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
    WorkoutPage()
}
