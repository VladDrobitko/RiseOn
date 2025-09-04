//
//  TestMuscleGroupScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct TestMuscleGroupScreen: View {
    @StateObject private var exerciseService = ExerciseService.shared
    
    var body: some View {
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
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Workouts")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButton()
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(.typographyPrimary)
                }
            }
        }
    }
}

// MARK: - Components
extension TestMuscleGroupScreen {
    
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
                NavigationLink(destination: ExerciseListScreen(muscleGroup: muscleGroup)) {
                    MuscleGroupCard(
                        muscleGroup: muscleGroup,
                        exerciseCount: exerciseCountFor(muscleGroup),
                        estimatedTime: estimatedTimeFor(muscleGroup)
                    ) {
                        // NavigationLink handles the action
                    }
                }
                .buttonStyle(PlainButtonStyle())
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

// MARK: - Custom Back Button
struct CustomBackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: { dismiss() }) {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.typographyPrimary)
                
                Text("Back")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.typographyPrimary)
            }
        }
    }
}

#Preview {
    NavigationView {
        TestMuscleGroupScreen()
    }
    .preferredColorScheme(.dark)
}
