//
//  ExerciseDetailTabs.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

// MARK: - Instruction Tab Content
struct InstructionTabContent: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sectionSpacing) {
            // Description
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Description")
                    .riseOnHeading3()
                    .foregroundColor(.typographyPrimary)
                
                Text(exercise.description)
                    .riseOnBody()
                    .foregroundColor(.typographyGrey)
                    .lineSpacing(4)
            }
            
            // Instructions
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("How to perform")
                    .riseOnHeading3()
                    .foregroundColor(.typographyPrimary)
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, instruction in
                        InstructionStep(
                            number: index + 1,
                            text: instruction
                        )
                    }
                }
            }
            
            // Equipment
            if !exercise.equipment.isEmpty {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    Text("Equipment needed")
                        .riseOnHeading3()
                        .foregroundColor(.typographyPrimary)
                    
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: DesignTokens.Spacing.sm), count: 2),
                        spacing: DesignTokens.Spacing.sm
                    ) {
                        ForEach(exercise.equipment, id: \.self) { equipment in
                            EquipmentCard(equipment: equipment)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Muscle Tab Content
struct MuscleTabContent: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sectionSpacing) {
            // Muscle Focus
            Text("Muscle Focus")
                .riseOnHeading3()
                .foregroundColor(.typographyPrimary)
            
            // Body diagram with front and back views
            HStack(spacing: DesignTokens.Spacing.md) {
                // Front view
                VStack(spacing: DesignTokens.Spacing.sm) {
                    Text("Front")
                        .riseOnCaption(.medium)
                        .foregroundColor(.typographyGrey)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                            .fill(Color.typographyGrey.opacity(0.1))
                            .frame(height: 220)
                        
                        Group {
                            if UIImage(named: "muscle_diagram_front") != nil {
                                Image("muscle_diagram_front")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 200)
                                    .clipped()
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "figure.strengthtraining.traditional")
                                        .font(.system(size: 40))
                                        .foregroundColor(.typographyGrey)
                                    Text("Front View")
                                        .riseOnCaption()
                                        .foregroundColor(.typographyGrey)
                                }
                            }
                        }
                    }
                    .cornerRadius(DesignTokens.CornerRadius.md)
                }
                
                // Back view
                VStack(spacing: DesignTokens.Spacing.sm) {
                    Text("Back")
                        .riseOnCaption(.medium)
                        .foregroundColor(.typographyGrey)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                            .fill(Color.typographyGrey.opacity(0.1))
                            .frame(height: 220)
                        
                        Group {
                            if UIImage(named: "muscle_diagram_back") != nil {
                                Image("muscle_diagram_back")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 200)
                                    .clipped()
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "figure.strengthtraining.functional")
                                        .font(.system(size: 40))
                                        .foregroundColor(.typographyGrey)
                                    Text("Back View")
                                        .riseOnCaption()
                                        .foregroundColor(.typographyGrey)
                                }
                            }
                        }
                    }
                    .cornerRadius(DesignTokens.CornerRadius.md)
                }
            }
            
            // Target Muscles
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Target Muscles")
                    .riseOnHeading4()
                    .foregroundColor(.typographyPrimary)
                
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: DesignTokens.Spacing.sm), count: 2),
                    spacing: DesignTokens.Spacing.sm
                ) {
                    ForEach(exercise.targetMuscles, id: \.self) { muscle in
                        TargetMuscleCard(muscleName: muscle)
                    }
                }
            }
            
            // Resistance Intensity
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Resistance Intensity")
                    .riseOnHeading4()
                    .foregroundColor(.typographyPrimary)
                
                ResistanceIntensityIndicator(intensity: exercise.resistanceIntensity)
            }
        }
    }
}

// MARK: - Tips Tab Content
struct TipsTabContent: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sectionSpacing) {
            // Tips
            if !exercise.tips.isEmpty {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    Text("Tips & Safety")
                        .riseOnHeading3()
                        .foregroundColor(.typographyPrimary)
                    
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        ForEach(Array(exercise.tips.enumerated()), id: \.offset) { index, tip in
                            TipCard(tip: tip)
                        }
                    }
                }
            }
            
            // Variations
            if !exercise.variations.isEmpty {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    Text("Variations")
                        .riseOnHeading3()
                        .foregroundColor(.typographyPrimary)
                    
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        ForEach(exercise.variations, id: \.self) { variation in
                            VariationCard(variation: variation)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Components

struct InstructionStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.md) {
            // Step number
            ZStack {
                Circle()
                    .fill(Color.primaryButton)
                    .frame(width: 24, height: 24)
                
                Text("\(number)")
                    .riseOnCaption(.medium)
                    .foregroundColor(.black)
            }
            
            // Step text
            Text(text)
                .riseOnBody()
                .foregroundColor(.typographyGrey)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct EquipmentCard: View {
    let equipment: Equipment
    
    var body: some View {
        RiseOnCard(style: .basic, size: .compact) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: equipment.icon)
                    .font(.system(size: 16))
                    .foregroundColor(.primaryButton)
                
                Text(equipment.displayName)
                    .riseOnBodySmall(.medium)
                    .foregroundColor(.typographyPrimary)
                    .lineLimit(1)
                
                Spacer()
            }
        }
    }
}

struct TargetMuscleCard: View {
    let muscleName: String
    
    var body: some View {
        RiseOnCard(style: .basic, size: .compact) {
            HStack {
                Text(muscleName)
                    .riseOnBodySmall(.medium)
                    .foregroundColor(.typographyPrimary)
                    .lineLimit(1)
                
                Spacer()
                
                Circle()
                    .fill(Color.primaryButton)
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct ResistanceIntensityIndicator: View {
    let intensity: ResistanceIntensity
    
    var body: some View {
        RiseOnCard(style: .basic, size: .medium) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    Text(intensity.displayName)
                        .riseOnHeading4()
                        .foregroundColor(.typographyPrimary)
                    
                    Spacer()
                    
                    Text("Resistance intensity")
                        .riseOnCaption()
                        .foregroundColor(.typographyGrey)
                }
                
                // Intensity bars
                HStack(spacing: DesignTokens.Spacing.xs) {
                    ForEach(1...3, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index <= intensity.intensityLevel ? intensityColor : Color.typographyGrey.opacity(0.3))
                            .frame(height: 6)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    private var intensityColor: Color {
        switch intensity {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

struct TipCard: View {
    let tip: String
    
    var body: some View {
        RiseOnCard(style: .basic, size: .medium) {
            HStack(alignment: .top, spacing: DesignTokens.Spacing.md) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryButton)
                
                Text(tip)
                    .riseOnBody()
                    .foregroundColor(.typographyGrey)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct VariationCard: View {
    let variation: String
    
    var body: some View {
        RiseOnCard(style: .basic, size: .medium) {
            HStack {
                Text(variation)
                    .riseOnBodySmall(.medium)
                    .foregroundColor(.typographyPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.typographyGrey)
            }
        }
    }
}
