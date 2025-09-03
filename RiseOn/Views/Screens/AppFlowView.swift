//
//  AppFlowView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI
import SwiftData

// MARK: - Tab Coordinator
class TabCoordinator: ObservableObject {
    @Published var selectedTab: Int = 0
    
    func switchToTab(_ tab: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedTab = tab
        }
    }
}

struct MainContainer: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var coordinator: AppCoordinator
    @StateObject private var tabCoordinator = TabCoordinator()
    
    init() {
        _coordinator = StateObject(wrappedValue: AppCoordinator())
    }
    
    var body: some View {
        ZStack {
            // Основной контейнер с тремя зонами
            VStack(spacing: 0) {
                // 1. Верхний кастомный бар (динамический)
                DynamicTopBar()
                    .environmentObject(coordinator)
                    .environmentObject(tabCoordinator)
                
                // 2. Область контента (динамически загружаемая)
                ContentArea()
                    .environmentObject(coordinator)
                    .environmentObject(tabCoordinator)
                
                // 3. Нижний бар вкладок (контекстуальный)
                if shouldShowBottomBar {
                    BottomTabBar()
                        .environmentObject(coordinator)
                        .environmentObject(tabCoordinator)
                }
            }
        }
        .sheet(isPresented: $coordinator.showAuthSheet) {
            AuthView()
                .environmentObject(coordinator)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.clear)
        }
        .onAppear {
            DispatchQueue.main.async {
                coordinator.updateModelContext(modelContext)
            }
        }
    }
    
    // Определяем, когда показывать нижний бар
    private var shouldShowBottomBar: Bool {
        switch coordinator.currentScreen {
        case .splash, .welcome, .auth:
            return false
        case .main:
            return true
        }
    }
}

// MARK: - Content Area
struct ContentArea: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var tabCoordinator: TabCoordinator
    
    var body: some View {
        ZStack {
            // Выбираем текущий контент на основе состояния координатора
            switch coordinator.currentScreen {
            case .splash:
                SplashScreenView()
                    .environmentObject(coordinator)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            coordinator.navigateToNextScreen()
                        }
                    }
                
            case .welcome:
                StartScreenView()
                    .environmentObject(coordinator)
                
            case .auth:
                AuthView()
                    .environmentObject(coordinator)
                
            case .main:
                MainView()
                    .environmentObject(coordinator)
                    .environmentObject(tabCoordinator)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: coordinator.currentScreen)
    }
}

// MARK: - Dynamic Top Bar
struct DynamicTopBar: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var tabCoordinator: TabCoordinator
    
    var body: some View {
        Group {
            switch coordinator.currentScreen {
            case .splash:
                EmptyView() // Сплэш без бара
                
            case .welcome:
                WelcomeTopBar()
                
            case .auth:
                EmptyView() // Авторизация без бара
                
            case .main:
                MainTopBar()
                    .environmentObject(coordinator)
                    .environmentObject(tabCoordinator)
            }
        }
        .background(Color.black)
    }
}

// MARK: - Top Bar Components
struct WelcomeTopBar: View {
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 4) {
                Image("logoRiseOn")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(height: 60)
    }
}

struct MainTopBar: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var tabCoordinator: TabCoordinator
    
    var body: some View {
        HStack {
            // Кнопка профиля/настройки
            Button {
                // TODO: Показать профиль или настройки
            } label: {
                Image(systemName: "person.circle")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Заголовок текущей вкладки
            Text(currentTabTitle)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            // Кнопка сброса для тестирования
            Button {
                coordinator.resetAppState()
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
        .frame(height: 60)
    }
    
    private var currentTabTitle: String {
        switch tabCoordinator.selectedTab {
        case 0: return "Главная"
        case 1: return "Тренировки"
        case 2: return "Питание"
        case 3: return "Прогресс"
        default: return "RiseOn"
        }
    }
}

// MARK: - Bottom Tab Bar
struct BottomTabBar: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var tabCoordinator: TabCoordinator
    
    var body: some View {
        HStack(spacing: 0) {
            BottomTabButton(
                title: "Main",
                iconName: "main",
                isSelected: tabCoordinator.selectedTab == 0
            ) {
                tabCoordinator.switchToTab(0)
            }
            
            BottomTabButton(
                title: "Workout",
                iconName: "workout",
                isSelected: tabCoordinator.selectedTab == 1
            ) {
                tabCoordinator.switchToTab(1)
            }
            
            BottomTabButton(
                title: "Nutrition",
                iconName: "nutrition",
                isSelected: tabCoordinator.selectedTab == 2
            ) {
                tabCoordinator.switchToTab(2)
            }
            
            BottomTabButton(
                title: "Progress",
                iconName: "stats",
                isSelected: tabCoordinator.selectedTab == 3
            ) {
                tabCoordinator.switchToTab(3)
            }
        }
        .background(Color.black)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .top
        )
    }
}

// MARK: - Bottom Tab Button
struct BottomTabButton: View {
    let title: String
    let iconName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(iconName)
                    .renderingMode(.template)
                    .foregroundColor(isSelected ? .primaryButton : .gray)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .primaryButton : .gray)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
    }
}

#Preview {
    MainContainer()
        .modelContainer(for: UserProfileModel.self, inMemory: true)
}
