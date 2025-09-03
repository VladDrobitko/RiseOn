//
//  WelcomeToSurvey.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct WelcomeToSurvey: View {
    @ObservedObject var viewModel: SurveyViewModel
    @State private var animateContent = false
    @State private var animateSteps = false
    @State private var currentStepIndex = 0
    @State private var autoScrollTimer: Timer?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Фоновое изображение
            Image("Welcom ro Riseon!")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                // НОВЫЙ ТУЛБАР С КНОПКОЙ НАЗАД
                HStack {
                    // Кнопка назад
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            
                    }
                    .scaleEffect(animateContent ? 1.0 : 0.8)
                    .opacity(animateContent ? 1.0 : 0.0)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
                // Логотип
                VStack {
                    Image("logoRiseOn")
                        .scaleEffect(animateContent ? 1.0 : 0.8)
                        .opacity(animateContent ? 1.0 : 0.0)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Основной контент с анимацией
                VStack(alignment: .leading, spacing: 5) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("We'll ask you 4 quick questions to create your personalized fitness plan")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.typographyPrimary)
                            .opacity(animateContent ? 1.0 : 0.0)
                    }
                    .padding(.horizontal)
                    
                    // Preview шагов как слайд-галерея
                    VStack(spacing: 12) {
                        // Заголовок галереи
                        HStack {
                            Text("Quick Preview")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("Swipe to see steps →")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .opacity(animateSteps ? 1.0 : 0.0)
                        
                        // Горизонтальная прокрутка с ScrollViewReader
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(Array(surveySteps.enumerated()), id: \.offset) { index, step in
                                        HStack(spacing: 8) {
                                            // Иконка с номером
                                            ZStack {
                                                Circle()
                                                    .fill(
                                                        currentStepIndex == index ?
                                                        LinearGradient.gradientDarkGreen :
                                                        LinearGradient.gradientCard
                                                    )
                                                    .frame(width: 50, height: 50)
                                                
                                                VStack(spacing: 2) {
                                                    Image(systemName: step.icon)
                                                        .font(.system(size: 24, weight: .medium))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .padding(.leading, 15)
                                            
                                            Spacer()
                                            
                                            // Информация
                                            VStack(spacing: 4) {
                                                Text(step.title)
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(1)
                                                
                                                Text(step.description)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(2)
                                            }
                                            .frame(width: 180)
                                        }
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 8)
                                        .frame(width: 280, height: 90)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(
                                                    currentStepIndex == index ?
                                                        Color.primaryButton.opacity(0.6) :
                                                        Color.white.opacity(0.1),
                                                    lineWidth: 0.8
                                                )
                                        )
                                        .opacity(animateSteps ? 1.0 : 0.0)
                                        .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.1), value: animateSteps)
                                        .animation(.easeInOut(duration: 0.3), value: currentStepIndex)
                                        .id("card_\(index)")
                                        .onTapGesture {
                                            stopAutoScroll()
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                currentStepIndex = index
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
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
                        
                        // Индикатор страниц (точки)
                        HStack(spacing: 6) {
                            ForEach(0..<4, id: \.self) { index in
                                Circle()
                                    .fill(index == currentStepIndex ? Color.primaryButton : Color.white.opacity(0.3))
                                    .frame(width: 6, height: 6)
                                    .animation(.easeInOut(duration: 0.2), value: currentStepIndex)
                                    .onTapGesture {
                                        stopAutoScroll()
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            currentStepIndex = index
                                        }
                                    }
                            }
                        }
                        .opacity(animateSteps ? 1.0 : 0.0)
                    }
                    
                    .padding(.vertical, 16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 140)
            }
            
            // Кнопка с улучшенным дизайном
            VStack(spacing: 12) {
                Button {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    // TODO: Перейти к следующему шагу опроса
                    // Пока просто закрываем экран
                    dismiss()
                } label: {
                    HStack {
                        Text("Let's Get Started")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primaryButton, Color.primaryButton.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color.primaryButton.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .scaleEffect(animateContent ? 1.0 : 0.9)
                .opacity(animateContent ? 1.0 : 0.0)
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
        .onAppear {
            viewModel.canProceedFromCurrentStep = true
            
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
        .onDisappear {
            autoScrollTimer?.invalidate()
        }
    }
    
    // MARK: - Auto Scroll Methods
    private func startAutoScroll() {
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentStepIndex = (currentStepIndex + 1) % 4
            }
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
    let coordinator = AppCoordinator()
    return WelcomeToSurvey(viewModel: viewModel)
        .environmentObject(coordinator)
        .background(Color.black)
        .preferredColorScheme(.dark)
}
