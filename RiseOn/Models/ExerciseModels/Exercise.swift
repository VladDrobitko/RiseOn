//
//  Exercise.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import Foundation
import SwiftUI

// MARK: - Exercise Model
struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let instructions: [String]
    let muscleGroup: MuscleGroup
    let difficulty: ExerciseDifficulty
    let duration: Int // в минутах
    let calories: Int // примерное количество калорий
    let equipment: [Equipment]
    let imageName: String // название файла изображения
    let videoName: String? // название видео файла (опционально)
    let resistanceIntensity: ResistanceIntensity
    let targetMuscles: [String] // конкретные мышцы
    let tips: [String] // полезные советы
    let variations: [String] // вариации упражнения
}

// MARK: - Muscle Group
enum MuscleGroup: String, CaseIterable, Codable {
    case chest = "chest"
    case back = "back"
    case shoulders = "shoulders"
    case arms = "arms"
    case legs = "legs"
    case glutes = "glutes"
    case core = "core"
    case fullBody = "fullBody"
    
    var displayName: String {
        switch self {
        case .chest: return "Chest"
        case .back: return "Back"
        case .shoulders: return "Shoulders"
        case .arms: return "Arms"
        case .legs: return "Legs"
        case .glutes: return "Glutes"
        case .core: return "Core"
        case .fullBody: return "Full Body"
        }
    }
    
    var icon: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.strengthtraining.functional"
        case .shoulders: return "figure.arms.open"
        case .arms: return "figure.strengthtraining.traditional"
        case .legs: return "figure.run"
        case .glutes: return "figure.strengthtraining.functional"
        case .core: return "figure.core.workout"
        case .fullBody: return "figure.mixed.cardio"
        }
    }
    
    var gradientColors: LinearGradient {
        let colors: [Color]
        
        switch self {
        case .chest:
            colors = [Color.red.opacity(0.4), Color.pink.opacity(0.2)]
        case .back:
            colors = [Color.blue.opacity(0.4), Color.cyan.opacity(0.2)]
        case .shoulders:
            colors = [Color.orange.opacity(0.4), Color.yellow.opacity(0.2)]
        case .arms:
            colors = [Color.purple.opacity(0.4), Color.indigo.opacity(0.2)]
        case .legs:
            colors = [Color.green.opacity(0.4), Color.mint.opacity(0.2)]
        case .glutes:
            colors = [Color.pink.opacity(0.4), Color.red.opacity(0.2)]
        case .core:
            colors = [Color.yellow.opacity(0.4), Color.orange.opacity(0.2)]
        case .fullBody:
            colors = [Color.primaryButton.opacity(0.4), Color.primaryButton.opacity(0.2)]
        }
        
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Exercise Difficulty
enum ExerciseDifficulty: String, CaseIterable, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    
    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
    
    var difficultyLevel: Int {
        switch self {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        }
    }
    
    var color: Color {
        switch self {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

// MARK: - Equipment
enum Equipment: String, CaseIterable, Codable {
    case dumbbells = "dumbbells"
    case barbell = "barbell"
    case bench = "bench"
    case cable_machine = "cable_machine"
    case resistance_bands = "resistance_bands"
    case kettlebell = "kettlebell"
    case pull_up_bar = "pull_up_bar"
    case exercise_ball = "exercise_ball"
    case yoga_mat = "yoga_mat"
    
    var displayName: String {
        switch self {
        case .dumbbells: return "Dumbbells"
        case .barbell: return "Barbell"
        case .bench: return "Bench"
        case .cable_machine: return "Cable Machine"
        case .resistance_bands: return "Resistance Bands"
        case .kettlebell: return "Kettlebell"
        case .pull_up_bar: return "Pull-up Bar"
        case .exercise_ball: return "Exercise Ball"
        case .yoga_mat: return "Yoga Mat"
        }
    }
    
    var icon: String {
        switch self {
        case .dumbbells: return "dumbbell"
        case .barbell: return "figure.strengthtraining.traditional"
        case .bench: return "rectangle"
        case .cable_machine: return "cable.connector"
        case .resistance_bands: return "oval"
        case .kettlebell: return "figure.strengthtraining.functional"
        case .pull_up_bar: return "rectangle.and.hand.point.up.left"
        case .exercise_ball: return "circle"
        case .yoga_mat: return "rectangle.portrait"
        }
    }
}

// MARK: - Resistance Intensity
enum ResistanceIntensity: String, CaseIterable, Codable {
    case light = "light"
    case medium = "medium"
    case high = "high"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    var color: Color {
        switch self {
        case .light: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var intensityLevel: Int {
        switch self {
        case .light: return 1
        case .medium: return 2
        case .high: return 3
        }
    }
}

// Убираем отдельное расширение - Identifiable теперь встроен в enum
