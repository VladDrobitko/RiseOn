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
    
    var body: some View {
        Group {
            if appState.isFirstLaunch {
                StartScreenView()
            } else if appState.isAuthenticated {
                MainTabView()
            } else {
                Color.black.ignoresSafeArea()
            }
        }
        .preferredColorScheme(.dark)
        .tint(.primaryButton)
        .environmentObject(appState)
        .sheet(isPresented: $appState.showAuthSheet) {
            AuthView()
                .environmentObject(appState)
        }
        .onAppear {
            appState.updateModelContext(modelContext)
            // Если не первый запуск и не авторизован - показываем Sheet
            if !appState.isFirstLaunch && !appState.isAuthenticated {
                appState.showAuthSheet = true
            }
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
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 125, height: 125)
                .opacity(opacity)
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
