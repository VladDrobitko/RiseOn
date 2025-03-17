//
//  UserLevelScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserLevelOptionView: View {
    let level: Level
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(level.rawValue)
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(.typographyPrimary)
                Text(level.description)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.typographyGrey)
            }
            Spacer()
        }
        .padding(13)
        .frame(maxWidth: .infinity)
        .background(isSelected ? LinearGradient.gradientDarkGreen : nil)
        .background(!isSelected ? Color.card : nil)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.primaryButton : Color.gray, lineWidth: 0.5)
        )
        .cornerRadius(10)
    }
}

struct UserLevelScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("What is your activity level?")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.typographyPrimary)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    ForEach(Level.allCases, id: \.self) { level in
                        Button(action: {
                            // Сохраняем выбранный уровень активности
                            viewModel.saveLevel(level)
                            // Разрешаем переход к следующему шагу
                            viewModel.canProceedFromCurrentStep = true
                        }) {
                            UserLevelOptionView(level: level, isSelected: viewModel.level == level)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                // При появлении экрана проверяем, выбран ли уже уровень активности
                viewModel.canProceedFromCurrentStep = viewModel.level != nil
            }
        }
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserLevelScreen(viewModel: viewModel, currentStep: .constant(4))
}
