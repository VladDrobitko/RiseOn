//
//  UserDietesScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserDietOptionView: View {
    let diet: Diet
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(diet.rawValue)
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(.typographyPrimary)
                Text(diet.description)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.typographyGrey)
            }
            Spacer()
        }
        .padding(13)
        .frame(maxWidth: .infinity)
        .background( isSelected ? LinearGradient.gradientDarkGreen : nil )
        .background( !isSelected ? Color.card : nil)

        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.primaryButton : Color.gray, lineWidth: 0.5)
        )

        .cornerRadius(10)
    }
}

struct UserDietesScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Do you follow any of these dietes?")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.typographyPrimary)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    ForEach(Diet.allCases, id: \.self) { diet in
                        Button(action: {
                            // Используем метод saveGoal для сохранения значения
                            viewModel.saveDiet(diet)
                        }) {
                            UserDietOptionView(diet: diet, isSelected: viewModel.diet == diet)
                        }
                        .padding(.horizontal)
                    }
                }
                
                
                Spacer()
                
                CustomButton(
                    title: "Next",
                    state: viewModel.diet != nil ? .normal : .disabled,
                    destination: AnyView(WorkoutDaysScreen(viewModel: viewModel, currentStep: .constant(7)))
                )
                .padding()
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .customBackButton()
        }
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserDietesScreen(viewModel: viewModel, currentStep: .constant(6))
}
