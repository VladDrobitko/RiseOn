//
//  StartScreenView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 03/02/2025.
//

import SwiftUI

struct StartScreenView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Image("Start")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                // Логотип
                logoSection
                
                Spacer()
                
                // Основной контент
                VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
                    // Заголовок и описание
                    headerSection
                    
                    // Превью функций
                    featuresPreview
                    
                    // Кнопка запуска
                    actionButton
                }
                .padding(.horizontal, DesignTokens.Padding.screen)
                .padding(.bottom, DesignTokens.Spacing.xxxl * 2)
            }
        }
        .sheet(isPresented: $appState.showAuthSheet) {
            AuthView()
                .environmentObject(appState)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(DesignTokens.CornerRadius.xl)
                .presentationBackground(.ultraThinMaterial)
        }
    }
}

// MARK: - Logo Section
extension StartScreenView {
    private var logoSection: some View {
        VStack {
            Image("logoRiseOn")
        }
        .padding(.top, DesignTokens.Spacing.xxxl * 2)
    }
}

// MARK: - Header Section
extension StartScreenView {
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                Text("Welcome to RiseOn!")
                    .riseOnHeading1()
                    .foregroundColor(.typographyPrimary)
                
                Text("Achieve your best shape with workouts and nutrition plans made just for you.")
                    .riseOnBody()
                    .foregroundColor(.typographyPrimary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Features Preview
extension StartScreenView {
    private var featuresPreview: some View {
        RiseOnCard(style: .glass, size: .large) {
            VStack(spacing: DesignTokens.Spacing.md) {
                FeatureRow(
                    icon: "figure.run.circle.fill",
                    title: "Personalized Training",
                    description: "Plan that fits your goals & level"
                )
                
                FeatureRow(
                    icon: "fork.knife.circle.fill",
                    title: "Smart Nutrition Guide",
                    description: "Easy and tasty meals to fuel your progress"
                )
                
                FeatureRow(
                    icon: "chart.line.uptrend.xyaxis.circle.fill",
                    title: "Progress Tracking",
                    description: "Track progress & stay motivated"
                )
            }
        }
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: DesignTokens.Sizes.iconLarge))
                .foregroundColor(.primaryButton)
                .frame(width: DesignTokens.Sizes.iconLarge)
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(title)
                    .riseOnHeading4()
                    .foregroundColor(.typographyPrimary)
                
                Text(description)
                    .riseOnCaption()
                    .foregroundColor(.typographyGrey)
            }
            
            Spacer()
        }
    }
}

// MARK: - Action Button
extension StartScreenView {
    private var actionButton: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            RiseOnButton.primary("Start Your Journey", size: .large) {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                
                appState.showAuthSheet = true
            }
            
            // Дополнительная информация
            Text("Join thousands of users achieving their fitness goals")
                .riseOnCaption()
                .foregroundColor(.typographyGrey.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
   let appState = AppState()
   return StartScreenView()
       .environmentObject(appState)
       .preferredColorScheme(.dark)
}
