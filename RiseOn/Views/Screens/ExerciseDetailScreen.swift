//
//  ExerciseDetailScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct ExerciseDetailScreen: View {
    let exercise: Exercise
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: DetailTab = .instruction
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // Hero Image Section
                heroImageSection
                
                // Content Section
                VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
                    // Header Info
                    exerciseHeaderSection
                    
                    // Segmented Tab Selection
                    segmentedTabSelection
                    
                    // Tab Content
                    tabContentSection
                }
                .padding(.horizontal, DesignTokens.Padding.screen)
                .padding(.bottom, 50) // Reduced padding since no button
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

// MARK: - Detail Tabs
enum DetailTab: String, CaseIterable {
    case instruction = "Instruction"
    case muscles = "Muscles"
    case tips = "Tips"
    
    var icon: String {
        switch self {
        case .instruction: return "list.bullet"
        case .muscles: return "figure.strengthtraining.traditional"
        case .tips: return "lightbulb"
        }
    }
}

// MARK: - Components
extension ExerciseDetailScreen {
    
    private var navigationBar: some View {
        ZStack {
            // Заголовок по центру экрана
            Text(exercise.name)
                .riseOnHeading3()
                .foregroundColor(.typographyPrimary)
                .lineLimit(1)
            
            // Боковые кнопки
            HStack {
                // Кнопка назад слева
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.typographyPrimary)
                }
                
                Spacer()
                
                // Кнопка избранного справа
                Button(action: {}) {
                    Image(systemName: "heart")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(.typographyPrimary)
                }
            }
        }
        .padding(.horizontal, DesignTokens.Padding.screen)
        .padding(.top, 8)
        .frame(height: 52)
        .background(Color.black.ignoresSafeArea(edges: .top))
    }
    
    private var heroImageSection: some View {
        ExerciseHeroImage(exercise: exercise)
    }
    
    private var exerciseHeaderSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            // Exercise Name
            Text(exercise.name)
                .riseOnHeading1()
                .foregroundColor(.typographyPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Stats Row
            HStack(spacing: DesignTokens.Spacing.lg) {
                StatItem(
                    icon: "clock",
                    value: "\(exercise.duration) min",
                    label: "Duration"
                )
                
                StatItem(
                    icon: "flame",
                    value: "\(exercise.calories) kcal",
                    label: "Calories"
                )
                
                DifficultyIndicator(difficulty: exercise.difficulty)
                
                Spacer()
            }
            
            // Equipment Section
            if !exercise.equipment.isEmpty {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    Text("Equipment")
                        .riseOnHeading4()
                        .foregroundColor(.typographyPrimary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignTokens.Spacing.sm) {
                            ForEach(exercise.equipment, id: \.self) { equipment in
                                EquipmentChip(equipment: equipment)
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
            }
        }
    }
    
    private var segmentedTabSelection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            // Segmented Picker with gradient background
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.primaryButton.opacity(0.1),
                        Color.primaryButton.opacity(0.05)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .cornerRadius(DesignTokens.CornerRadius.button)
                
                HStack(spacing: 0) {
                    ForEach(DetailTab.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = tab
                            }
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text(tab.rawValue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(selectedTab == tab ? .black : .typographyGrey)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                Group {
                                    if selectedTab == tab {
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.primaryButton,
                                                Color.primaryButton.opacity(0.8)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                        .cornerRadius(DesignTokens.CornerRadius.button - 2)
                                    } else {
                                        Color.clear
                                    }
                                }
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(4)
            }
            .frame(height: 68)
        }
    }
    
    @ViewBuilder
    private var tabContentSection: some View {
        switch selectedTab {
        case .instruction:
            InstructionTabContent(exercise: exercise)
        case .muscles:
            MuscleTabContent(exercise: exercise)
        case .tips:
            TipsTabContent(exercise: exercise)
        }
    }
}

// MARK: - Supporting Components

// MARK: - Stat Item Component
struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            HStack(spacing: DesignTokens.Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(.primaryButton)
                
                Text(value)
                    .riseOnHeading4()
                    .foregroundColor(.typographyPrimary)
            }
            
            Text(label)
                .riseOnCaption()
                .foregroundColor(.typographyGrey)
        }
    }
}

// MARK: - Difficulty Indicator
struct DifficultyIndicator: View {
    let difficulty: ExerciseDifficulty
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            HStack(spacing: DesignTokens.Spacing.xs) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index < difficulty.difficultyLevel ? difficultyColor : Color.typographyGrey.opacity(0.3))
                        .frame(width: 6, height: 6)
                }
            }
            
            Text(difficulty.displayName)
                .riseOnCaption()
                .foregroundColor(.typographyGrey)
        }
    }
    
    private var difficultyColor: Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

// MARK: - Equipment Chip
struct EquipmentChip: View {
    let equipment: Equipment
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: equipment.icon)
                .font(.system(size: 14))
                .foregroundColor(.primaryButton)
            
            Text(equipment.displayName)
                .riseOnBody()
                .foregroundColor(.typographyPrimary)
        }
        .padding(.horizontal, DesignTokens.Spacing.md)
        .padding(.vertical, DesignTokens.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                .fill(Color.primaryButton.opacity(0.1))
        )
    }
}

#Preview {
    let mockExercise = Exercise(
        id: "1",
        name: "Dumbbell Squat",
        description: "The dumbbell squat is a strength exercise that primarily targets the muscles of the lower body.",
        instructions: ["Stand with feet shoulder-width apart", "Hold dumbbells at your sides"],
        muscleGroup: .legs,
        difficulty: .intermediate,
        duration: 15,
        calories: 120,
        equipment: [.dumbbells],
        imageName: "dumbbell_squat",
        videoName: nil,
        resistanceIntensity: .medium,
        targetMuscles: ["Quadriceps", "Glutes"],
        tips: ["Keep your knees in line with your toes"],
        variations: ["Goblet Squat", "Sumo Squat"]
    )
    
    return ExerciseDetailScreen(exercise: mockExercise)
        .preferredColorScheme(.dark)
}
