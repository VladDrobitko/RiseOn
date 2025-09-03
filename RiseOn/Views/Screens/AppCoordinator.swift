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
    
    // Состояние для модальных окон
    @Published var showAuthSheet: Bool = false
    
    // Доступ к SwiftData
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        // Сохраняем контекст
        self.modelContext = modelContext
        
        // Загружаем состояния
        self.isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        print("AppCoordinator initialized with states - isFirstLaunch: \(isFirstLaunch), isLoggedIn: \(isLoggedIn)")
        
        // Определяем начальный экран
        determineInitialScreen()
    }
    
    // Метод для обновления ModelContext после инициализации
    func updateModelContext(_ context: ModelContext) {
        self.modelContext = context
        print("ModelContext updated")
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
            // После сплэша всегда показываем Welcome экран
            print("Going to welcome screen")
            currentScreen = .welcome
            
        case .welcome:
            // Welcome экран сам решает когда показать авторизацию через showAuthSheet
            print("Welcome screen handles auth flow")
            
        case .auth:
            // После авторизации сразу переходим к основному приложению
            print("Completing auth flow")
            isLoggedIn = true
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            currentScreen = .main
            
        case .main:
            // Уже на главном экране
            print("Already on main screen")
            break
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
        showAuthSheet = false // Закрываем sheet
        currentScreen = .main
    }
    
    // Сброс состояния приложения
    func resetAppState() {
        print("Resetting app state")
        // Сбрасываем все состояния
        isFirstLaunch = true
        isLoggedIn = false
        
        // Очищаем UserDefaults
        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        
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
