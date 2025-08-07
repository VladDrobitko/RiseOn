//
//  AppFlowView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI
import SwiftData

struct AppFlowView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var coordinator: AppCoordinator
    @StateObject private var surveyViewModel = SurveyViewModel()
    
    init() {
        // Инициализируем координатор без моделконтекста (он будет передан позже)
        _coordinator = StateObject(wrappedValue: AppCoordinator())
    }
    
    var body: some View {
        ZStack {
            // Выбираем текущий экран на основе состояния координатора
            switch coordinator.currentScreen {
            case .splash:
                SplashScreenView()
                    .environmentObject(coordinator)
                    .onAppear {
                        // После отображения сплэша переходим дальше
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
                
            case .survey:
                SurveyCoordinatorView(viewModel: surveyViewModel)
                    .environmentObject(coordinator)
                
            case .main:
                MainView()
                    .environmentObject(coordinator)
            }
        }
        .sheet(isPresented: $coordinator.showAuthSheet) {
            AuthView()
                .environmentObject(coordinator)
                .presentationDetents([.medium, .large]) // Адаптивная высота
                .presentationDragIndicator(.visible)
                .presentationBackground(.clear) // Убираем стандартный фон
        }
        
        .onAppear {
            // Передаем моделконтекст после появления представления
            DispatchQueue.main.async {
                coordinator.updateModelContext(modelContext)
            }
        }
    }
}

#Preview {
    AppFlowView()
        .modelContainer(for: UserProfileModel.self, inMemory: true)
}
