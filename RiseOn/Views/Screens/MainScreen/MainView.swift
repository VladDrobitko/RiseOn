//
//  MainView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 05/02/2025.
//

import SwiftUI
import Combine

struct MainView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var tabCoordinator: TabCoordinator
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            // Основной контент в зависимости от выбранной вкладки
            Group {
                switch tabCoordinator.selectedTab {
                case 0:
                    MainPage()
                        .environmentObject(viewModel)
                        .environmentObject(coordinator)
                case 1:
                    WorkoutPage()
                        .environmentObject(viewModel)
                        .environmentObject(coordinator)
                case 2:
                    NutritionPage()
                        .environmentObject(viewModel)
                        .environmentObject(coordinator)
                case 3:
                    ProgressPage()
                        .environmentObject(viewModel)
                        .environmentObject(coordinator)
                default:
                    MainPage()
                        .environmentObject(viewModel)
                        .environmentObject(coordinator)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: tabCoordinator.selectedTab)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.initializeData()
        }
        .onReceive(coordinator.$currentScreen) { screen in
            // Сбрасываем выбранную вкладку при изменении экрана
            if screen == .main {
                tabCoordinator.switchToTab(0)
            }
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
        .environmentObject(AppCoordinator())
        .environmentObject(TabCoordinator())
        .preferredColorScheme(.dark)
}
