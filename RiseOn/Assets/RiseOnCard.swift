//
//  RiseOnCard.swift
//  RiseOn
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI

// MARK: - Card Style Enum
enum RiseOnCardStyle {
    case basic          // Обычная карточка
    case elevated       // Карточка с тенью
    case outlined       // Карточка с обводкой
    case gradient       // Карточка с градиентом
    case glass          // Стеклянный эффект
    
    var backgroundColor: Color {
        switch self {
        case .basic, .elevated, .outlined: return .card
        case .gradient: return .clear
        case .glass: return .clear
        }
    }
    
    var borderColor: Color {
        switch self {
        case .outlined: return .typographyGrey.opacity(0.3)
        default: return .clear
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .outlined: return 1
        default: return 0
        }
    }
    
    var shadowRadius: CGFloat {
        switch self {
        case .elevated: return DesignTokens.Elevation.card.radius
        default: return 0
        }
    }
    
    var shadowOffset: CGSize {
        switch self {
        case .elevated:
            return CGSize(width: DesignTokens.Elevation.card.x, height: DesignTokens.Elevation.card.y)
        default:
            return .zero
        }
    }
}

// MARK: - Card Size Enum
enum RiseOnCardSize {
    case compact        // Компактная карточка
    case medium         // Стандартная карточка
    case large          // Большая карточка
    
    var padding: EdgeInsets {
        switch self {
        case .compact: return EdgeInsets(top: DesignTokens.Spacing.sm, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.sm, trailing: DesignTokens.Spacing.md)
        case .medium: return EdgeInsets(top: DesignTokens.Spacing.md, leading: DesignTokens.Spacing.lg, bottom: DesignTokens.Spacing.md, trailing: DesignTokens.Spacing.lg)
        case .large: return EdgeInsets(top: DesignTokens.Spacing.lg, leading: DesignTokens.Spacing.xl, bottom: DesignTokens.Spacing.lg, trailing: DesignTokens.Spacing.xl)
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .compact: return DesignTokens.CornerRadius.sm
        case .medium: return DesignTokens.CornerRadius.md
        case .large: return DesignTokens.CornerRadius.lg
        }
    }
}

// MARK: - RiseOn Card Component
struct RiseOnCard<Content: View>: View {
    let style: RiseOnCardStyle
    let size: RiseOnCardSize
    let content: Content
    let onTap: (() -> Void)?
    
    init(
        style: RiseOnCardStyle = .basic,
        size: RiseOnCardSize = .medium,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.size = size
        self.onTap = onTap
        self.content = content()
    }
    
    var body: some View {
        Group {
            if let onTap = onTap {
                Button(action: onTap) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                cardContent
            }
        }
    }
    
    @ViewBuilder
    private var cardContent: some View {
        content
            .padding(size.padding)
            .background(cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
            .cornerRadius(size.cornerRadius)
            .shadow(
                color: .black.opacity(0.1),
                radius: style.shadowRadius,
                x: style.shadowOffset.width,
                y: style.shadowOffset.height
            )
    }
    
    @ViewBuilder
    private var cardBackground: some View {
        switch style {
        case .basic, .elevated, .outlined:
            style.backgroundColor
        case .gradient:
            LinearGradient.gradientCard
        case .glass:
            Color.clear
                .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Specialized Card Components

/// Карточка для воркаутов
struct WorkoutCard: View {
    let title: String
    let subtitle: String
    let duration: String
    let calories: String
    let difficulty: String
    let imageUrl: String?
    let isLocked: Bool
    let onTap: () -> Void
    
    var body: some View {
        RiseOnCard(style: .basic, size: .medium, onTap: onTap) {
            HStack(spacing: DesignTokens.Spacing.md) {
                // Изображение или плейсхолдер
                ZStack {
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                        .fill(Color.typographyGrey.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.typographyGrey)
                    } else {
                        Image(systemName: "figure.run")
                            .foregroundColor(.primaryButton)
                    }
                }
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(title)
                        .riseOnHeading4()
                        .foregroundColor(.typographyPrimary)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .riseOnCaption()
                        .foregroundColor(.typographyGrey)
                        .lineLimit(2)
                    
                    HStack(spacing: DesignTokens.Spacing.md) {
                        HStack(spacing: DesignTokens.Spacing.xs) {
                            Image(systemName: "clock")
                                .font(.system(size: DesignTokens.Sizes.iconSmall))
                                .foregroundColor(.typographyGrey)
                            Text(duration)
                                .riseOnCaption()
                                .foregroundColor(.typographyGrey)
                        }
                        
                        HStack(spacing: DesignTokens.Spacing.xs) {
                            Image(systemName: "flame")
                                .font(.system(size: DesignTokens.Sizes.iconSmall))
                                .foregroundColor(.typographyGrey)
                            Text(calories)
                                .riseOnCaption()
                                .foregroundColor(.typographyGrey)
                        }
                        
                        Text(difficulty)
                            .riseOnCaption(.medium)
                            .foregroundColor(.primaryButton)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.typographyGrey)
                    .font(.caption)
            }
        }
    }
}

/// Карточка для прогресса
struct ProgressCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let progress: Double
    
    var body: some View {
        RiseOnCard(style: .basic, size: .medium) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.primaryButton)
                        .font(.title2)
                    
                    Spacer()
                    
                    Text(value)
                        .riseOnHeading2()
                        .foregroundColor(.primaryButton)
                }
                
                Text(title)
                    .riseOnHeading4()
                    .foregroundColor(.typographyPrimary)
                
                Text(subtitle)
                    .riseOnCaption()
                    .foregroundColor(.typographyGrey)
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .primaryButton))
                    .background(Color.typographyGrey.opacity(0.2))
                    .cornerRadius(DesignTokens.CornerRadius.xs)
            }
        }
    }
}

/// Информационная карточка
struct InfoCard: View {
    let title: String
    let message: String
    let icon: String
    let style: RiseOnCardStyle
    
    init(
        title: String,
        message: String,
        icon: String = "info.circle",
        style: RiseOnCardStyle = .glass
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.style = style
    }
    
    var body: some View {
        RiseOnCard(style: style, size: .large) {
            HStack(spacing: DesignTokens.Spacing.lg) {
                Image(systemName: icon)
                    .foregroundColor(.primaryButton)
                    .font(.system(size: DesignTokens.Sizes.iconLarge))
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    Text(title)
                        .riseOnHeading3()
                        .foregroundColor(.typographyPrimary)
                    
                    Text(message)
                        .riseOnBody()
                        .foregroundColor(.typographyGrey)
                }
                
                Spacer()
            }
        }
    }
}

/// Карточка статистики
struct StatCard: View {
    let title: String
    let value: String
    let change: String
    let isPositive: Bool
    
    var body: some View {
        RiseOnCard(style: .basic, size: .compact) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text(title)
                    .riseOnCaption()
                    .foregroundColor(.typographyGrey)
                
                Text(value)
                    .riseOnHeading2()
                    .foregroundColor(.typographyPrimary)
                
                HStack {
                    Image(systemName: isPositive ? "arrow.up" : "arrow.down")
                        .foregroundColor(isPositive ? .green : .red)
                        .font(.caption)
                    
                    Text(change)
                        .riseOnCaption()
                        .foregroundColor(isPositive ? .green : .red)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Preview
struct RiseOnCardPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                Text("Card Styles")
                    .riseOnHeading2()
                    .foregroundColor(.typographyPrimary)
                
                RiseOnCard(style: .basic) {
                    Text("Basic Card")
                        .riseOnBody()
                        .foregroundColor(.typographyPrimary)
                }
                
                RiseOnCard(style: .elevated) {
                    Text("Elevated Card")
                        .riseOnBody()
                        .foregroundColor(.typographyPrimary)
                }
                
                RiseOnCard(style: .outlined) {
                    Text("Outlined Card")
                        .riseOnBody()
                        .foregroundColor(.typographyPrimary)
                }
                
                RiseOnCard(style: .gradient) {
                    Text("Gradient Card")
                        .riseOnBody()
                        .foregroundColor(.typographyPrimary)
                }
                
                RiseOnCard(style: .glass) {
                    Text("Glass Card")
                        .riseOnBody()
                        .foregroundColor(.typographyPrimary)
                }
                
                Divider()
                
                Text("Specialized Cards")
                    .riseOnHeading2()
                    .foregroundColor(.typographyPrimary)
                
                WorkoutCard(
                    title: "Upper Body Workout",
                    subtitle: "Strength training for arms and chest",
                    duration: "45 min",
                    calories: "320 kcal",
                    difficulty: "Medium",
                    imageUrl: nil,
                    isLocked: false
                ) {
                    print("Workout tapped")
                }
                
                ProgressCard(
                    title: "Weekly Steps",
                    value: "75,432",
                    subtitle: "Goal: 70,000 steps",
                    icon: "figure.walk",
                    progress: 0.75
                )
                
                InfoCard(
                    title: "Welcome to RiseOn!",
                    message: "Complete your profile to get personalized recommendations"
                )
                
                HStack(spacing: DesignTokens.Spacing.md) {
                    StatCard(
                        title: "Workouts",
                        value: "12",
                        change: "+3 this week",
                        isPositive: true
                    )
                    
                    StatCard(
                        title: "Calories",
                        value: "2,450",
                        change: "-150 today",
                        isPositive: false
                    )
                }
            }
            .padding(DesignTokens.Padding.screen)
        }
        .background(Color.black)
    }
}

#Preview {
    RiseOnCardPreview()
        .preferredColorScheme(.dark)
}
