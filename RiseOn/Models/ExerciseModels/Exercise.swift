//
//  Exercise.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import Foundation

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
    
    var color: String {
        switch self {
        case .chest: return "blue"
        case .back: return "green"
        case .shoulders: return "orange"
        case .arms: return "red"
        case .legs: return "purple"
        case .glutes: return "pink"
        case .core: return "yellow"
        case .fullBody: return "cyan"
        }
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
    
    var color: String {
        switch self {
        case .beginner: return "green"
        case .intermediate: return "orange"
        case .advanced: return "red"
        }
    }
}

// MARK: - Equipment
enum Equipment: String, CaseIterable, Codable {
    case none = "none"
    case dumbbells = "dumbbells"
    case barbell = "barbell"
    case kettlebell = "kettlebell"
    case resistanceBand = "resistanceBand"
    case pullupBar = "pullupBar"
    case bench = "bench"
    case mat = "mat"
    
    var displayName: String {
        switch self {
        case .none: return "No Equipment"
        case .dumbbells: return "Dumbbells"
        case .barbell: return "Barbell"
        case .kettlebell: return "Kettlebell"
        case .resistanceBand: return "Resistance Band"
        case .pullupBar: return "Pull-up Bar"
        case .bench: return "Bench"
        case .mat: return "Exercise Mat"
        }
    }
    
    var icon: String {
        switch self {
        case .none: return "checkmark.circle"
        case .dumbbells: return "dumbbell"
        case .barbell: return "figure.strengthtraining.traditional"
        case .kettlebell: return "figure.strengthtraining.functional"
        case .resistanceBand: return "oval.portrait"
        case .pullupBar: return "figure.pull.ups"
        case .bench: return "rectangle"
        case .mat: return "square"
        }
    }
}

// MARK: - Resistance Intensity
enum ResistanceIntensity: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "orange"
        case .high: return "red"
        }
    }
    
    // Возвращает количество заполненных индикаторов (из 3)
    var intensityLevel: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        }
    }
}
