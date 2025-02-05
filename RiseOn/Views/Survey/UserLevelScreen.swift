//
//  UserLevelScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI
struct UserLevelScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int

    var body: some View {
        NavigationStack {
            VStack {
                Text("User level Screen")
                CustomButton(title: "Go", state: .normal, destination: AnyView(UserPreferScreen(viewModel: viewModel, currentStep: .constant(5))))
            }
        }
        .navigationBarBackButtonHidden(true)
        .customBackButton()
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserLevelScreen(viewModel: viewModel, currentStep: .constant(4))
}
