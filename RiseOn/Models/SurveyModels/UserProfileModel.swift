//
//  UserProfileModel.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 13/03/2025.
//

import Foundation
import SwiftData

@Model
final class UserProfileModel {
    // Базовая информация о пользователе
    var name: String
    var age: Int?
    var gender: String
    var height: Double?
    var weight: Double?
    var targetWeight: Double?
    
    // Цели и предпочтения
    var goal: String
    var level: String
    var diet: String
    var selectedUnit: String
    
    // Предпочтения тренировок (сохраняем как JSON строку)
    var preferredTrainingTypes: String
    
    // MARK: - Workout Days and Reminders (NEW)
    var selectedWorkoutDays: String  // JSON строка с днями тренировок
    var remindersEnabled: Bool
    var reminderTimeHour: Int        // Час напоминания (0-23)
    var reminderTimeMinute: Int      // Минута напоминания (0-59)
    
    // Дополнительные расчетные поля
    var bmi: Double?
    var weightDifference: Double?
    
    // Метаданные
    var createdAt: Date
    var updatedAt: Date
    
    // Инициализатор по умолчанию
    init(
        name: String = "",
        age: Int? = nil,
        gender: String = "",
        height: Double? = nil,
        weight: Double? = nil,
        targetWeight: Double? = nil,
        goal: String = "",
        level: String = "",
        diet: String = "",
        selectedUnit: String = "metric",
        preferredTrainingTypes: String = "[]",
        selectedWorkoutDays: String = "[]",
        remindersEnabled: Bool = false,
        reminderTimeHour: Int = 11,
        reminderTimeMinute: Int = 0
    ) {
        self.name = name
        self.age = age
        self.gender = gender
        self.height = height
        self.weight = weight
        self.targetWeight = targetWeight
        self.goal = goal
        self.level = level
        self.diet = diet
        self.selectedUnit = selectedUnit
        self.preferredTrainingTypes = preferredTrainingTypes
        self.selectedWorkoutDays = selectedWorkoutDays
        self.remindersEnabled = remindersEnabled
        self.reminderTimeHour = reminderTimeHour
        self.reminderTimeMinute = reminderTimeMinute
        
        // Вычисление BMI и разницы веса
        if let weight = weight, let height = height, height > 0 {
            let heightMeters = height / 100.0
            self.bmi = weight / (heightMeters * heightMeters)
        }
        
        if let currentWeight = weight, let goalWeight = targetWeight {
            self.weightDifference = currentWeight - goalWeight
        }
        
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // MARK: - Convenience Methods
    
    /// Получить дни тренировок как Set<WorkoutDay>
    var workoutDaysSet: Set<WorkoutDay> {
        get {
            return WorkoutDay.setFromJson(selectedWorkoutDays)
        }
        set {
            selectedWorkoutDays = WorkoutDay.setToJson(newValue)
        }
    }
    
    /// Получить предпочтения тренировок как Set<Prefer>
    var trainingPreferencesSet: Set<Prefer> {
        get {
            return Prefer.setFromJson(preferredTrainingTypes)
        }
        set {
            preferredTrainingTypes = Prefer.setToJson(newValue)
        }
    }
    
    /// Получить время напоминания как Date
    var reminderTime: Date {
        get {
            var components = DateComponents()
            components.hour = reminderTimeHour
            components.minute = reminderTimeMinute
            return Calendar.current.date(from: components) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            reminderTimeHour = components.hour ?? 11
            reminderTimeMinute = components.minute ?? 0
        }
    }
    
    /// Форматированное время напоминания
    var formattedReminderTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: reminderTime)
    }
    
    /// Форматированные дни тренировок
    var formattedWorkoutDays: String {
        let sortedDays = workoutDaysSet.sorted { day1, day2 in
            let order: [WorkoutDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
            guard let index1 = order.firstIndex(of: day1),
                  let index2 = order.firstIndex(of: day2) else { return false }
            return index1 < index2
        }
        
        if sortedDays.isEmpty {
            return "No workout days selected"
        }
        
        return sortedDays.map { $0.rawValue }.joined(separator: ", ")
    }
}
