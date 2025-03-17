//
//  AboutUserScreen 3.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 13/03/2025.
//


import SwiftUI

struct AboutUserScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    @State private var ageText: String = ""
    @State private var heightText: String = ""
    @State private var weightText: String = ""
    @State private var targetWeightText: String = ""
    
    @State private var isNextButtonDisabled = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    userInfoSection
                    genderSelection
                    userAgeInput
                    weightAndHeightInput
                    Spacer(minLength: 100) // Увеличиваем минимальный spacer чтобы контент не прижимался к нижней кнопке
                }
                .padding()
                .background(Color.black) // Дублируем фон для уверенности
            }
            .modifier(KeyboardAdaptive())
            .background(Color.black) // Дублируем фон чтобы убедиться, что ScrollView виден
            .onAppear {
                print("AboutUserScreen appeared")
                loadUserData()
                
                // Принудительное обновление состояния кнопки после небольшой задержки
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    checkButtonState()
                    print("Button state on appear: \(isNextButtonDisabled)")
                    print("Can proceed: \(!isNextButtonDisabled)")
                }
            }
            .onDisappear {
                print("AboutUserScreen disappeared")
                saveUserData()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - UI Sections
extension AboutUserScreen {
    private var userInfoSection: some View {
        VStack(alignment: .leading) {
            titleText("What is your name?")
            AboutUserTextField(title: "", text: $viewModel.name, placeholder: "Enter your name")
                .onChange(of: viewModel.name) { _, newValue in
                    print("Name changed to: \(newValue)")
                    checkButtonState()
                }
        }
    }
    
    private var genderSelection: some View {
        VStack(alignment: .leading, spacing: 15) {
            titleText("Your gender?")
            HStack {
                ForEach(Gender.allCases, id: \.self) { gender in
                    TabButton(
                        title: gender.description,
                        iconName: gender == .male ? "iconBoy" : "iconGirl",
                        isSelected: .init(
                            get: { viewModel.gender == gender },
                            set: {
                                if $0 {
                                    print("Gender selected: \(gender)")
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
    }
    
    private var userAgeInput: some View {
        VStack(alignment: .leading) {
            titleText("How old are you?")
            numberTextField(text: $ageText, placeholder: "Enter your age", unit: nil)
                .onChange(of: ageText) { _, newValue in
                    print("Age changed: \(newValue)")
                }
        }
    }
    
    private var weightAndHeightInput: some View {
        VStack(alignment: .leading, spacing: 15) {
            titleText("Your weight and height")
            SegmentedControl(selectedUnit: $viewModel.selectedUnit)
                .padding(.horizontal)
                .onChange(of: viewModel.selectedUnit) { _, _ in
                    print("Unit changed to: \(viewModel.selectedUnit)")
                }
            
            numberTextField(text: $heightText, placeholder: "Your height", unit: viewModel.selectedUnit == .metric ? "cm" : "ft")
                .onChange(of: heightText) { _, newValue in
                    print("Height changed: \(newValue)")
                }
            
            numberTextField(text: $weightText, placeholder: "Your weight", unit: viewModel.selectedUnit == .metric ? "kg" : "lbs")
                .onChange(of: weightText) { _, newValue in
                    print("Weight changed: \(newValue)")
                }
            
            numberTextField(text: $targetWeightText, placeholder: "Your target weight", unit: viewModel.selectedUnit == .metric ? "kg" : "lbs")
                .onChange(of: targetWeightText) { _, newValue in
                    print("Target weight changed: \(newValue)")
                }
        }
    }
}

// MARK: - Helpers
extension AboutUserScreen {
    private func titleText(_ text: String) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.light)
            .foregroundStyle(.typographyPrimary)
            .padding(.horizontal)
    }
    
    private func numberTextField(text: Binding<String>, placeholder: String, unit: String?) -> some View {
        AboutUserTextField(title: "", text: text, placeholder: placeholder, keyboardType: .decimalPad)
            .overlay(
                HStack {
                    Spacer()
                    if let unit = unit {
                        Text(unit)
                            .foregroundColor(.gray)
                            .padding(.trailing, 40)
                    }
                }
            )
            .onChange(of: text.wrappedValue) { _, newValue in
                let correctedValue = newValue.replacingOccurrences(of: ",", with: ".")
                if correctedValue != newValue {
                    text.wrappedValue = correctedValue
                }
                checkButtonState()
            }
    }
    
    private func checkButtonState() {
        let name = viewModel.name
        let age = ageText.trimmingCharacters(in: .whitespaces)
        let height = heightText.trimmingCharacters(in: .whitespaces)
        let weight = weightText.trimmingCharacters(in: .whitespaces)
        let targetWeight = targetWeightText.trimmingCharacters(in: .whitespaces)
        
        print("Checking fields - Name: '\(name)', Age: '\(age)', Height: '\(height)', Weight: '\(weight)', Target: '\(targetWeight)'")
        
        let newState = name.isEmpty ||
                      age.isEmpty ||
                      height.isEmpty ||
                      weight.isEmpty ||
                      targetWeight.isEmpty ||
                      viewModel.gender == nil
        
        if isNextButtonDisabled != newState {
            isNextButtonDisabled = newState
            print("Button state updated to: \(isNextButtonDisabled)")
        }
        
        // Всегда обновляем значение в viewModel
        viewModel.canProceedFromCurrentStep = !isNextButtonDisabled
        print("Can proceed updated to: \(!isNextButtonDisabled)")
    }
    
    private func loadUserData() {
        print("Loading user data")
        ageText = viewModel.age.map { String($0) } ?? ""
        heightText = viewModel.height.map { String($0) } ?? ""
        weightText = viewModel.weight.map { String($0) } ?? ""
        targetWeightText = viewModel.targetWeight.map { String($0) } ?? ""
        
        print("Loaded data - Age: '\(ageText)', Height: '\(heightText)', Weight: '\(weightText)', Target: '\(targetWeightText)'")
        print("Current gender: \(String(describing: viewModel.gender))")
        
        // При загрузке данных проверяем состояние кнопки
        DispatchQueue.main.async {
            self.checkButtonState()
        }
    }
    
    private func saveUserData() {
        print("Saving user data")
        if let age = Int(ageText) {
            viewModel.age = age
        }
        
        if let height = Double(heightText) {
            viewModel.height = height
        }
        
        if let weight = Double(weightText) {
            viewModel.weight = weight
        }
        
        if let targetWeight = Double(targetWeightText) {
            viewModel.targetWeight = targetWeight
        }
        
        print("Saved data - Age: \(String(describing: viewModel.age)), Height: \(String(describing: viewModel.height)), Weight: \(String(describing: viewModel.weight)), Target: \(String(describing: viewModel.targetWeight))")
    }
}

#Preview {
    // Создаём viewModel
    let viewModel = SurveyViewModel()
    
    // Создаём привязку для currentStep
    AboutUserScreen(viewModel: viewModel, currentStep: .constant(2))
        .background(Color.black)
        .preferredColorScheme(.dark)
}


