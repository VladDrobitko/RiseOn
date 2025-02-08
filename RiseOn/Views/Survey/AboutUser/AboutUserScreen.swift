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
    
    @State private var ageText: String = ""
    @State private var heightText: String = ""
    @State private var weightText: String = ""
    @State private var targetWeightText: String = ""
    
    @State private var nameError: String? = nil
    @State private var ageError: String? = nil
    @State private var heightError: String? = nil
    @State private var weightError: String? = nil
    @State private var targetWeightError: String? = nil
    
    @State private var isNextButtonDisabled = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Ввод имени
                VStack(alignment: .leading) {
                    Text("What is your name?")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundStyle(.typographyPrimary)
                        .padding(.horizontal)
                    
                    AboutUserTextField(
                        title: "",
                        text: $viewModel.name,
                        placeholder: "Enter your name",
                        errorMessage: nameError
                    )
                    .onChange(of: viewModel.name) { newValue in
                        nameError = FormValidation.validateName(newValue) ? nil : "Name cannot be empty"
                        checkButtonState()
                    }
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Your gender?")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundStyle(.typographyPrimary)
                        .padding(.horizontal)
                    
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
                                            checkButtonState()
                                        }
                                    }
                                ),
                                cornerRadius: 20
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Ввод возраста
                VStack(alignment: .leading) {
                    Text("How old are you?")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundStyle(.typographyPrimary)
                        .padding(.horizontal)
                    
                    AboutUserTextField(
                        title: "",
                        text: $ageText,
                        placeholder: "Enter your age",
                        errorMessage: ageError, keyboardType: .numberPad
                    )
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                hideKeyboard()
                            }
                        }
                    }
                    .onChange(of: ageText) { newValue in
                        ageError = FormValidation.validateAge(newValue) ? nil : "Age must be between 10 and 130"
                        checkButtonState()
                    }
                }
                
                // Ввод роста и веса
                VStack(alignment: .leading, spacing: 15) {
                    Text("Your weight and height")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundStyle(.typographyPrimary)
                        .padding(.horizontal)
                    
                    SegmentedControl(selectedUnit: $viewModel.selectedUnit)
                            .padding(.horizontal)
                    
                    AboutUserTextField(
                        title: "",
                        text: $heightText,
                        placeholder: viewModel.selectedUnit == .metric ? "Your height" : "Your height",
                        errorMessage: heightError,
                        keyboardType: .decimalPad
                    )
                    .overlay(
                        HStack {
                            Spacer()
                            Text(viewModel.selectedUnit == .metric ? "cm" : "ft")
                                .foregroundColor(.gray)
                                .padding(.trailing, 40)
                        }
                    )
                    .onChange(of: heightText) { newValue in
                        let correctedValue = newValue.replacingOccurrences(of: ",", with: ".")
                        heightText = correctedValue
                        
                        if let value = Double(correctedValue) {
                            viewModel.height = viewModel.selectedUnit == .metric ? value : value * 30.48
                        }
                        
                        heightError = FormValidation.validateHeight(correctedValue) ? nil : "Invalid height"
                        checkButtonState()
                    }

                    
                    AboutUserTextField(
                        title: "",
                        text: $weightText,
                        placeholder: viewModel.selectedUnit == .metric ? "Your weight" : "Your weight",
                        errorMessage: weightError,
                        keyboardType: .decimalPad
                        
                    )
                    .overlay(
                        HStack {
                            Spacer()
                            Text(viewModel.selectedUnit == .metric ? "kg" : "lbs")
                                .foregroundColor(.gray)
                                .padding(.trailing, 40)
                        }
                    )
                    .onChange(of: weightText) { newValue in
                        let correctedValue = newValue.replacingOccurrences(of: ",", with: ".")
                        weightText = correctedValue
                        
                        if let value = Double(newValue) {
                            viewModel.weight = viewModel.selectedUnit == .metric ? value : value / 2.205
                        }
                        weightError = FormValidation.validateWeight(newValue) ? nil : "Invalid weight"
                        checkButtonState()
                    }
                    
                    AboutUserTextField(
                        title: "",
                        text: $targetWeightText,
                        placeholder: viewModel.selectedUnit == .metric ? "Your target weight" : "Your target weight",
                        errorMessage: targetWeightError,
                        keyboardType: .decimalPad
                    )
                    .overlay(
                        HStack {
                            Spacer()
                            Text(viewModel.selectedUnit == .metric ? "kg" : "lbs")
                                .foregroundColor(.gray)
                                .padding(.trailing, 40)
                        }
                    )
                    .onChange(of: targetWeightText) { newValue in
                        let correctedValue = newValue.replacingOccurrences(of: ",", with: ".")
                        targetWeightText = correctedValue
                        
                        if let value = Double(newValue) {
                            viewModel.targetWeight = viewModel.selectedUnit == .metric ? value : value / 2.205
                        }
                        targetWeightError = FormValidation.validateTargetWeight(newValue) ? nil : "Invalid weight"
                        checkButtonState()
                    }
                }
                
                Spacer()
                
                // Кнопка Next
                CustomButton(title: "Next", state: isNextButtonDisabled ? .disabled : .normal, destination: AnyView(UserGoalScreen(viewModel: viewModel, currentStep: .constant(3))))
                    .padding()
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .modifier(KeyboardAdaptive()) // Авто-подъем экрана при клавиатуре
        .navigationBarBackButtonHidden(true)
        .customBackButton()
        .onChange(of: viewModel.selectedUnit) { newUnit in
            if let height = viewModel.height {
                heightText = newUnit == .metric ? "\(Int(height))" : String(format: "%.1f", height / 30.48)
            }
            
            if let weight = viewModel.weight {
                weightText = newUnit == .metric ? "\(Int(weight))" : String(format: "%.1f", weight * 2.205)
            }
            if let targetWeight = viewModel.targetWeight {
                targetWeightText = newUnit == .metric ? "\(Int(targetWeight))" : String(format: "%.1f", targetWeight * 2.205)
            }
        }

        .onAppear {
            // Загружаем значения из ViewModel при входе на экран
            ageText = viewModel.age.map { String($0) } ?? ""
            heightText = viewModel.height.map { String($0) } ?? ""
            weightText = viewModel.weight.map { String($0) } ?? ""
            targetWeightText = viewModel.targetWeight.map { String($0) } ?? ""
        }
        .onDisappear {
            // Сохраняем изменения перед выходом
            viewModel.age = Int(ageText)
            viewModel.height = Double(heightText)
            viewModel.weight = Double(weightText)
            viewModel.targetWeight = Double(targetWeightText)
        }
    }
    
    private func checkButtonState() {
        // Проверяем, есть ли ошибки в полях, если есть - деактивируем кнопку
        isNextButtonDisabled = nameError != nil || ageError != nil || heightError != nil || weightError != nil || viewModel.name.isEmpty || ageText.isEmpty || heightText.isEmpty || weightText.isEmpty || targetWeightText.isEmpty
    }
}




#Preview {
    // Создаём viewModel
    let viewModel = SurveyViewModel()
    
    // Создаём привязку для currentStep
    AboutUserScreen(viewModel: viewModel, currentStep: .constant(2))
}


