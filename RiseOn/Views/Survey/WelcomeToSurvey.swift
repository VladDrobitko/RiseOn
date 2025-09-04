//
//  WelcomeToSurvey.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct WelcomeToSurvey: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    @Environment(\.dismiss) private var dismiss
    @State private var animateContent = false
    @State private var animateSteps = false
    @State private var currentStepIndex = 0
    @State private var autoScrollTimer: Timer?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Фоновое изображение
            Image("Welcom ro Riseon!")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Заголовок, описание и слайды
                VStack(spacing: DesignTokens.Spacing.xl) {
                    // Заголовок и описание
                    headerSection
                    
                    // Слайды карточек
                    VStack(spacing: DesignTokens.Spacing.md) {
                        stepsScrollView
                        pageIndicator
                    }
                    .padding(.horizontal, DesignTokens.Padding.screen)
                }
                
                // Кнопка действия
                actionButtonSection
            }
        }
        .onAppear {
            viewModel.canProceedFromCurrentStep = true
            startAnimations()
        }
        .onDisappear {
            autoScrollTimer?.invalidate()
        }
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.typographyPrimary)
                    .padding(12)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            .padding(.top, 60)
            .padding(.leading, 20)
        }
    }
}



// MARK: - Header Section  
extension WelcomeToSurvey {
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Let's Get to Know You")
                .riseOnHeading1()
                .foregroundColor(.typographyPrimary)
                .opacity(animateContent ? 1.0 : 0.0)
            
            Text("We'll ask you 4 quick questions to create your personalized fitness plan")
                .riseOnBody()
                .foregroundColor(.typographyGrey)
                .opacity(animateContent ? 1.0 : 0.0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, DesignTokens.Padding.screen)
    }
    

    
    private var stepsScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(Array(surveySteps.enumerated()), id: \.offset) { index, step in
                        stepCard(step: step, index: index, isActive: currentStepIndex == index)
                            .id("card_\(index)")
                            .onTapGesture {
                                selectStep(index: index)
                            }
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.sm)
            }
            .onAppear {
                proxy.scrollTo("card_0", anchor: .center)
            }
            .onChange(of: currentStepIndex) { _, newIndex in
                withAnimation(.easeInOut(duration: 0.6)) {
                    proxy.scrollTo("card_\(newIndex)", anchor: .center)
                }
            }
        }
        .frame(height: 100)
        .opacity(animateSteps ? 1.0 : 0.0)
    }
    
    private func stepCard(step: SurveyStep, index: Int, isActive: Bool) -> some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            // Иконка
            ZStack {
                Circle()
                    .fill(isActive ? Color.primaryButton : Color.typographyGrey.opacity(0.3))
                    .frame(width: 44, height: 44)
                
                Image(systemName: step.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
            }
            
            // Информация
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(step.title)
                    .riseOnBodySmall(.semibold)
                    .foregroundColor(.typographyPrimary)
                    .lineLimit(1)
                
                Text(step.description)
                    .riseOnCaption()
                    .foregroundColor(.typographyGrey)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(DesignTokens.Spacing.md)
        .frame(width: 240, height: 80)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                        .stroke(
                            isActive ? Color.primaryButton.opacity(0.6) : Color.clear,
                            lineWidth: 2
                        )
                )
        )
        .opacity(animateSteps ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.1), value: animateSteps)
        .animation(.easeInOut(duration: 0.3), value: currentStepIndex)
    }
    
    private var pageIndicator: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            ForEach(0..<4, id: \.self) { index in
                Circle()
                    .fill(index == currentStepIndex ? Color.primaryButton : Color.typographyGrey.opacity(0.3))
                    .frame(width: 4, height: 4)
                    .animation(.easeInOut(duration: 0.2), value: currentStepIndex)
                    .onTapGesture {
                        selectStep(index: index)
                    }
            }
        }
        .opacity(animateSteps ? 1.0 : 0.0)
    }
}

// MARK: - Action Button Section
extension WelcomeToSurvey {
    private var actionButtonSection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            RiseOnButton.primary("Let's Get Started", size: .large) {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                
                // Переход к следующему шагу опроса
                withAnimation(.easeInOut(duration: DesignTokens.Animation.normal)) {
                    currentStep += 1
                }
            }
            .scaleEffect(animateContent ? 1.0 : 0.9)
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Дополнительная информация
            Text("Takes less than 2 minutes")
                .riseOnCaption()
                .foregroundColor(.typographyGrey.opacity(0.8))
                .opacity(animateContent ? 1.0 : 0.0)
        }
        .padding(.horizontal, DesignTokens.Padding.screen)
        .padding(.top, DesignTokens.Spacing.lg)
        .padding(.bottom, DesignTokens.Spacing.xxxl * 2)
    }
}

// MARK: - Helper Methods
extension WelcomeToSurvey {
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animateSteps = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            startAutoScroll()
        }
    }
    
    private func startAutoScroll() {
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentStepIndex = (currentStepIndex + 1) % 4
            }
        }
    }
    
    private func selectStep(index: Int) {
        stopAutoScroll()
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStepIndex = index
        }
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    // MARK: - Survey Steps Data
    private var surveySteps: [SurveyStep] {
        [
            SurveyStep(
                title: "Personal Info",
                description: "Tell us about yourself",
                icon: "person.circle"
            ),
            SurveyStep(
                title: "Your Goals",
                description: "What you want to achieve",
                icon: "target"
            ),
            SurveyStep(
                title: "Activity Level",
                description: "How active you are",
                icon: "figure.run"
            ),
            SurveyStep(
                title: "Preferences",
                description: "Your workout style",
                icon: "heart.fill"
            )
        ]
    }
}

// MARK: - Supporting Models
struct SurveyStep {
    let title: String
    let description: String
    let icon: String
}

#Preview {
    let viewModel = SurveyViewModel()
    @State var currentStep = 1
    
    return WelcomeToSurvey(viewModel: viewModel, currentStep: .constant(1))
        .background(Color.black)
        .preferredColorScheme(.dark)
}
