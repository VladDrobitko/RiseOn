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
            Text("About User Screen")
            CustomButton(title: "Go", state: .normal, destination: AnyView(UserGoalScreen(viewModel: viewModel, currentStep: .constant(3))))
        }
        .navigationBarBackButtonHidden(true)
        .customBackButton()
    }
}


#Preview {
    let viewModel = SurveyViewModel()
    return AboutUserScreen(viewModel: viewModel, currentStep: .constant(2))
}
