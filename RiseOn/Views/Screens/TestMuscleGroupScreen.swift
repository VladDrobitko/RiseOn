//
//  TestMuscleGroupScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct TestMuscleGroupScreen: View {
    @StateObject private var exerciseService = ExerciseService.shared
    @State private var showingExerciseList: MuscleGroup?
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            navigationBar
            
            // Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    // Header
                    headerSection
                    
                    // Muscle Groups
                    muscleGroupsSection
                }
                .padding(.horizontal, DesignTokens.Padding.screen)
                .padding(.bottom, 100)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(item: $showingExerciseList) { muscleGroup in
            ExerciseListScreen(muscleGroup: muscleGroup)
        }
    }
}

// MARK: - Components
extension TestMuscleGroupScreen {
    
    private var navigationBar: some View {
        ZStack {
            // Заголовок по центру экрана
            Text("Workouts")
                .riseOnHeading3()
                .foregroundColor(.typographyPrimary)
            
            // Боковые кнопки
            HStack {
                Spacer()
                
                // Кнопка поиска справа
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
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
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Choose your focus")
                .riseOnHeading1()
                .foregroundColor(.typographyPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Select a muscle group to see available exercises")
                .riseOnBody()
                .foregroundColor(.typographyGrey)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, DesignTokens.Spacing.xl)
    }
    
    private var muscleGroupsSection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            ForEach(availableMuscleGroups, id: \.self) { muscleGroup in
                MuscleGroupCard(
                    muscleGroup: muscleGroup,
                    exerciseCount: exerciseCountFor(muscleGroup),
                    estimatedTime: estimatedTimeFor(muscleGroup)
                ) {
                    showingExerciseList = muscleGroup
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private var availableMuscleGroups: [MuscleGroup] {
        // Показываем только те группы мышц, для которых есть упражнения
        let allGroups = MuscleGroup.allCases
        return allGroups.filter { muscleGroup in
            !exerciseService.getExercises(for: muscleGroup).isEmpty
        }
    }
    
    private func exerciseCountFor(_ muscleGroup: MuscleGroup) -> Int {
        exerciseService.getExercises(for: muscleGroup).count
    }
    
    private func estimatedTimeFor(_ muscleGroup: MuscleGroup) -> Int {
        let exercises = exerciseService.getExercises(for: muscleGroup)
        return exercises.reduce(0) { $0 + $1.duration }
    }
}

// MARK: - MuscleGroup Identifiable
extension MuscleGroup: Identifiable {
    public var id: String { self.rawValue }
}

#Preview {
    NavigationView {
        TestMuscleGroupScreen()
    }
    .preferredColorScheme(.dark)
}
