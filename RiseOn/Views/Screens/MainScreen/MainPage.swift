//
//  MainPage.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 16/02/2025.
//

import SwiftUI

struct MainPage: View {
    @EnvironmentObject var viewModel: MainViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var tabCoordinator: TabCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            // Приветствие пользователя
            VStack(spacing: 12) {
                Text("Добро пожаловать!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if let profile = viewModel.userProfile {
                    Text("Привет, \(profile.name)!")
                        .font(.title2)
                        .foregroundColor(.typographyPrimary)
                }
            }
            .padding(.top, 40)
            
            // Основной контент
            VStack(spacing: 24) {
                // Карточка с информацией о пользователе
                if let profile = viewModel.userProfile {
                    UserInfoCard(profile: profile)
                }
                
                // Быстрые действия
                QuickActionsSection()
                
                // Статистика
                StatisticsSection()
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// MARK: - User Info Card
struct UserInfoCard: View {
    let profile: UserProfile
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ваш профиль")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Возраст: \(profile.age) лет")
                        .font(.subheadline)
                        .foregroundColor(.typographyGrey)
                    
                    Text("Вес: \(profile.weight, specifier: "%.1f") кг")
                        .font(.subheadline)
                        .foregroundColor(.typographyGrey)
                    
                    Text("Рост: \(profile.height, specifier: "%.0f") см")
                        .font(.subheadline)
                        .foregroundColor(.typographyGrey)
                }
                
                Spacer()
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.primaryButton)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Quick Actions Section
struct QuickActionsSection: View {
    @EnvironmentObject var tabCoordinator: TabCoordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Быстрые действия")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                QuickActionButton(
                    title: "Тренировка",
                    icon: "figure.run",
                    color: .primaryButton
                ) {
                    tabCoordinator.switchToTab(1)
                }
                
                QuickActionButton(
                    title: "Питание",
                    icon: "fork.knife",
                    color: .hoverButton
                ) {
                    tabCoordinator.switchToTab(2)
                }
                
                QuickActionButton(
                    title: "Прогресс",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .focusedButton
                ) {
                    tabCoordinator.switchToTab(3)
                }
            }
        }
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(color)
            .cornerRadius(12)
        }
    }
}

// MARK: - Statistics Section
struct StatisticsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Статистика")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Тренировок",
                    value: "12",
                    subtitle: "в этом месяце"
                )
                
                StatCard(
                    title: "Калории",
                    value: "2,450",
                    subtitle: "сожжено сегодня"
                )
            }
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primaryButton)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.typographyGrey)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
        )
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let coordinator = AppCoordinator()
    let tabCoordinator = TabCoordinator()
    
    return MainPage()
        .environmentObject(mainViewModel)
        .environmentObject(coordinator)
        .environmentObject(tabCoordinator)
        .preferredColorScheme(.dark)
}
