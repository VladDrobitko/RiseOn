//
//  UserDietesScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserDietesScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationStack {
            Text("Your diet")
            CustomButton(title: "Go", state: .normal, destination: AnyView(WorkoutDaysScreen(viewModel: viewModel, currentStep: .constant(7))))
        }
        .navigationBarBackButtonHidden(true)
        .customBackButton()
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserDietesScreen(viewModel: viewModel, currentStep: .constant(6))
}
