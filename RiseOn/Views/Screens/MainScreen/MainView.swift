//
//  MainView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 05/02/2025.
//

import SwiftUI
import Combine

struct MainView: View {
    // Используем @StateObject для глобального состояния, доступного всем вкладкам
    @StateObject private var viewModel = MainViewModel()
    
    // Сохраняем выбранную вкладку для оптимизации перерисовок
    @State private var selectedTab = 0
    
    var body: some View {
            
            TabView(selection: $selectedTab) {
                // Главная страница
                MainPage()
                    .environmentObject(viewModel)
                    .tag(0)
                    .tabItem {
                        Image("main")
                            .renderingMode(.template)
                        Text("Main")
                    }
                
                // Тренировки
                WorkoutPage()
                    .environmentObject(viewModel)
                    .tag(1)
                    .tabItem {
                        Image("workout")
                            .renderingMode(.template)
                        Text("Workout")
                    }
                
                // Питание
                NutritionPage()
                    .environmentObject(viewModel)
                    .tag(2)
                    .tabItem {
                        Image("nutrition")
                            .renderingMode(.template)
                        Text("Nutrition")
                    }
                
                // Прогресс
                ProgressPage()
                    .environmentObject(viewModel)
                    .tag(3)
                    .tabItem {
                        Image("stats")
                            .renderingMode(.template)
                        Text("Progress")
                    }
            }
            .accentColor(Color("PrimaryColor")) // Цвет выбранной вкладки
            .onAppear {
                // Настройка внешнего вида TabView
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = .black
                
                // Увеличиваем размер иконок и текста
                let iconConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
                
                // Настройка размера для невыбранных элементов
                appearance.stackedLayoutAppearance.normal.iconColor = UIColor.lightGray
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray
                ]
                
                // Настройка размера для выбранных элементов
                appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.primaryButton)
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular),
                    NSAttributedString.Key.foregroundColor: UIColor(Color.primaryButton)
                ]
                
                // Увеличиваем отступы для большего пространства
                appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
                appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
                
                // Применяем настройки
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
                
                // Дополнительно: увеличиваем общую высоту TabBar
                UITabBar.appearance().itemPositioning = .centered
                UITabBar.appearance().itemSpacing = 16
                
                // Инициализация данных
                viewModel.initializeData()
            }
            
        }
        
    }

// ViewModel с использованием Combine для обработки данных
class MainViewModel: ObservableObject {
    // Используем @Published свойства для автоматического обновления UI
    @Published var userProfile: UserProfile?
    @Published var workoutData: [WorkoutEntry] = []
    @Published var nutritionData: [NutritionEntry] = []
    @Published var progressData: [ProgressEntry] = []
    
    // Отслеживаем подписки для управления памятью
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Настройка обработчиков событий и подписок
        setupSubscriptions()
    }
    
    func initializeData() {
        // Загрузка данных из локального хранилища или API
        loadUserProfile()
        loadWorkoutData()
        loadNutritionData()
        loadProgressData()
    }
    
    private func setupSubscriptions() {
        // Пример подписки на изменения данных профиля пользователя
        $userProfile
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] profile in
                guard let self = self, let profile = profile else { return }
                self.saveUserProfile(profile)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Методы загрузки данных
    
    private func loadUserProfile() {
        // Имитация загрузки данных профиля
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.userProfile = UserProfile(name: "Пользователь", age: 30, weight: 75, height: 180)
        }
    }
    
    private func loadWorkoutData() {
        // Загрузка данных о тренировках
    }
    
    private func loadNutritionData() {
        // Загрузка данных о питании
    }
    
    private func loadProgressData() {
        // Загрузка данных о прогрессе
    }
    
    // MARK: - Методы сохранения данных
    
    private func saveUserProfile(_ profile: UserProfile) {
        // Сохранение данных профиля
    }
}

// MARK: - Модели данных (остаются без изменений)

struct UserProfile {
    var name: String
    var age: Int
    var weight: Double
    var height: Double
}

struct WorkoutEntry {
    var id = UUID()
    var date: Date
    var name: String
    var duration: TimeInterval
    var caloriesBurned: Double
}

struct NutritionEntry {
    var id = UUID()
    var date: Date
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
}

struct ProgressEntry {
    var id = UUID()
    var date: Date
    var weight: Double
    var bodyFatPercentage: Double?
}

// MARK: - Предварительный просмотр
#Preview {
    MainView()
}
