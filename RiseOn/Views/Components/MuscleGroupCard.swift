//
//  MuscleGroupCard.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct MuscleGroupCard: View {
    let muscleGroup: MuscleGroup
    let exerciseCount: Int
    let estimatedTime: Int // в минутах
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            RiseOnCard(style: .basic, size: .large) {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    // Header with icon
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.primaryButton.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: muscleGroup.icon)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.primaryButton)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.typographyGrey)
                    }
                    
                    // Title and description
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        Text(muscleGroup.displayName)
                            .riseOnHeading3()
                            .foregroundColor(.typographyPrimary)
                        
                        Text("Build strength and muscle")
                            .riseOnBody()
                            .foregroundColor(.typographyGrey)
                            .lineLimit(2)
                    }
                    
                    // Stats
                    HStack(spacing: DesignTokens.Spacing.lg) {
                        StatChip(
                            icon: "list.bullet",
                            text: "\(exerciseCount) exercises",
                            color: .typographyGrey
                        )
                        
                        StatChip(
                            icon: "clock",
                            text: "\(estimatedTime) min",
                            color: .typographyGrey
                        )
                        
                        Spacer()
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Stat Chip Component
struct StatChip: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(color)
            
            Text(text)
                .riseOnCaption(.medium)
                .foregroundColor(color)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        MuscleGroupCard(
            muscleGroup: .legs,
            exerciseCount: 12,
            estimatedTime: 25
        ) {
            print("Legs tapped")
        }
        
        MuscleGroupCard(
            muscleGroup: .chest,
            exerciseCount: 8,
            estimatedTime: 20
        ) {
            print("Chest tapped")
        }
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
