//
//  MainPage.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 16/02/2025.
//

import SwiftUI

struct MainPage: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var exerciseService = ExerciseService.shared
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // Верхняя большая карточка (Marathon Start)
                topEventCard
                
                // Секция "The Best For You" с группами мышц
                bestForYouSection
                
                // Секция "Warm Ups" с двумя карточками в ряд
                warmUpsSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 100) // Отступ для tab bar
        }
        .background(Color.black.ignoresSafeArea(.all))
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Top Event Card (Marathon Start)
extension MainPage {
    private var topEventCard: some View {
        ZStack {
            // Фоновое изображение (пустая карточка пока)
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.2, green: 0.3, blue: 0.4),
                            Color(red: 0.1, green: 0.15, blue: 0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack {
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Marathon Start")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("09.04.2023-09.05.2023")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Кнопка "Join to us"
                    Button(action: {}) {
                        Text("Join to us")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.84, green: 0.95, blue: 0.35))
                            .cornerRadius(16)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .frame(height: 200)
    }
}

// MARK: - The Best For You Section (Muscle Groups)
extension MainPage {
    private var bestForYouSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Заголовок с кнопкой "All"
            HStack {
                Text("The Best For You")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: TestMuscleGroupScreen()) {
                    HStack(spacing: 4) {
                        Text("All")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.84, green: 0.95, blue: 0.35))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.84, green: 0.95, blue: 0.35))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Горизонтальный скролл карточек групп мышц
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(availableMuscleGroups, id: \.self) { muscleGroup in
                        NavigationLink(destination: ExerciseListScreen(muscleGroup: muscleGroup)) {
                            MuscleGroupWorkoutCard(
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
                .padding(.horizontal, 2)
            }
        }
    }
    
    // Helper methods
    private var availableMuscleGroups: [MuscleGroup] {
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

// MARK: - Warm Ups Section
extension MainPage {
    private var warmUpsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Заголовок с кнопкой "All"
            HStack {
                Text("Warm Ups")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("All")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.84, green: 0.95, blue: 0.35))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.84, green: 0.95, blue: 0.35))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Две карточки в ряд
            HStack(spacing: 12) {
                // Morning Warm Up
                WarmUpCard(
                    title: "Morning Warm Up",
                    difficulty: "Light",
                    duration: "15 min",
                    calories: "75 kCal",
                    imageName: "morning_warmup"
                )
                
                // Office Warm Up
                WarmUpCard(
                    title: "Office Warm up",
                    difficulty: "Medium",
                    duration: "13 min",
                    calories: "46 kCal",
                    imageName: "office_warmup"
                )
            }
        }
    }
}

// MARK: - Muscle Group Workout Card Component
struct MuscleGroupWorkoutCard: View {
    let muscleGroup: MuscleGroup
    let exerciseCount: Int
    let estimatedTime: Int
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background with gradient based on muscle group
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(muscleGroup.gradientColors)
                    .frame(width: 200, height: 180)
                
                // Placeholder icon
                VStack(spacing: 8) {
                    Image(systemName: muscleGroup.icon)
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(muscleGroup.displayName)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .overlay(
                // Gradient overlay for text readability
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        .clear,
                        .black.opacity(0.3),
                        .black.opacity(0.8)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(16)
            
            // Content overlay
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(muscleGroup.displayName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Stats
                HStack(spacing: 12) {
                    // Exercise count
                    Text("\(exerciseCount) exercises")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.2))
                        )
                    
                    // Duration and target
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(estimatedTime) min total")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("Build strength")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
            }
            .padding(16)
        }
        .frame(width: 200, height: 180)
    }
}

#Preview {
    NavigationView {
        MainPage()
            .environmentObject(AppState())
    }
    .preferredColorScheme(.dark)
}
