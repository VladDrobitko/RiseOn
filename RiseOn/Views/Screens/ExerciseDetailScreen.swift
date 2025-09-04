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
        VStack(spacing: 0) {
            // Navigation Bar
            navigationBar
            
            // Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Image Section
                    heroImageSection
                    
                    // Content Section
                    VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
                        // Header Info
                        exerciseHeaderSection
                        
                        // Tab Selection
                        tabSelectionSection
                        
                        // Tab Content
                        tabContentSection
                    }
                    .padding(.horizontal, DesignTokens.Padding.screen)
                    .padding(.bottom, 100) // Space for bottom button
                }
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
            Text(selectedTab.rawValue)
                .riseOnHeading3()
                .foregroundColor(.typographyPrimary)
            
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
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Exercise Image with fallback
                ZStack {
                    // Fallback background
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.typographyGrey.opacity(0.2))
                        .frame(width: geometry.size.width, height: 300)
                    
                    // Actual image
                    Image(exercise.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: 300)
                        .clipped()
                }
                .overlay(
                    // Gradient overlay
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .clear,
                            .black.opacity(0.3),
                            .black.opacity(0.7)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .frame(height: 300)
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
        }
    }
    
    private var tabSelectionSection: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            ForEach(DetailTab.allCases, id: \.self) { tab in
                ExerciseTabButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: DesignTokens.Animation.fast)) {
                        selectedTab = tab
                    }
                }
            }
            
            Spacer()
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
                    .foregroundColor(.typographyGrey)
                
                Text(value)
                    .riseOnBodySmall(.medium)
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
                Image(systemName: "star.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.typographyGrey)
                
                Text(difficulty.displayName)
                    .riseOnBodySmall(.medium)
                    .foregroundColor(difficultyColor)
            }
            
            Text("Difficulty")
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

// MARK: - Exercise Tab Button
struct ExerciseTabButton: View {
    let tab: DetailTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.xs) {
                Image(systemName: tab.icon)
                    .font(.system(size: 14, weight: .medium))
                
                Text(tab.rawValue)
                    .riseOnBodySmall(.medium)
            }
            .foregroundColor(isSelected ? .black : .typographyGrey)
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(
                isSelected ? 
                Color.primaryButton : 
                Color.typographyGrey.opacity(0.1)
            )
            .cornerRadius(DesignTokens.CornerRadius.pill)
        }
        .buttonStyle(PlainButtonStyle())
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
