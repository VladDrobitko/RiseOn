//
//  UserDataService.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 13/03/2025.
//

import Foundation
import SwiftData
import Combine

// Класс для работы с данными пользователя
class UserDataService {
    // Синглтон для доступа к сервису
    static let shared = UserDataService()
    
    // SwiftData ModelContainer и ModelContext
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?
    
    // Publisher для отслеживания изменений в профиле
    private let profileSubject = PassthroughSubject<UserProfileModel?, Never>()
    var profilePublisher: AnyPublisher<UserProfileModel?, Never> {
        profileSubject.eraseToAnyPublisher()
    }
    
    private init() {
        setupContainer()
    }
    
    // Настройка контейнера SwiftData
    private func setupContainer() {
        do {
            let schema = Schema([UserProfileModel.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            if let container = modelContainer {
                modelContext = ModelContext(container)
            }
            
            print("SwiftData container initialized successfully")
        } catch {
            print("Failed to initialize SwiftData container: \(error)")
        }
    }
    
    // MARK: - Сохранение данных из ViewModel в SwiftData
    func saveUserProfile(from viewModel: SurveyViewModel) {
        guard let context = modelContext else {
            print("ModelContext not initialized")
            return
        }
        
        let profile = fetchUserProfile() ?? UserProfileModel()
        
        // Сохраняем базовую информацию
        saveBasicInfo(to: profile, from: viewModel)
        
        // Сохраняем предпочтения
        savePreferences(to: profile, from: viewModel)
        
        // Сохраняем дни тренировок (если поддерживается)
        saveWorkoutData(to: profile, from: viewModel)
        
        // Вычисляем дополнительные поля
        calculateDerivedFields(for: profile, from: viewModel)
        
        // Обновляем дату изменения
        profile.updatedAt = Date()
        
        // Сохраняем в контекст, если это новый профиль
        if fetchUserProfile() == nil {
            context.insert(profile)
        }
        
        // Сохраняем изменения
        saveProfileToContext(profile, context: context)
    }
    
    private func saveBasicInfo(to profile: UserProfileModel, from viewModel: SurveyViewModel) {
        profile.name = viewModel.name
        profile.age = viewModel.age
        profile.height = viewModel.height
        profile.weight = viewModel.weight
        profile.targetWeight = viewModel.targetWeight
        
        // Безопасная конвертация enum'ов
        if let gender = viewModel.gender {
            profile.gender = gender.rawValue
        } else {
            profile.gender = Gender.safeInit(from: nil).rawValue
        }
    }
    
    private func savePreferences(to profile: UserProfileModel, from viewModel: SurveyViewModel) {
        // Сохраняем цель
        if let goal = viewModel.goal {
            profile.goal = goal.rawValue
        } else {
            profile.goal = Goal.safeInit(from: nil).rawValue
        }
        
        // Сохраняем уровень
        if let level = viewModel.level {
            profile.level = level.rawValue
        } else {
            profile.level = Level.safeInit(from: nil).rawValue
        }
        
        // Сохраняем диету
        if let diet = viewModel.diet {
            profile.diet = diet.rawValue
        } else {
            profile.diet = Diet.safeInit(from: nil).rawValue
        }
        
        profile.selectedUnit = viewModel.selectedUnit.rawValue
        profile.preferredTrainingTypes = Prefer.setToJson(viewModel.selectedTrainingTypes)
    }
    
    private func saveWorkoutData(to profile: UserProfileModel, from viewModel: SurveyViewModel) {
        if hasWorkoutDaysSupport(viewModel: viewModel) {
            profile.selectedWorkoutDays = WorkoutDay.setToJson(viewModel.selectedWorkoutDays)
            profile.remindersEnabled = viewModel.remindersEnabled
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: viewModel.reminderTime)
            profile.reminderTimeHour = components.hour ?? 11
            profile.reminderTimeMinute = components.minute ?? 0
        } else {
            profile.selectedWorkoutDays = "[]"
            profile.remindersEnabled = false
            profile.reminderTimeHour = 11
            profile.reminderTimeMinute = 0
        }
    }
    
    private func calculateDerivedFields(for profile: UserProfileModel, from viewModel: SurveyViewModel) {
        // Вычисляем BMI
        if let weight = viewModel.weight, let height = viewModel.height, height > 0 {
            let heightMeters = height / 100.0
            profile.bmi = weight / (heightMeters * heightMeters)
        }
        
        // Вычисляем разницу веса
        if let currentWeight = viewModel.weight, let goalWeight = viewModel.targetWeight {
            profile.weightDifference = currentWeight - goalWeight
        }
    }
    
    private func saveProfileToContext(_ profile: UserProfileModel, context: ModelContext) {
        do {
            try context.save()
            print("User profile saved successfully")
            profileSubject.send(profile)
            UserDefaults.standard.set(true, forKey: "isSurveyCompleted")
        } catch {
            print("Failed to save user profile: \(error)")
        }
    }
    
    // MARK: - Загрузка профиля пользователя
    func fetchUserProfile() -> UserProfileModel? {
        guard let context = modelContext else {
            print("ModelContext not initialized")
            return nil
        }
        
        do {
            let descriptor = FetchDescriptor<UserProfileModel>(
                sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
            )
            let profiles = try context.fetch(descriptor)
            return profiles.first
        } catch {
            print("Failed to fetch user profile: \(error)")
            return nil
        }
    }
    
    // MARK: - Метод для заполнения ViewModel данными из сохраненного профиля
    func loadDataIntoViewModel(viewModel: SurveyViewModel) -> Bool {
        guard let profile = fetchUserProfile() else {
            return false
        }
        
        // Загружаем базовую информацию
        loadBasicInfo(into: viewModel, from: profile)
        
        // Загружаем предпочтения
        loadPreferences(into: viewModel, from: profile)
        
        // Загружаем дни тренировок (если поддерживается)
        loadWorkoutData(into: viewModel, from: profile)
        
        return true
    }
    
    private func loadBasicInfo(into viewModel: SurveyViewModel, from profile: UserProfileModel) {
        viewModel.name = profile.name
        viewModel.age = profile.age
        viewModel.height = profile.height
        viewModel.weight = profile.weight
        viewModel.targetWeight = profile.targetWeight
        
        viewModel.gender = Gender.safeInit(from: profile.gender)
    }
    
    private func loadPreferences(into viewModel: SurveyViewModel, from profile: UserProfileModel) {
        viewModel.goal = Goal.safeInit(from: profile.goal)
        viewModel.level = Level.safeInit(from: profile.level)
        viewModel.diet = Diet.safeInit(from: profile.diet)
        viewModel.selectedUnit = SegmentedControl.UnitType.safeInit(from: profile.selectedUnit)
        viewModel.selectedTrainingTypes = Prefer.setFromJson(profile.preferredTrainingTypes)
    }
    
    private func loadWorkoutData(into viewModel: SurveyViewModel, from profile: UserProfileModel) {
        if hasWorkoutDaysSupport(viewModel: viewModel) {
            viewModel.selectedWorkoutDays = WorkoutDay.setFromJson(profile.selectedWorkoutDays)
            viewModel.remindersEnabled = profile.remindersEnabled
            
            var components = DateComponents()
            components.hour = profile.reminderTimeHour
            components.minute = profile.reminderTimeMinute
            
            if let reminderTime = Calendar.current.date(from: components) {
                viewModel.reminderTime = reminderTime
            }
        }
    }
    
    // MARK: - Удаление профиля пользователя
    func deleteUserProfile() {
        guard let context = modelContext, let profile = fetchUserProfile() else {
            return
        }
        
        context.delete(profile)
        
        do {
            try context.save()
            print("User profile deleted successfully")
            profileSubject.send(nil)
            UserDefaults.standard.removeObject(forKey: "isSurveyCompleted")
        } catch {
            print("Failed to delete user profile: \(error)")
        }
    }
    
    // MARK: - Подготовка данных для машинного обучения
    func prepareDataForMLModel() -> [String: Any] {
        guard let profile = fetchUserProfile() else {
            return [:]
        }
        
        var features: [String: Any] = [:]
        
        // Добавляем базовые признаки
        addBasicFeatures(to: &features, from: profile)
        
        // Добавляем категориальные признаки
        addCategoricalFeatures(to: &features, from: profile)
        
        // Добавляем признаки тренировок
        addWorkoutFeatures(to: &features, from: profile)
        
        return features
    }
    
    private func addBasicFeatures(to features: inout [String: Any], from profile: UserProfileModel) {
        features["age"] = profile.age ?? 0
        features["height"] = profile.height ?? 0
        features["weight"] = profile.weight ?? 0
        features["targetWeight"] = profile.targetWeight ?? 0
        features["bmi"] = profile.bmi ?? 0
        features["weightDifference"] = profile.weightDifference ?? 0
    }
    
    private func addCategoricalFeatures(to features: inout [String: Any], from profile: UserProfileModel) {
        // Пол
        features["gender_male"] = profile.gender == Gender.male.rawValue ? 1.0 : 0.0
        features["gender_female"] = profile.gender == Gender.female.rawValue ? 1.0 : 0.0
        
        // Цель
        for goal in Goal.allCases {
            let key = "goal_\(goal.rawValue.replacingOccurrences(of: " ", with: "_"))"
            features[key] = profile.goal == goal.rawValue ? 1.0 : 0.0
        }
        
        // Уровень активности
        for level in Level.allCases {
            let key = "level_\(level.rawValue.replacingOccurrences(of: " ", with: "_"))"
            features[key] = profile.level == level.rawValue ? 1.0 : 0.0
        }
        
        // Диета
        for diet in Diet.allCases {
            let key = "diet_\(diet.rawValue.replacingOccurrences(of: " ", with: "_"))"
            features[key] = profile.diet == diet.rawValue ? 1.0 : 0.0
        }
    }
    
    private func addWorkoutFeatures(to features: inout [String: Any], from profile: UserProfileModel) {
        // Предпочтения тренировок
        let trainingPreferences = Prefer.setFromJson(profile.preferredTrainingTypes)
        for prefer in Prefer.allCases {
            let key = "prefer_\(prefer.rawValue)"
            features[key] = trainingPreferences.contains(prefer) ? 1.0 : 0.0
        }
        
        // Дни тренировок
        let workoutDays = WorkoutDay.setFromJson(profile.selectedWorkoutDays)
        for day in WorkoutDay.allCases {
            let key = "workout_\(day.rawValue)"
            features[key] = workoutDays.contains(day) ? 1.0 : 0.0
        }
        
        // Дополнительные признаки
        features["workoutDaysCount"] = Double(workoutDays.count)
        features["remindersEnabled"] = profile.remindersEnabled ? 1.0 : 0.0
        features["reminderHour"] = Double(profile.reminderTimeHour)
        features["reminderMinute"] = Double(profile.reminderTimeMinute)
    }
    
    // MARK: - Проверка, завершил ли пользователь опрос
    func isSurveyCompleted() -> Bool {
        return fetchUserProfile() != nil
    }
    
    // MARK: - Получение статистики пользователя
    func getUserStats() -> [String: Any] {
        guard let profile = fetchUserProfile() else {
            return [:]
        }
        
        var stats: [String: Any] = [:]
        
        // Основная информация
        stats["name"] = profile.name
        stats["age"] = profile.age ?? 0
        stats["bmi"] = profile.bmi ?? 0
        stats["goalWeight"] = profile.targetWeight ?? 0
        stats["currentWeight"] = profile.weight ?? 0
        stats["weightToLose"] = profile.weightDifference ?? 0
        
        // Тренировочная информация
        let workoutDays = WorkoutDay.setFromJson(profile.selectedWorkoutDays)
        stats["workoutDaysPerWeek"] = workoutDays.count
        stats["workoutDays"] = formatWorkoutDays(workoutDays)
        stats["remindersEnabled"] = profile.remindersEnabled
        stats["reminderTime"] = formatReminderTime(profile)
        
        // Предпочтения
        let preferences = Prefer.setFromJson(profile.preferredTrainingTypes)
        stats["trainingPreferences"] = preferences.map { $0.rawValue }
        stats["goal"] = profile.goal
        stats["level"] = profile.level
        stats["diet"] = profile.diet
        
        return stats
    }
    
    private func formatWorkoutDays(_ workoutDays: Set<WorkoutDay>) -> String {
        if workoutDays.isEmpty {
            return "No workout days selected"
        }
        
        let dayOrder: [WorkoutDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        let sortedDays = workoutDays.sorted { day1, day2 in
            guard let index1 = dayOrder.firstIndex(of: day1),
                  let index2 = dayOrder.firstIndex(of: day2) else { return false }
            return index1 < index2
        }
        
        return sortedDays.map { $0.rawValue }.joined(separator: ", ")
    }
    
    private func formatReminderTime(_ profile: UserProfileModel) -> String {
        var components = DateComponents()
        components.hour = profile.reminderTimeHour
        components.minute = profile.reminderTimeMinute
        
        guard let date = Calendar.current.date(from: components) else {
            return "11:00 AM"
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // MARK: - Экспорт данных пользователя
    func exportUserData() -> Data? {
        guard let profile = fetchUserProfile() else {
            return nil
        }
        
        let profileData = createProfileDictionary(from: profile)
        let exportData = createExportDictionary(with: profileData)
        
        do {
            return try JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
        } catch {
            print("Failed to export user data: \(error)")
            return nil
        }
    }
    
    private func createProfileDictionary(from profile: UserProfileModel) -> [String: Any] {
        return [
            "name": profile.name,
            "age": profile.age ?? 0,
            "gender": profile.gender,
            "height": profile.height ?? 0,
            "weight": profile.weight ?? 0,
            "targetWeight": profile.targetWeight ?? 0,
            "goal": profile.goal,
            "level": profile.level,
            "diet": profile.diet,
            "selectedUnit": profile.selectedUnit,
            "bmi": profile.bmi ?? 0,
            "weightDifference": profile.weightDifference ?? 0,
            "workoutDays": profile.selectedWorkoutDays,
            "remindersEnabled": profile.remindersEnabled,
            "reminderHour": profile.reminderTimeHour,
            "reminderMinute": profile.reminderTimeMinute,
            "trainingPreferences": profile.preferredTrainingTypes,
            "createdAt": ISO8601DateFormatter().string(from: profile.createdAt),
            "updatedAt": ISO8601DateFormatter().string(from: profile.updatedAt)
        ]
    }
    
    private func createExportDictionary(with profileData: [String: Any]) -> [String: Any] {
        return [
            "exportDate": ISO8601DateFormatter().string(from: Date()),
            "profile": profileData
        ]
    }
    
    // MARK: - Вспомогательные методы
    
    /// Проверяет, поддерживает ли ViewModel дни тренировок
    private func hasWorkoutDaysSupport(viewModel: SurveyViewModel) -> Bool {
        let mirror = Mirror(reflecting: viewModel)
        let propertyNames = mirror.children.compactMap { $0.label }
        
        let hasWorkoutDays = propertyNames.contains("selectedWorkoutDays")
        let hasReminders = propertyNames.contains("remindersEnabled")
        let hasReminderTime = propertyNames.contains("reminderTime")
        
        return hasWorkoutDays && hasReminders && hasReminderTime
    }
    
    /// Валидация данных профиля
    func validateProfile(_ profile: UserProfileModel) -> [String] {
        var errors: [String] = []
        
        if profile.name.isEmpty {
            errors.append("Name is required")
        }
        
        if let age = profile.age, age < 16 || age > 100 {
            errors.append("Age must be between 16 and 100")
        }
        
        if let weight = profile.weight, weight < 30 || weight > 300 {
            errors.append("Weight must be between 30 and 300 kg")
        }
        
        if let height = profile.height, height < 100 || height > 250 {
            errors.append("Height must be between 100 and 250 cm")
        }
        
        return errors
    }
    
    /// Получение прогресса опроса (0.0 - 1.0)
    func getSurveyProgress() -> Double {
        guard let profile = fetchUserProfile() else {
            return 0.0
        }
        
        var completedSteps = 0
        let totalSteps = 8
        
        // Проверяем каждый шаг опроса
        if !profile.name.isEmpty { completedSteps += 1 }
        if profile.age != nil { completedSteps += 1 }
        if !profile.gender.isEmpty { completedSteps += 1 }
        if !profile.goal.isEmpty { completedSteps += 1 }
        if profile.height != nil && profile.weight != nil { completedSteps += 1 }
        if !profile.level.isEmpty { completedSteps += 1 }
        if !profile.diet.isEmpty { completedSteps += 1 }
        
        let workoutDays = WorkoutDay.setFromJson(profile.selectedWorkoutDays)
        if !workoutDays.isEmpty { completedSteps += 1 }
        
        return Double(completedSteps) / Double(totalSteps)
    }
}

// MARK: - Расширение для SurveyViewModel для сохранения данных
extension SurveyViewModel {
    func saveResults() {
        UserDataService.shared.saveUserProfile(from: self)
    }
    
    func loadSavedData() -> Bool {
        return UserDataService.shared.loadDataIntoViewModel(viewModel: self)
    }
    
    func getSurveyProgress() -> Double {
        return UserDataService.shared.getSurveyProgress()
    }
}
