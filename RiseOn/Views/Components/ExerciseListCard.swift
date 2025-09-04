//
//  ExerciseListCard.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct ExerciseListCard: View {
    let exercise: Exercise
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            RiseOnCard(style: .basic, size: .medium) {
                HStack(spacing: DesignTokens.Spacing.md) {
                    // Exercise Image
                    ZStack {
                        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                            .fill(Color.typographyGrey.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(exercise.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipped()
                            .cornerRadius(DesignTokens.CornerRadius.sm)
                    }
                    
                    // Exercise Info
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        // Title and difficulty
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                            Text(exercise.name)
                                .riseOnHeading4()
                                .foregroundColor(.typographyPrimary)
                                .lineLimit(1)
                            
                            DifficultyBadge(difficulty: exercise.difficulty)
                        }
                        
                        // Stats
                        HStack(spacing: DesignTokens.Spacing.md) {
                            StatChip(
                                icon: "clock",
                                text: "\(exercise.duration) min",
                                color: .typographyGrey
                            )
                            
                            StatChip(
                                icon: "flame",
                                text: "\(exercise.calories) kcal",
                                color: .typographyGrey
                            )
                            
                            Spacer()
                        }
                        
                        // Equipment tags
                        if !exercise.equipment.isEmpty {
                            HStack(spacing: DesignTokens.Spacing.xs) {
                                ForEach(Array(exercise.equipment.prefix(2)), id: \.self) { equipment in
                                    EquipmentTag(equipment: equipment)
                                }
                                
                                if exercise.equipment.count > 2 {
                                    Text("+\(exercise.equipment.count - 2)")
                                        .riseOnCaption()
                                        .foregroundColor(.typographyGrey)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.typographyGrey.opacity(0.1))
                                        )
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    
                    // Arrow
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.typographyGrey)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Difficulty Badge
struct DifficultyBadge: View {
    let difficulty: ExerciseDifficulty
    
    var body: some View {
        Text(difficulty.displayName)
            .riseOnCaption(.medium)
            .foregroundColor(badgeColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(badgeColor.opacity(0.1))
            )
    }
    
    private var badgeColor: Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

// MARK: - Equipment Tag
struct EquipmentTag: View {
    let equipment: Equipment
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: equipment.icon)
                .font(.system(size: 10))
                .foregroundColor(.typographyGrey)
            
            Text(equipment.displayName)
                .riseOnCaption()
                .foregroundColor(.typographyGrey)
                .lineLimit(1)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.typographyGrey.opacity(0.1))
        )
    }
}

#Preview {
    let mockExercise = Exercise(
        id: "1",
        name: "Dumbbell Squat",
        description: "Great lower body exercise",
        instructions: [],
        muscleGroup: .legs,
        difficulty: .intermediate,
        duration: 15,
        calories: 120,
        equipment: [.dumbbells, .bench],
        imageName: "dumbbell_squat",
        videoName: nil,
        resistanceIntensity: .medium,
        targetMuscles: [],
        tips: [],
        variations: []
    )
    
    return VStack(spacing: 16) {
        ExerciseListCard(exercise: mockExercise) {
            print("Exercise tapped")
        }
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
