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
        GeometryReader { geometry in
            let availableHeight = geometry.size.height - 52 - 83 // toolbar + tabbar
            let sectionHeight = availableHeight / 3
            
            VStack(spacing: 0) {
                // Верхняя секция - карточка событий
                VStack {
                    Spacer()
                    topEventCard
                        .padding(.horizontal, DesignTokens.Padding.screen)
                    Spacer()
                }
                .frame(height: sectionHeight)
                
                // Средняя секция - горизонтальный скролл групп мышц
                VStack {
                    Spacer()
                    muscleGroupsHorizontalSection
                    Spacer()
                }
                .frame(height: sectionHeight)
                
                // Нижняя секция - квадратные карточки разминки
                VStack {
                    Spacer()
                    warmUpCardsSection
                        .padding(.horizontal, DesignTokens.Padding.screen)
                    Spacer()
                }
                .frame(height: sectionHeight)
            }
        }
        .background(Color.black.ignoresSafeArea(.all))
    }
}

// MARK: - Top Event Card
extension MainPage {
    private var topEventCard: some View {
        RiseOnCard(style: .gradient, size: .large) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                HStack {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Text("🏃‍♂️ Marathon Training")
                            .riseOnHeading2()
                            .foregroundColor(.typographyPrimary)
                        
                        Text("Join our 12-week marathon preparation program")
                            .riseOnBody()
                            .foregroundColor(.typographyGrey)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.typographyGrey)
                }
                
                Spacer()
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    StatChip(icon: "calendar", text: "12 weeks", color: .primaryButton)
                    StatChip(icon: "person.2", text: "1.2k joined", color: .primaryButton)
                    Spacer()
                }
            }
        }
        .frame(height: 180)
    }
}

// MARK: - Muscle Groups Horizontal Section
extension MainPage {
    private var muscleGroupsHorizontalSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            // Header with "Show All" button
            HStack {
                Text("Muscle Groups")
                    .riseOnHeading2()
                    .foregroundColor(.typographyPrimary)
                
                Spacer()
                
                NavigationLink(destination: TestMuscleGroupScreen()) {
                    HStack(spacing: 4) {
                        Text("Show All")
                            .riseOnCaption(.medium)
                            .foregroundColor(.primaryButton)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.primaryButton)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, DesignTokens.Padding.screen)
            
            // Vertical layout for muscle group cards
            VStack(spacing: DesignTokens.Spacing.md) {
                // Первая карточка - ведет на список упражнений
                NavigationLink(destination: ExerciseListScreen(muscleGroup: .legs)) {
                    CompactMuscleGroupCard(
                        muscleGroup: .legs,
                        exerciseCount: 2,
                        estimatedTime: 27
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Вторая карточка
                NavigationLink(destination: ExerciseListScreen(muscleGroup: .chest)) {
                    CompactMuscleGroupCard(
                        muscleGroup: .chest,
                        exerciseCount: 2,
                        estimatedTime: 30
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Третья карточка
                NavigationLink(destination: ExerciseListScreen(muscleGroup: .back)) {
                    CompactMuscleGroupCard(
                        muscleGroup: .back,
                        exerciseCount: 2,
                        estimatedTime: 25
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, DesignTokens.Padding.screen)
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

// MARK: - Warm Up Cards Section
extension MainPage {
    private var warmUpCardsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Quick Warm-ups")
                .riseOnHeading2()
                .foregroundColor(.typographyPrimary)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: DesignTokens.Spacing.md), count: 2),
                spacing: DesignTokens.Spacing.md
            ) {
                WarmUpCard(
                    title: "Morning Stretch",
                    duration: "5 min",
                    icon: "figure.yoga"
                )
                
                WarmUpCard(
                    title: "Quick Cardio",
                    duration: "10 min", 
                    icon: "figure.run"
                )
            }
        }
    }
}

// MARK: - Compact Muscle Group Card
struct CompactMuscleGroupCard: View {
    let muscleGroup: MuscleGroup
    let exerciseCount: Int
    let estimatedTime: Int
    
    var body: some View {
        RiseOnCard(style: .basic, size: .medium) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                // Icon and title
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    ZStack {
                        Circle()
                            .fill(Color.primaryButton.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: muscleGroup.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primaryButton)
                    }
                    
                    Text(muscleGroup.displayName)
                        .riseOnHeading4()
                        .foregroundColor(.typographyPrimary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Stats
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    StatChip(
                        icon: "list.bullet",
                        text: "\(exerciseCount) exercises",
                        color: .typographyGrey
                    )
                    
                    StatChip(
                        icon: "clock",
                        text: "\(estimatedTime) min",
                        color: .typographyGrey
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
    }
}

// MARK: - Warm Up Card
struct WarmUpCard: View {
    let title: String
    let duration: String
    let icon: String
    
    var body: some View {
        RiseOnCard(style: .basic, size: .medium) {
            VStack(spacing: DesignTokens.Spacing.md) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.primaryButton.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.primaryButton)
                }
                
                Spacer()
                
                // Info
                VStack(spacing: DesignTokens.Spacing.xs) {
                    Text(title)
                        .riseOnHeading4()
                        .foregroundColor(.typographyPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(duration)
                        .riseOnCaption(.medium)
                        .foregroundColor(.typographyGrey)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 140)
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
