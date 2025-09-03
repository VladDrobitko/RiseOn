//
//  MainPage.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 16/02/2025.
//

import SwiftUI

struct MainPage: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            // Приветствие пользователя
            VStack(spacing: 12) {
                Text("Добро пожаловать!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Добро пожаловать в RiseOn!")
                    .font(.title2)
                    .foregroundColor(.typographyPrimary)
            }
            .padding(.top, 40)
            
            // Основной контент
            VStack(spacing: 24) {
                // Информационная карточка (временная заглушка)
                InfoCard()
                
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
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Info Card (временная заглушка)
struct InfoCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Добро пожаловать!")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Начните свой путь к здоровому образу жизни")
                        .font(.subheadline)
                        .foregroundColor(.typographyGrey)
                    
                    Text("Пройдите опрос в профиле для персонального плана")
                        .font(.caption)
                        .foregroundColor(.typographyGrey)
                }
                
                Spacer()
                
                Image(systemName: "figure.run.circle.fill")
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
                    // В новой архитектуре TabView автоматически переключает табы
                    // Действие будет добавлено позже через NavigationLink
                    print("Тренировка - пока заглушка")
                }
                
                QuickActionButton(
                    title: "Питание",
                    icon: "fork.knife",
                    color: .hoverButton
                ) {
                    print("Питание - пока заглушка")
                }
                
                QuickActionButton(
                    title: "Прогресс",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .focusedButton
                ) {
                    print("Прогресс - пока заглушка")
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
    let appState = AppState()
    
    MainPage()
        .environmentObject(appState)
        .preferredColorScheme(.dark)
}
