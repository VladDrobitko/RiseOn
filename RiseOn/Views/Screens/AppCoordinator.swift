//
//  AppCoordinator.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI
import SwiftData

class AppCoordinator: ObservableObject {
    // Различные экраны в приложении
    enum AppScreen {
        case splash          // Сплэш-экран
        case welcome         // Экран приветствия
        case auth            // Авторизация
        case survey          // Опрос
        case main            // Главный экран
    }
    
    // Текущий экран
    @Published var currentScreen: AppScreen = .splash {
        didSet {
            print("Screen changed from \(oldValue) to \(currentScreen)")
        }
    }
    
    // Состояния пользователя
    @Published var isFirstLaunch: Bool = true
    @Published var isLoggedIn: Bool = false
    @Published var hasSurveyCompleted: Bool = false
    
    // Состояние для модальных окон
    @Published var showAuthSheet: Bool = false
    
    // Состояние для шага опроса
    @Published var currentSurveyStep: Int = 1
    
    // Доступ к SwiftData
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        // Сохраняем контекст
        self.modelContext = modelContext
        
        // Загружаем состояния
        self.isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        // Проверяем наличие профиля в SwiftData
        if let context = modelContext {
            do {
                let descriptor = FetchDescriptor<UserProfileModel>()
                let profiles = try context.fetch(descriptor)
                self.hasSurveyCompleted = !profiles.isEmpty
            } catch {
                print("Failed to fetch profiles: \(error)")
                self.hasSurveyCompleted = false
            }
        } else {
            self.hasSurveyCompleted = UserDefaults.standard.bool(forKey: "isSurveyCompleted")
        }
        
        print("AppCoordinator initialized with states - isFirstLaunch: \(isFirstLaunch), isLoggedIn: \(isLoggedIn), hasSurveyCompleted: \(hasSurveyCompleted)")
        
        // Определяем начальный экран
        determineInitialScreen()
    }
    
    // Метод для обновления ModelContext после инициализации
    func updateModelContext(_ context: ModelContext) {
        self.modelContext = context
        
        // Проверяем профили снова с новым контекстом
        do {
            let descriptor = FetchDescriptor<UserProfileModel>()
            let profiles = try context.fetch(descriptor)
            let hasProfiles = !profiles.isEmpty
            
            // Обновляем состояние только если оно отличается
            if hasProfiles != hasSurveyCompleted {
                print("Updating hasSurveyCompleted from \(hasSurveyCompleted) to \(hasProfiles) based on SwiftData")
                self.hasSurveyCompleted = hasProfiles
                
                // Обновляем экран, если находимся на сплэш-экране
                if currentScreen == .splash {
                    determineInitialScreen()
                }
            }
        } catch {
            print("Failed to fetch profiles with updated context: \(error)")
        }
    }
    
    private func determineInitialScreen() {
        // Всегда начинаем со сплэш-экрана для показа анимации логотипа
        currentScreen = .splash
        print("Initial screen set to splash")
    }
    
    // Переход к следующему экрану
    func navigateToNextScreen() {
        print("Navigating from \(currentScreen)")
        
        switch currentScreen {
        case .splash:
            // После сплэш-экрана переходим на нужный экран в зависимости от состояния
            if isFirstLaunch {
                print("Going to welcome screen (first launch)")
                currentScreen = .welcome
            } else if !isLoggedIn {
                print("Going to auth screen (not logged in)")
                currentScreen = .auth
            } else if !hasSurveyCompleted {
                print("Going to survey screen (survey not completed)")
                currentScreen = .survey
            } else {
                print("Going to main screen (all completed)")
                currentScreen = .main
            }
            
        case .welcome:
            // При нажатии кнопки на welcome screen открываем sheet авторизации
            print("Opening auth sheet from welcome screen")
            showAuthSheet = true
            
        case .auth:
            // После авторизации
            print("Completing auth flow")
            isLoggedIn = true
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            if !hasSurveyCompleted {
                print("Going to survey after auth")
                currentScreen = .survey
            } else {
                print("Going to main after auth")
                currentScreen = .main
            }
            
        case .survey:
            // После завершения опроса
            print("Completing survey flow")
            hasSurveyCompleted = true
            UserDefaults.standard.set(true, forKey: "isSurveyCompleted")
            currentScreen = .main
            
        case .main:
            // Уже на главном экране
            print("Already on main screen")
            break
        }
    }
    
    // После завершения опроса
    func completeSurvey() {
        print("Survey completed")
        hasSurveyCompleted = true
        UserDefaults.standard.set(true, forKey: "isSurveyCompleted")
        currentScreen = .main
    }
    
    // Метод для сохранения профиля пользователя
    func saveUserProfile(_ profile: UserProfileModel) {
        guard let context = modelContext else {
            print("Cannot save profile: modelContext is nil")
            return
        }
        
        context.insert(profile)
        
        do {
            try context.save()
            print("User profile saved successfully")
            hasSurveyCompleted = true
        } catch {
            print("Failed to save user profile: \(error)")
        }
    }
    
    // Отметка о первом запуске
    func markAppAsLaunched() {
        print("Marking app as launched")
        isFirstLaunch = false
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    }
    
    // Успешная авторизация
    func login() {
        print("User logged in")
        isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        showAuthSheet = false
        
        if !hasSurveyCompleted {
            print("Going to survey after login")
            currentScreen = .survey
        } else {
            print("Going to main after login")
            currentScreen = .main
        }
    }
    
    // Сброс состояния приложения
    func resetAppState() {
        print("Resetting app state")
        // Сбрасываем все состояния
        isFirstLaunch = true
        isLoggedIn = false
        hasSurveyCompleted = false
        currentSurveyStep = 1
        
        // Очищаем UserDefaults
        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "isSurveyCompleted")
        
        // Удаляем данные из SwiftData
        if let context = modelContext {
            do {
                let descriptor = FetchDescriptor<UserProfileModel>()
                let profiles = try context.fetch(descriptor)
                
                for profile in profiles {
                    context.delete(profile)
                }
                
                try context.save()
                print("All SwiftData profiles deleted")
            } catch {
                print("Failed to delete profiles: \(error)")
            }
        }
        
        // Переходим к начальному экрану
        currentScreen = .splash
    }
}
