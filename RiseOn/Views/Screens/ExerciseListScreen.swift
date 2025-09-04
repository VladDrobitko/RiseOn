//
//  ExerciseListScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct ExerciseListScreen: View {
    let muscleGroup: MuscleGroup
    @StateObject private var exerciseService = ExerciseService.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingExerciseDetail: Exercise?
    
    private var filteredExercises: [Exercise] {
        exerciseService.getExercises(for: muscleGroup)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            navigationBar
            
            // Content
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: DesignTokens.Spacing.md) {
                    // Header section
                    headerSection
                    
                    // Exercise list
                    exerciseList
                }
                .padding(.horizontal, DesignTokens.Padding.screen)
                .padding(.bottom, 100)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(item: $showingExerciseDetail) { exercise in
            ExerciseDetailScreen(exercise: exercise)
        }
    }
}

// MARK: - Components
extension ExerciseListScreen {
    
    private var navigationBar: some View {
        ZStack {
            // Заголовок по центру экрана
            Text("\(muscleGroup.displayName) Exercises")
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
                
                // Кнопка фильтров справа
                Button(action: {}) {
                    Image(systemName: "slider.horizontal.3")
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
            // Muscle group info
            HStack(spacing: DesignTokens.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.primaryButton.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: muscleGroup.icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.primaryButton)
                }
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(muscleGroup.displayName)
                        .riseOnHeading2()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Strengthen and build your \(muscleGroup.displayName.lowercased()) muscles")
                        .riseOnBody()
                        .foregroundColor(.typographyGrey)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            // Stats row
            HStack(spacing: DesignTokens.Spacing.lg) {
                StatChip(
                    icon: "list.bullet",
                    text: "\(filteredExercises.count) exercises",
                    color: .primaryButton
                )
                
                StatChip(
                    icon: "clock",
                    text: "\(totalEstimatedTime) min total",
                    color: .primaryButton
                )
                
                Spacer()
            }
        }
        .padding(.top, DesignTokens.Spacing.lg)
    }
    
    private var exerciseList: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            // Section header
            HStack {
                Text("All Exercises")
                    .riseOnHeading3()
                    .foregroundColor(.typographyPrimary)
                
                Spacer()
                
                Text("\(filteredExercises.count) exercises")
                    .riseOnCaption()
                    .foregroundColor(.typographyGrey)
            }
            .padding(.top, DesignTokens.Spacing.lg)
            
            // Exercise cards
            ForEach(filteredExercises) { exercise in
                ExerciseListCard(exercise: exercise) {
                    showingExerciseDetail = exercise
                }
            }
        }
    }
    
    private var totalEstimatedTime: Int {
        filteredExercises.reduce(0) { $0 + $1.duration }
    }
}

#Preview {
    NavigationView {
        ExerciseListScreen(muscleGroup: .legs)
    }
    .preferredColorScheme(.dark)
}
