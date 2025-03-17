//
//  WorkoutDaysScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct WorkoutDaysScreen: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    @State private var isNextButtonDisabled = true
    
    let totalSteps = 6
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Workout")
                    .foregroundStyle(.white)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
   
}

#Preview {
    let viewModel = SurveyViewModel()
    return WorkoutDaysScreen(viewModel: viewModel, currentStep: .constant(7))
}
