//
//  WorkoutDaysScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct WorkoutDaysScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationStack {
            Text("Workout")
            CustomButton(title: "Go", state: .normal, destination: AnyView(SurveyResult(viewModel: viewModel, currentStep: .constant(8))))
        }
        .navigationBarBackButtonHidden(true)
        .customBackButton()
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return WorkoutDaysScreen(viewModel: viewModel, currentStep: .constant(7))
}
