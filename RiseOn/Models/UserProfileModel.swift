//
//  UserProfile.swift
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
        preferredTrainingTypes: String = "[]"
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
}
