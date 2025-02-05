//
//  UserGoalScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserGoalScreen: View {
    @State private var selectedGoal: Goal? = nil
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationStack {
            Text("Goal screen")
            CustomButton(title: "Go", state: .normal, destination: AnyView(UserLevelScreen(viewModel: viewModel, currentStep: .constant(4))))
        }
        .navigationBarBackButtonHidden(true)
        .customBackButton()
    }
}


#Preview {
    let viewModel = SurveyViewModel()
    return UserGoalScreen(viewModel: viewModel, currentStep: .constant(3))
}
