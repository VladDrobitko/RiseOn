//
//  AppState.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI
import SwiftData

/// Центральное состояние приложения - управляет только глобальными состояниями
class AppState: ObservableObject {
    // MARK: - Authentication State
    @Published var isAuthenticated: Bool = false
    @Published var isFirstLaunch: Bool = true
    
    // MARK: - App Flow State
    @Published var showAuthSheet: Bool = false
    @Published var isLoading: Bool = false
    
    // MARK: - User State
    @Published var hasCompletedSurvey: Bool = false
    
    // MARK: - SwiftData Context
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        loadAppState()
    }
    
    // MARK: - Public Methods
    
    /// Обновление ModelContext после инициализации
    func updateModelContext(_ context: ModelContext) {
        self.modelContext = context
        checkSurveyCompletion()
    }
    
    /// Пользователь успешно авторизовался
    func login() {
        // ИСПРАВЛЕНО: Сначала закрываем модальное окно, потом меняем состояние
        showAuthSheet = false
        
        // Небольшая задержка для плавного закрытия модального окна
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isAuthenticated")
            self.checkSurveyCompletion()
        }
    }
    
    /// Выход из аккаунта
    func logout() {
        isAuthenticated = false
        hasCompletedSurvey = false
        isFirstLaunch = false
        showAuthSheet = false
        
        UserDefaults.standard.removeObject(forKey: "isAuthenticated")
        UserDefaults.standard.removeObject(forKey: "hasCompletedSurvey")
    }
    
    /// Отметка о завершении первого запуска
    func markFirstLaunchCompleted() {
        isFirstLaunch = false
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    }
    
    /// Опрос завершен
    func markSurveyCompleted() {
        hasCompletedSurvey = true
        UserDefaults.standard.set(true, forKey: "hasCompletedSurvey")
    }
    
    /// Сброс всех данных приложения (для тестирования)
    func resetAppState() {
        isAuthenticated = false
        isFirstLaunch = true
        hasCompletedSurvey = false
        showAuthSheet = false
        
        // Очистка UserDefaults
        UserDefaults.standard.removeObject(forKey: "isAuthenticated")
        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
        UserDefaults.standard.removeObject(forKey: "hasCompletedSurvey")
        
        // Очистка SwiftData
        clearUserData()
    }
    
    // MARK: - Private Methods
    
    private func loadAppState() {
        isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        hasCompletedSurvey = UserDefaults.standard.bool(forKey: "hasCompletedSurvey")
        
        // Для тестирования можно временно включить
        // isFirstLaunch = true
    }
    
    private func checkSurveyCompletion() {
        guard let context = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<UserProfileModel>()
            let profiles = try context.fetch(descriptor)
            hasCompletedSurvey = !profiles.isEmpty
            
            if hasCompletedSurvey {
                UserDefaults.standard.set(true, forKey: "hasCompletedSurvey")
            }
        } catch {
            print("Ошибка проверки завершения опроса: \(error)")
        }
    }
    
    private func clearUserData() {
        guard let context = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<UserProfileModel>()
            let profiles = try context.fetch(descriptor)
            
            for profile in profiles {
                context.delete(profile)
            }
            
            try context.save()
            print("Данные пользователя очищены")
        } catch {
            print("Ошибка очистки данных: \(error)")
        }
    }
}

// MARK: - Environment Key для доступа к AppState
struct AppStateKey: EnvironmentKey {
    static let defaultValue = AppState()
}

extension EnvironmentValues {
    var appState: AppState {
        get { self[AppStateKey.self] }
        set { self[AppStateKey.self] = newValue }
    }
}
