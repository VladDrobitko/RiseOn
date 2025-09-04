//
//  SurveyCoordinatorView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

struct SurveyCoordinatorView: View {
    @ObservedObject var viewModel: SurveyViewModel
    @State private var currentStep: Int = 1
    @Environment(\.dismiss) private var dismiss
    
    private let totalSteps = 8
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Toolbar для шагов 2-8
                    if currentStep > 1 {
                        surveyToolbar
                            .zIndex(1)
                    }
                    
                    // Контент экрана
                    Spacer()
                    
                    Group {
                        switch currentStep {
                        case 1:
                            WelcomeToSurvey(viewModel: viewModel, currentStep: $currentStep)
                                .transition(.opacity)
                        case 2:
                            AboutUserScreen(viewModel: viewModel, currentStep: .constant(2))
                                .transition(.opacity)
                        case 3:
                            UserGoalScreen(viewModel: viewModel, currentStep: .constant(3))
                                .transition(.opacity)
                        case 4:
                            UserLevelScreen(viewModel: viewModel, currentStep: .constant(4))
                                .transition(.opacity)
                        case 5:
                            UserPreferScreen(viewModel: viewModel, currentStep: .constant(5))
                                .transition(.opacity)
                        case 6:
                            UserDietesScreen(viewModel: viewModel, currentStep: .constant(6))
                                .transition(.opacity)
                        case 7:
                            WorkoutDaysScreen(viewModel: viewModel, currentStep: .constant(7))
                                .transition(.opacity)
                        case 8:
                            SurveyResult(viewModel: viewModel, currentStep: .constant(8))
                                .transition(.opacity)
                        default:
                            EmptyView()
                        }
                    }
                    
                    Spacer()
                    
                    // Кнопка продолжить
                    if currentStep > 1 {
                        bottomButton
                            .padding(.horizontal, DesignTokens.Padding.screen)
                            .padding(.bottom, DesignTokens.Spacing.xl)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            if currentStep == 1 {
                viewModel.canProceedFromCurrentStep = true
            }
        }
    }
}

// MARK: - Survey Toolbar
extension SurveyCoordinatorView {
    private var surveyToolbar: some View {
        VStack(spacing: 0) {
            HStack {
                // Кнопка назад
                Button {
                    if currentStep > 1 {
                        withAnimation(.easeInOut(duration: DesignTokens.Animation.normal)) {
                            currentStep -= 1
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.typographyPrimary)
                        .padding(12)
                        .background(Circle().fill(.ultraThinMaterial))
                }
                
                Spacer()
                
                // Индикатор прогресса
                SurveyProgressIndicator(
                    currentStep: currentStep - 1,
                    totalSteps: totalSteps - 1
                )
                
                Spacer()
                
                // Пустое место для баланса
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, DesignTokens.Padding.screen)
            .frame(height: 60)
            .background(Color.black)
            
            // Разделитель
            Rectangle()
                .fill(Color.typographyGrey.opacity(0.2))
                .frame(height: 1)
        }
    }
}

// MARK: - Survey Progress Indicator
struct SurveyProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            // Progress bar
            HStack(spacing: DesignTokens.Spacing.xs) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    Rectangle()
                        .fill(index < currentStep ? Color.primaryButton : Color.typographyGrey.opacity(0.3))
                        .frame(height: 3)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(1.5)
                }
            }
            .frame(maxWidth: 120)
            
            // Step counter
            Text("\(currentStep) of \(totalSteps)")
                .riseOnCaption()
                .foregroundColor(.typographyGrey)
        }
    }
}

// MARK: - Bottom Button
extension SurveyCoordinatorView {
    private var bottomButton: some View {
        RiseOnButton(
            currentStep == totalSteps ? "Complete Survey" : "Continue",
            style: viewModel.canProceedFromCurrentStep ? .primary : .disabled,
            size: .large
        ) {
            handleContinueAction()
        }
    }
    
    private func handleContinueAction() {
        if currentStep < totalSteps {
            if currentStep == 1 {
                viewModel.canProceedFromCurrentStep = false
            }
            proceedToNextStep()
        } else {
            // Завершение опроса
            viewModel.saveResults()
            dismiss()
        }
    }
    
    private func proceedToNextStep() {
        withAnimation(.easeInOut(duration: DesignTokens.Animation.normal)) {
            currentStep += 1
        }
    }
}

// MARK: - Survey Step Card (для использования в других экранах)
struct SurveyStepCard: View {
    let title: String
    let subtitle: String?
    let content: AnyView
    
    init<Content: View>(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = AnyView(content())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sectionSpacing) {
            // Header
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text(title)
                    .riseOnHeading2()
                    .foregroundColor(.typographyPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .riseOnBody()
                        .foregroundColor(.typographyGrey)
                }
            }
            .padding(.horizontal, DesignTokens.Padding.screen)
            
            // Content
            content
        }
    }
}

// MARK: - Survey Option Card (для выбора опций)
struct SurveyOptionCard: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        RiseOnCard(
            style: isSelected ? .gradient : .basic,
            size: .medium,
            onTap: action
        ) {
            HStack {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(title)
                        .riseOnHeading4()
                        .foregroundColor(.typographyPrimary)
                    
                    Text(subtitle)
                        .riseOnBodySmall()
                        .foregroundColor(.typographyGrey)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.primaryButton)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .stroke(isSelected ? Color.primaryButton : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    let surveyViewModel = SurveyViewModel()
    
    return SurveyCoordinatorView(viewModel: surveyViewModel)
        .preferredColorScheme(.dark)
}
