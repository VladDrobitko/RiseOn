//
//  EnumExtensions.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import Foundation

// MARK: - Safe Enum Conversion Extensions
extension Gender {
    /// Безопасная инициализация с fallback значением
    static func safeInit(from rawValue: String?) -> Gender {
        guard let rawValue = rawValue,
              let gender = Gender(rawValue: rawValue) else {
            return .male // Fallback значение
        }
        return gender
    }
}

extension Goal {
    /// Безопасная инициализация с fallback значением
    static func safeInit(from rawValue: String?) -> Goal {
        guard let rawValue = rawValue,
              let goal = Goal(rawValue: rawValue) else {
            return .buildMuscle // Fallback значение
        }
        return goal
    }
}

extension Level {
    /// Безопасная инициализация с fallback значением
    static func safeInit(from rawValue: String?) -> Level {
        guard let rawValue = rawValue,
              let level = Level(rawValue: rawValue) else {
            return .averageActivity // Fallback значение
        }
        return level
    }
}

extension Diet {
    /// Безопасная инициализация с fallback значением
    static func safeInit(from rawValue: String?) -> Diet {
        guard let rawValue = rawValue,
              let diet = Diet(rawValue: rawValue) else {
            return .noAnyDietes // Fallback значение
        }
        return diet
    }
}

extension WorkoutDay {
    /// Безопасная инициализация с fallback значением
    static func safeInit(from rawValue: String?) -> WorkoutDay? {
        guard let rawValue = rawValue else { return nil }
        return WorkoutDay(rawValue: rawValue)
    }
    
    /// Конвертация Set<WorkoutDay> в JSON строку
    static func setToJson(_ workoutDays: Set<WorkoutDay>) -> String {
        let array = Array(workoutDays.map { $0.rawValue })
        guard let jsonData = try? JSONEncoder().encode(array),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return "[]"
        }
        return jsonString
    }
    
    /// Конвертация JSON строки в Set<WorkoutDay>
    static func setFromJson(_ jsonString: String?) -> Set<WorkoutDay> {
        guard let jsonString = jsonString,
              let jsonData = jsonString.data(using: .utf8),
              let array = try? JSONDecoder().decode([String].self, from: jsonData) else {
            return []
        }
        
        let workoutDays = array.compactMap { WorkoutDay(rawValue: $0) }
        return Set(workoutDays)
    }
}

extension Prefer {
    /// Безопасная конвертация Set<Prefer> в JSON строку
    static func setToJson(_ preferences: Set<Prefer>) -> String {
        let array = Array(preferences.map { $0.rawValue })
        guard let jsonData = try? JSONEncoder().encode(array),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return "[]"
        }
        return jsonString
    }
    
    /// Безопасная конвертация JSON строки в Set<Prefer>
    static func setFromJson(_ jsonString: String?) -> Set<Prefer> {
        guard let jsonString = jsonString,
              let jsonData = jsonString.data(using: .utf8),
              let array = try? JSONDecoder().decode([String].self, from: jsonData) else {
            return []
        }
        
        let preferences = array.compactMap { Prefer(rawValue: $0) }
        return Set(preferences)
    }
}

extension SegmentedControl.UnitType {
    /// Безопасная инициализация с fallback значением
    static func safeInit(from rawValue: String?) -> SegmentedControl.UnitType {
        guard let rawValue = rawValue,
              let unitType = SegmentedControl.UnitType(rawValue: rawValue) else {
            return .metric // Fallback значение
        }
        return unitType
    }
}
