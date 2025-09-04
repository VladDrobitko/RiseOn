//
//  AboutUserScreen.swift
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
    
    // Validation states
    @State private var nameError: String? = nil
    @State private var ageError: String? = nil
    @State private var heightError: String? = nil
    @State private var weightError: String? = nil
    @State private var targetWeightError: String? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sectionSpacing) {
                    // User Info Section
                    userInfoSection
                    
                    // Gender Selection
                    genderSelectionSection
                    
                    // Age Input
                    ageInputSection
                    
                    // Weight and Height
                    measurementSection
                    
                    Spacer(minLength: 120) // Space for bottom button
                }
                .padding(DesignTokens.Padding.screen)
            }
            .background(Color.black)
            .onAppear {
                loadUserData()
                checkButtonState()
            }
            .onDisappear {
                saveUserData()
            }
        }
        .keyboardToolbar()
    }
}

// MARK: - UI Sections
extension AboutUserScreen {
    
    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("What is your name?")
                .riseOnHeading3()
                .foregroundColor(.typographyPrimary)
            
            RiseOnTextField(
                text: $viewModel.name,
                placeholder: "Enter your name",
                errorMessage: nameError,
                leadingIcon: "person"
            )
            .onChange(of: viewModel.name) { _, _ in
                validateName()
                checkButtonState()
            }
        }
    }
    
    private var genderSelectionSection: some View {
        HStack {
            Text("Your gender")
                .riseOnHeading3()
                .foregroundColor(.typographyPrimary)
            
            Spacer()
            
            CompactGenderSegmentedControl(selectedGender: Binding(
                get: { viewModel.gender! },
                set: { gender in
                    viewModel.saveGender(gender)
                    checkButtonState()
                }
            ))
        }
    }
    
    private var ageInputSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("How old are you?")
                .riseOnHeading3()
                .foregroundColor(.typographyPrimary)
            
            RiseOnTextField(
                text: $ageText,
                placeholder: "Enter your age",
                keyboardType: .numberPad,
                errorMessage: ageError,
                helperText: "years",
                leadingIcon: "calendar"
            )
            .onChange(of: ageText) { _, _ in
                validateAge()
                checkButtonState()
            }
        }
    }
    
    private var measurementSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            HStack {
                Text("Your measurements")
                    .riseOnHeading3()
                    .foregroundColor(.typographyPrimary)
                
                Spacer()
                
                // Unit Toggle (using existing SegmentedControl)
                SegmentedControl(selectedUnit: $viewModel.selectedUnit)
                    .onChange(of: viewModel.selectedUnit) { _, _ in
                        checkButtonState()
                    }
            }
            
            VStack(spacing: DesignTokens.Spacing.lg) {
                MeasurementTextField(
                    title: "Height",
                    text: $heightText,
                    unit: viewModel.selectedUnit == .metric ? "cm" : "ft",
                    placeholder: "Your height",
                    errorMessage: heightError
                )
                .onChange(of: heightText) { _, _ in
                    validateHeight()
                    checkButtonState()
                }
                
                MeasurementTextField(
                    title: "Current Weight",
                    text: $weightText,
                    unit: viewModel.selectedUnit == .metric ? "kg" : "lbs",
                    placeholder: "Your weight",
                    errorMessage: weightError
                )
                .onChange(of: weightText) { _, _ in
                    validateWeight()
                    checkButtonState()
                }
                
                MeasurementTextField(
                    title: "Target Weight",
                    text: $targetWeightText,
                    unit: viewModel.selectedUnit == .metric ? "kg" : "lbs",
                    placeholder: "Your target weight",
                    errorMessage: targetWeightError
                )
                .onChange(of: targetWeightText) { _, _ in
                    validateTargetWeight()
                    checkButtonState()
                }
            }
        }
    }
}

// MARK: - Compact Gender Segmented Control
struct CompactGenderSegmentedControl: View {
    @Binding var selectedGender: Gender
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(Gender.allCases, id: \.self) { gender in
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Image(gender == .male ? "iconBoy" : "iconGirl")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16)
                        .foregroundColor(selectedGender == gender ? .white : .typographyGrey)
                    
                    Text(gender.description)
                        .riseOnCaption(.medium)
                        .foregroundColor(selectedGender == gender ? .white : .typographyGrey)
                }
                .padding(.horizontal, DesignTokens.Spacing.sm)
                .padding(.vertical, DesignTokens.Spacing.xs)
                .background {
                    if selectedGender == gender {
                        LinearGradient.gradientDarkGreen
                    } else {
                        Color.clear
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedGender = gender
                    }
                }
            }
        }
        .padding(2)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm))
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                .stroke(Color.typographyGrey.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Validation Methods
extension AboutUserScreen {
    
    private func validateName() {
        nameError = FormValidation.validateName(viewModel.name) ? nil : "Name is required"
    }
    
    private func validateAge() {
        ageError = FormValidation.validateAge(ageText) ? nil : "Age must be between 10-130"
    }
    
    private func validateHeight() {
        heightError = FormValidation.validateHeight(heightText) ? nil : "Height must be between 30-250 cm"
    }
    
    private func validateWeight() {
        weightError = FormValidation.validateWeight(weightText) ? nil : "Weight must be between 20-400 kg"
    }
    
    private func validateTargetWeight() {
        targetWeightError = FormValidation.validateTargetWeight(targetWeightText) ? nil : "Target weight must be between 30-400 kg"
    }
    
    private func checkButtonState() {
        let name = viewModel.name.trimmingCharacters(in: .whitespaces)
        let age = ageText.trimmingCharacters(in: .whitespaces)
        let height = heightText.trimmingCharacters(in: .whitespaces)
        let weight = weightText.trimmingCharacters(in: .whitespaces)
        let targetWeight = targetWeightText.trimmingCharacters(in: .whitespaces)
        
        let hasAllFields = !name.isEmpty && !age.isEmpty && !height.isEmpty && !weight.isEmpty && !targetWeight.isEmpty && viewModel.gender != nil
        
        let hasNoErrors = nameError == nil &&
                         ageError == nil &&
                         heightError == nil &&
                         weightError == nil &&
                         targetWeightError == nil
        
        let newState = !(hasAllFields && hasNoErrors)
        
        if isNextButtonDisabled != newState {
            isNextButtonDisabled = newState
        }
        
        viewModel.canProceedFromCurrentStep = !isNextButtonDisabled
    }
    
    private func loadUserData() {
        ageText = viewModel.age.map { String($0) } ?? ""
        heightText = viewModel.height.map { String($0) } ?? ""
        weightText = viewModel.weight.map { String($0) } ?? ""
        targetWeightText = viewModel.targetWeight.map { String($0) } ?? ""
        
        DispatchQueue.main.async {
            self.checkButtonState()
        }
    }
    
    private func saveUserData() {
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
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    
    return AboutUserScreen(viewModel: viewModel, currentStep: .constant(2))
        .background(Color.black)
        .preferredColorScheme(.dark)
}

