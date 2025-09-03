//
//  MainApp.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI
import SwiftData

struct MainApp: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var appState = AppState()
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashScreen()
                    .onAppear {
                        // Показываем splash 2 секунды
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showSplash = false
                            }
                        }
                    }
            } else if appState.isFirstLaunch {
                StartScreenView()
            } else if appState.isAuthenticated {
                MainTabView()
            } else {
                StartScreenView()
            }
        }
        .preferredColorScheme(.dark)
        .tint(.primaryButton)
        .environmentObject(appState)
        .onAppear {
            appState.updateModelContext(modelContext)
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                MainPage()
            }
            .tabItem {
                Image("main")
                Text("Main")
            }
            .tag(0)
            
            NavigationStack {
                WorkoutPage()
            }
            .tabItem {
                Image("workout")
                Text("Workout")
            }
            .tag(1)
            
            NavigationStack {
                NutritionPage()
            }
            .tabItem {
                Image("nutrition")
                Text("Nutrition")
            }
            .tag(2)
            
            NavigationStack {
                ProgressPage()
            }
            .tabItem {
                Image("stats")
                Text("Progress")
            }
            .tag(3)
            
            NavigationStack {
                ProfileTabPage()
            }
            .tabItem {
                Image("user")
                Text("Profile")
            }
            .tag(4)
        }
        .tint(.primaryButton)
    }
}

struct SplashScreen: View {
    @State private var logoScale = 0.8
    @State private var logoOpacity = 0.0
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("logoRiseOn") // Используем тот же логотип что и на стартовом экране
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.8)) {
                            logoScale = 1.0
                            logoOpacity = 1.0
                        }
                    }
                
            }
        }
    }
}

struct ProfileTabPage: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            List {
                Section("Survey") {
                    NavigationLink("Complete Survey") {
                        SurveyCoordinatorView(viewModel: SurveyViewModel())
                    }
                }
                
                Section {
                    Button("Logout") {
                        appState.logout()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
        }
    }
}
