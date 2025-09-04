//
//  MainAppComponents.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

// MARK: - Welcome Flow
struct WelcomeFlow: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        StartScreenView()
            .environmentObject(appState) // Передаем вместо старого coordinator
    }
}

// MARK: - Authentication Flow
struct AuthenticationFlow: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        AuthView()
            .environmentObject(appState)
    }
}

// MARK: - Authentication Sheet
struct AuthenticationSheet: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        AuthView()
            .environmentObject(appState)
            .presentationBackground(.clear)
    }
}

// MARK: - Main Tab Interface (Multi-Stack Navigation)
struct MainTabInterface: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var mainTabCoordinator = MainTabCoordinator()
    
    var body: some View {
        TabView(selection: $mainTabCoordinator.selectedTab) {
            // Главная вкладка
            NavigationStack {
                MainPage()
                    .applyAppStyle(title: "Main")
            }
            .tabItem {
                Image("main")
                Text("Main")
            }
            .tag(0)
            
            // Тренировки
            NavigationStack {
                WorkoutPage()
                    .applyAppStyle(title: "Workout")
            }
            .tabItem {
                Image("workout")
                Text("Workout")
            }
            .tag(1)
            
            // Питание
            NavigationStack {
                NutritionPage()
                    .applyAppStyle(title: "Nutrition")
            }
            .tabItem {
                Image("nutrition")
                Text("Nutrition")
            }
            .tag(2)
            
            // Прогресс
            NavigationStack {
                ProgressPage()
                    .applyAppStyle(title: "Progress")
            }
            .tabItem {
                Image("stats")
                Text("Progress")
            }
            .tag(3)
        }
        .environmentObject(mainTabCoordinator)
        .accentColor(.primaryButton) // Цвет выбранной вкладки
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        // Кастомизация TabBar под дизайн приложения
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        
        // Цвет невыбранных элементов
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ]
        
        // Цвет и размер выбранных элементов
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.primaryButton)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.primaryButton),
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold) // Немного больше
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Дополнительная настройка для увеличения иконок
        UITabBar.appearance().itemPositioning = .centered
        
        // Убеждаемся что tint color применяется
        UITabBar.appearance().tintColor = UIColor(Color.primaryButton)
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
}

// MARK: - Loading Overlay
struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .primaryButton))
                    .scaleEffect(1.2)
                
                Text("Loading...")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
            .padding(24)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
    }
}

// MARK: - Main Tab Coordinator (переименован чтобы не конфликтовать)
class MainTabCoordinator: ObservableObject {
    @Published var selectedTab: Int = 0
    
    func switchToTab(_ tab: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedTab = tab
        }
    }
}

// MARK: - Custom Toolbar Component
struct CustomMainToolbar: View {
    let title: String
    @State private var showingProfile = false
    
    var body: some View {
        ZStack {
            // Заголовок по центру экрана
            Text(title)
                .riseOnHeading3()
                .foregroundColor(.typographyPrimary)
            
            // Боковые кнопки
            HStack {
                // Кнопка профиля слева
                NavigationLink(destination: ProfileMainPage()) {
                    ZStack {
                        Circle()
                            .fill(Color.typographyGrey.opacity(0.2))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.typographyPrimary)
                    }
                }
                
                Spacer()
                
                // Кнопки справа
                HStack(spacing: DesignTokens.Spacing.md) {
                    // Кнопка избранного
                    Button {
                        // TODO: Открыть избранное
                    } label: {
                        Image(systemName: "heart")
                            .font(.system(size: 20, weight: .light))
                            .foregroundColor(.typographyPrimary)
                    }
                    
                    // Кнопка поиска
                    Button {
                        // TODO: Открыть поиск
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .light))
                            .foregroundColor(.typographyPrimary)
                    }
                }
            }
        }
        .padding(.horizontal, DesignTokens.Padding.screen)
        .padding(.top, 8)
        .frame(height: 52)
        .background(Color.black.ignoresSafeArea(edges: .top))
    }
}

// MARK: - App Style Modifier (единый стиль навигации)
struct AppStyleModifier: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            CustomMainToolbar(title: title)
            
            content
                .navigationBarHidden(true)
        }
        .background(Color.black.ignoresSafeArea())
    }
}

extension View {
    func applyAppStyle(title: String = "") -> some View {
        self.modifier(AppStyleModifier(title: title))
    }
}

// MARK: - Profile Main Page (новая страница профиля с опросом)
struct ProfileMainPage: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Кастомный toolbar
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.typographyPrimary)
                        .padding(12)
                        .background(Circle().fill(.ultraThinMaterial))
                }
                
                Spacer()
                
                Text("Profile")
                    .riseOnHeading3()
                    .foregroundColor(.typographyPrimary)
                
                Spacer()
                
                // Пустое место для симметрии
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, DesignTokens.Padding.screen)
            .padding(.top, 8)
            .frame(height: 52)
            .background(Color.black.ignoresSafeArea(edges: .top))
            
            // Контент
            List {
            Section("Personalization") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Survey Status")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(appState.hasCompletedSurvey ? "Your personal plan is ready" : "Complete survey to get personalized plan")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text(appState.hasCompletedSurvey ? "✅" : "⏳")
                        .font(.title2)
                }
                .padding(.vertical, 4)
                
                NavigationLink(appState.hasCompletedSurvey ? "Retake Survey" : "Complete Survey") {
                    SurveyCoordinatorView(viewModel: SurveyViewModel())
                }
            }
            
            Section("Account") {
                NavigationLink("My Details") {
                    Text("User Details Page")
                        .navigationTitle("My Details")
                }
                
                NavigationLink("Settings") {
                    Text("Settings Page")
                        .navigationTitle("Settings")
                }
            }
            
            Section {
                Button("Reset App (Debug)") {
                    appState.resetAppState()
                }
                .foregroundColor(.red)
                
                Button("Logout") {
                    appState.logout()
                }
                .foregroundColor(.red)
            }
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.black)
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}
