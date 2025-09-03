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
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
                // Приветствие пользователя
                welcomeSection
                
                // Основной контент
                VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
                    // Информационная карточка
                    welcomeInfoCard
                    
                    // Быстрые действия
                    quickActionsSection
                    
                    // Статистика
                    statisticsSection
                }
                .padding(.horizontal, DesignTokens.Padding.screen)
            }
            .padding(.top, DesignTokens.Spacing.xl)
        }
        .background(Color.black.ignoresSafeArea(.all))
        .navigationTitle("Main")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Welcome Section
extension MainPage {
    private var welcomeSection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("Welcome back!")
                .riseOnHeading1()
                .foregroundColor(.typographyPrimary)
            
            Text("Ready to continue your fitness journey?")
                .riseOnBody()
                .foregroundColor(.typographyGrey)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, DesignTokens.Padding.screen)
    }
}

// MARK: - Welcome Info Card
extension MainPage {
    private var welcomeInfoCard: some View {
        InfoCard(
            title: "Start Your Journey",
            message: "Complete your profile setup to get personalized workout and nutrition plans tailored just for you.",
            icon: "figure.run.circle.fill",
            style: .glass
        )
    }
}

// MARK: - Quick Actions Section
extension MainPage {
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Quick Actions")
                .riseOnHeading2()
                .foregroundColor(.typographyPrimary)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: DesignTokens.Spacing.md), count: 3),
                spacing: DesignTokens.Spacing.md
            ) {
                QuickActionCard(
                    title: "Workout",
                    icon: "figure.run",
                    color: .primaryButton
                ) {
                    print("Workout tapped")
                }
                
                QuickActionCard(
                    title: "Nutrition",
                    icon: "fork.knife",
                    color: .hoverButton
                ) {
                    print("Nutrition tapped")
                }
                
                QuickActionCard(
                    title: "Progress",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .focusedButton
                ) {
                    print("Progress tapped")
                }
            }
        }
    }
}

// MARK: - Quick Action Card Component
struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        RiseOnCard(style: .basic, size: .medium, onTap: action) {
            VStack(spacing: DesignTokens.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: DesignTokens.Sizes.iconMedium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .riseOnBodySmall(.medium)
                    .foregroundColor(.typographyPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
        }
    }
}

// MARK: - Statistics Section
extension MainPage {
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            HStack {
                Text("This Week")
                    .riseOnHeading2()
                    .foregroundColor(.typographyPrimary)
                
                Spacer()
                
                RiseOnButton.ghost("View All", size: .small) {
                    print("View all stats")
                }
            }
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: DesignTokens.Spacing.md), count: 2),
                spacing: DesignTokens.Spacing.md
            ) {
                StatCard(
                    title: "Workouts",
                    value: "12",
                    change: "+3 this week",
                    isPositive: true
                )
                
                StatCard(
                    title: "Calories Burned",
                    value: "2,450",
                    change: "Daily average",
                    isPositive: true
                )
                
                StatCard(
                    title: "Active Minutes",
                    value: "180",
                    change: "+25 vs last week",
                    isPositive: true
                )
                
                StatCard(
                    title: "Water Intake",
                    value: "1.8L",
                    change: "Goal: 2.0L",
                    isPositive: false
                )
            }
        }
    }
}

// MARK: - Additional Components for MainPage

/// Карточка достижений
struct AchievementCard: View {
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    
    var body: some View {
        RiseOnCard(style: .gradient, size: .medium) {
            HStack(spacing: DesignTokens.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(isUnlocked ? Color.primaryButton.opacity(0.2) : Color.typographyGrey.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: DesignTokens.Sizes.iconMedium))
                        .foregroundColor(isUnlocked ? .primaryButton : .typographyGrey)
                }
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(title)
                        .riseOnHeading4()
                        .foregroundColor(.typographyPrimary)
                    
                    Text(description)
                        .riseOnCaption()
                        .foregroundColor(.typographyGrey)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                }
            }
        }
    }
}

/// Карточка цели дня
struct DailyGoalCard: View {
    let title: String
    let current: Int
    let target: Int
    let unit: String
    let icon: String
    
    private var progress: Double {
        Double(current) / Double(target)
    }
    
    var body: some View {
        RiseOnCard(style: .basic, size: .medium) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.primaryButton)
                        .font(.title2)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(current)")
                            .riseOnHeading3()
                            .foregroundColor(.typographyPrimary)
                        
                        Text("/ \(target) \(unit)")
                            .riseOnCaption()
                            .foregroundColor(.typographyGrey)
                    }
                }
                
                Text(title)
                    .riseOnBodySmall(.medium)
                    .foregroundColor(.typographyPrimary)
                
                ProgressView(value: min(progress, 1.0))
                    .progressViewStyle(LinearProgressViewStyle(tint: .primaryButton))
                    .background(Color.typographyGrey.opacity(0.2))
                    .cornerRadius(DesignTokens.CornerRadius.xs)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let appState = AppState()
    
    NavigationView {
        MainPage()
            .environmentObject(appState)
    }
    .preferredColorScheme(.dark)
}
