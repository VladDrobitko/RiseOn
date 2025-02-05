//
//  SurveyView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 05/02/2025.
//

import SwiftUI

struct SurveyView: View {
    @StateObject private var viewModel = SurveyViewModel()
    @State private var currentStep = 1

    var body: some View {
        VStack {
            if currentStep == 1 {
                WelcomeToSurvey(viewModel: viewModel, currentStep: $currentStep)
            } else if currentStep == 2 {
                AboutUserScreen(viewModel: viewModel, currentStep: $currentStep)
            } else if currentStep == 3 {
                UserGoalScreen(viewModel: viewModel, currentStep: $currentStep)
            }  else if currentStep == 4 {
                UserLevelScreen(viewModel: viewModel, currentStep: $currentStep)
            } else if currentStep == 5 {
                UserPreferScreen(viewModel: viewModel, currentStep: $currentStep)
            } else if currentStep == 6 {
                UserDietesScreen(viewModel: viewModel, currentStep: $currentStep)
            } else if currentStep == 7 {
                WorkoutDaysScreen(viewModel: viewModel, currentStep: $currentStep)
            } else {
                SurveyResult(viewModel: viewModel, currentStep: $currentStep)
            }
        }
    }
}


#Preview {
    SurveyView()
}
