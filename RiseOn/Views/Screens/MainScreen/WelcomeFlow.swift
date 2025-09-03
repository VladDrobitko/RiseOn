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
                    .applyAppStyle() // Единый стиль
            }
            .tabItem {
                Image("main")
                Text("Main")
            }
            .tag(0)
            
            // Тренировки
            NavigationStack {
                WorkoutPage()
                    .applyAppStyle()
            }
            .tabItem {
                Image("workout")  
                Text("Workout")
            }
            .tag(1)
            
            // Питание
            NavigationStack {
                NutritionPage()
                    .applyAppStyle()
            }
            .tabItem {
                Image("nutrition")
                Text("Nutrition")
            }
            .tag(2)
            
            // Прогресс
            NavigationStack {
                ProgressPage()
                    .applyAppStyle()
            }
            .tabItem {
                Image("stats")
                Text("Progress")
            }
            .tag(3)
            
            // Профиль (здесь будет опрос)
            NavigationStack {
                ProfileMainPage()
                    .applyAppStyle()
            }
            .tabItem {
                Image("user")
                Text("Profile")
            }
            .tag(4)
        }
        .environmentObject(mainTabCoordinator)
        .tint(.primaryButton) // Цвет выбранной вкладки
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
            .foregroundColor: UIColor.gray
        ]
        
        // Цвет выбранных элементов
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.primaryButton)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.primaryButton)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
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

// MARK: - App Style Modifier (единый стиль навигации)
struct AppStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

extension View {
    func applyAppStyle() -> some View {
        self.modifier(AppStyleModifier())
    }
}

// MARK: - Profile Main Page (новая страница профиля с опросом)
struct ProfileMainPage: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
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
                
                NavigationLink("Complete Survey") {
                    SurveyCoordinatorView(viewModel: SurveyViewModel())
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") {
                                    // Возврат назад
                                }
                            }
                        }
                }
                .disabled(appState.hasCompletedSurvey)
                .opacity(appState.hasCompletedSurvey ? 0.6 : 1.0)
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
        .navigationTitle("Profile")
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
        .background(Color.black)
    }
}