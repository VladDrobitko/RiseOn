//
//  AboutUserScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct AboutUserScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationStack {
            Spacer()
            VStack(alignment: .leading, spacing: 1) {
                Text("What is your name?")
                    .font(.title3)
                    .foregroundStyle(.typographyPrimary)
                    .padding(.horizontal)
                CustomTextField(
                    title: "",
                    text: $viewModel.name,
                    placeholder: "Enter your name")
                    .padding()
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("Your gender?")
                    .font(.title3)
                    .foregroundStyle(.typographyPrimary)
                HStack {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        TabButton(
                            title: gender.description,
                            iconName: gender == .male ? "iconBoy" : "iconGirl",
                            isSelected: Binding(
                                get: { viewModel.gender == gender },
                                set: { isSelected in
                                    if isSelected {
                                        viewModel.saveGender(gender)
                                    }
                                }
                            ),
                            cornerRadius: 15 // Используем меньшее скругление
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            Spacer()
            VStack(alignment: .leading, spacing: 1) {
                Text("How old are you?")
                    .font(.title3)
                    .foregroundStyle(.typographyPrimary)
                    .padding(.horizontal)
                CustomTextField(
                    title: "",
                    text: Binding(
                        get: { viewModel.age.map { String($0) } ?? "" }, // Преобразуем Int? в String
                        set: { viewModel.age = Int($0) } // Преобразуем String в Int
                    ),
                    placeholder: "Enter your age",
                    keyboardType: .numberPad
                )
                .padding()
            }
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Your height and weight")
                    .font(.title3)
                    .foregroundStyle(.typographyPrimary)
                    .padding(.horizontal)
                CustomTextField(
                    title: "",
                    text: Binding(
                        get: { viewModel.height.map { String($0) } ?? "" }, // Преобразуем Int? в String
                        set: { viewModel.height = Int($0) } // Преобразуем String в Int
                    ),
                    placeholder: "Enter your height",
                    keyboardType: .decimalPad
                )
                .padding(.horizontal)
                CustomTextField(
                    title: "",
                    text: Binding(
                        get: { viewModel.weight.map { String($0) } ?? "" }, // Преобразуем Int? в String
                        set: { viewModel.weight = Int($0) } // Преобразуем String в Int
                    ),
                    placeholder: "Enter your current weight",
                    keyboardType: .decimalPad
                )
                .padding(.horizontal)
                CustomTextField(
                    title: "",
                    text: Binding(
                        get: { viewModel.targetWeight.map { String($0) } ?? "" }, // Преобразуем Int? в String
                        set: { viewModel.targetWeight = Int($0) } // Преобразуем String в Int
                    ),
                    placeholder: "Enter your target weight",
                    keyboardType: .decimalPad
                )
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            Spacer()
            CustomButton(title: "Next", state: .normal, destination: AnyView(UserGoalScreen(viewModel: viewModel, currentStep: .constant(3))))
                .padding()
        }
        .navigationBarBackButtonHidden(true)
        .customBackButton()
    }
}


#Preview {
    let viewModel = SurveyViewModel()
    return AboutUserScreen(viewModel: viewModel, currentStep: .constant(2))
}
