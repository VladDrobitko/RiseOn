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
    
    // Сохранение данных из ViewModel в SwiftData
    func saveUserProfile(from viewModel: SurveyViewModel) {
        guard let context = modelContext else {
            print("ModelContext not initialized")
            return
        }
        
        // Проверяем, существует ли уже профиль
        let profile = fetchUserProfile() ?? UserProfileModel()
        
        // Обновляем профиль данными из ViewModel
        profile.name = viewModel.name
        profile.age = viewModel.age
        profile.gender = viewModel.gender?.rawValue ?? ""
        profile.height = viewModel.height
        profile.weight = viewModel.weight
        profile.targetWeight = viewModel.targetWeight
        profile.goal = viewModel.goal?.rawValue ?? ""
        profile.level = viewModel.level?.rawValue ?? ""
        profile.diet = viewModel.diet?.rawValue ?? ""
        profile.selectedUnit = viewModel.selectedUnit.rawValue
        
        // Преобразуем Set в JSON
        if let jsonData = try? JSONEncoder().encode(Array(viewModel.selectedTrainingTypes.map { $0.rawValue })),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            profile.preferredTrainingTypes = jsonString
        }
        
        // Пересчитываем BMI и weight difference
        if let weight = viewModel.weight, let height = viewModel.height, height > 0 {
            let heightMeters = height / 100.0
            profile.bmi = weight / (heightMeters * heightMeters)
        }
        
        if let currentWeight = viewModel.weight, let goalWeight = viewModel.targetWeight {
            profile.weightDifference = currentWeight - goalWeight
        }
        
        // Обновляем дату изменения
        profile.updatedAt = Date()
        
        // Сохраняем в контекст, если это новый профиль
        if fetchUserProfile() == nil {
            context.insert(profile)
        }
        
        // Сохраняем изменения
        do {
            try context.save()
            print("User profile saved successfully")
            
            // Оповещаем подписчиков об изменении
            profileSubject.send(profile)
            
            // Также сохраним флаг о завершении опроса в UserDefaults для быстрой проверки
            UserDefaults.standard.set(true, forKey: "isSurveyCompleted")
        } catch {
            print("Failed to save user profile: \(error)")
        }
    }
    
    // Загрузка профиля пользователя
    func fetchUserProfile() -> UserProfileModel? {
        guard let context = modelContext else {
            print("ModelContext not initialized")
            return nil
        }
        
        do {
            let descriptor = FetchDescriptor<UserProfileModel>(sortBy: [SortDescriptor(\.updatedAt, order: .reverse)])
            let profiles = try context.fetch(descriptor)
            return profiles.first
        } catch {
            print("Failed to fetch user profile: \(error)")
            return nil
        }
    }
    
    // Метод для заполнения ViewModel данными из сохраненного профиля
    func loadDataIntoViewModel(viewModel: SurveyViewModel) -> Bool {
        guard let profile = fetchUserProfile() else {
            return false
        }
        
        // Заполняем ViewModel
        viewModel.name = profile.name
        viewModel.age = profile.age
        
        // Восстанавливаем перечисления
        if let gender = Gender(rawValue: profile.gender) {
            viewModel.gender = gender
        }
        
        if let goal = Goal(rawValue: profile.goal) {
            viewModel.goal = goal
        }
        
        if let level = Level(rawValue: profile.level) {
            viewModel.level = level
        }
        
        if let diet = Diet(rawValue: profile.diet) {
            viewModel.diet = diet
        }
        
        // Восстанавливаем числовые значения
        viewModel.height = profile.height
        viewModel.weight = profile.weight
        viewModel.targetWeight = profile.targetWeight
        
        // Восстанавливаем единицы измерения
        if let unitType = SegmentedControl.UnitType(rawValue: profile.selectedUnit) {
            viewModel.selectedUnit = unitType
        }
        
        // Восстанавливаем предпочтения тренировок
        if let jsonData = profile.preferredTrainingTypes.data(using: String.Encoding.utf8),
           let preferStrings = try? JSONDecoder().decode([String].self, from: jsonData) {
            viewModel.selectedTrainingTypes = Set(preferStrings.compactMap { Prefer(rawValue: $0) })
        }
        
        return true
    }
    
    // Удаление профиля пользователя
    func deleteUserProfile() {
        guard let context = modelContext, let profile = fetchUserProfile() else {
            return
        }
        
        context.delete(profile)
        
        do {
            try context.save()
            print("User profile deleted successfully")
            
            // Оповещаем подписчиков об удалении
            profileSubject.send(nil)
            
            // Удаляем флаг опроса из UserDefaults
            UserDefaults.standard.removeObject(forKey: "isSurveyCompleted")
        } catch {
            print("Failed to delete user profile: \(error)")
        }
    }
    
    // Подготовка данных для машинного обучения
    func prepareDataForMLModel() -> [String: Any] {
        guard let profile = fetchUserProfile() else {
            return [:]
        }
        
        // Создаем вектор признаков для ML модели
        var features: [String: Any] = [:]
        
        // Базовые числовые параметры
        features["age"] = profile.age ?? 0
        features["height"] = profile.height ?? 0
        features["weight"] = profile.weight ?? 0
        features["targetWeight"] = profile.targetWeight ?? 0
        features["bmi"] = profile.bmi ?? 0
        features["weightDifference"] = profile.weightDifference ?? 0
        
        // Категориальные признаки
        features["gender_male"] = profile.gender == Gender.male.rawValue ? 1.0 : 0.0
        features["gender_female"] = profile.gender == Gender.female.rawValue ? 1.0 : 0.0
        
        // Кодируем цель
        for possibleGoal in Goal.allCases {
            features["goal_\(possibleGoal.rawValue)"] = profile.goal == possibleGoal.rawValue ? 1.0 : 0.0
        }
        
        // Кодируем уровень активности
        for possibleLevel in Level.allCases {
            features["level_\(possibleLevel.rawValue)"] = profile.level == possibleLevel.rawValue ? 1.0 : 0.0
        }
        
        // Кодируем диету
        for possibleDiet in Diet.allCases {
            features["diet_\(possibleDiet.rawValue)"] = profile.diet == possibleDiet.rawValue ? 1.0 : 0.0
        }
        
        // Предпочтения тренировок
        if let jsonData = profile.preferredTrainingTypes.data(using: .utf8),
           let preferStrings = try? JSONDecoder().decode([String].self, from: jsonData) {
            for possiblePrefer in Prefer.allCases {
                features["prefer_\(possiblePrefer.rawValue)"] = preferStrings.contains(possiblePrefer.rawValue) ? 1.0 : 0.0
            }
        }
        
        return features
    }
    
    // Проверка, завершил ли пользователь опрос
    func isSurveyCompleted() -> Bool {
        return fetchUserProfile() != nil
    }
}

// Расширение для SurveyViewModel для сохранения данных
extension SurveyViewModel {
    func saveResults() {
        UserDataService.shared.saveUserProfile(from: self)
    }
    
    func loadSavedData() -> Bool {
        return UserDataService.shared.loadDataIntoViewModel(viewModel: self)
    }
}
