//
//  UserPreferScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserPreferScreen: View {
    
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationStack {
            Text("Preferences")
            CustomButton(title: "Go", state: .normal, destination: AnyView(UserDietesScreen(viewModel: viewModel, currentStep: .constant(6))))
        }
        .navigationBarBackButtonHidden(true)
        .customBackButton()
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return UserPreferScreen(viewModel: viewModel, currentStep: .constant(5))
}
