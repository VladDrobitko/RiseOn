//
//  WelcomeToSurvey.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct WelcomeToSurvey: View {
    
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Welcom ro Riseon!")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        Image("logoRiseOn")
                    }
                    .padding(.top, 70)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Welcome to RiseOn!")
                                    .font(.largeTitle)
                                    .foregroundStyle(.typographyPrimary)
                                
                                Text("We will ask you some questions to better help you achieve your goal.")
                                    .font(.title2)
                                    .foregroundStyle(.typographyPrimary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            
                        }
                        .frame(maxWidth: .infinity)
                        CustomButton(title: "Let's start!", state: .normal, destination: AnyView(AboutUserScreen(viewModel: viewModel, currentStep: .constant(2))))
                            .padding(20)
                    }
                    .padding(.bottom, 60)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .customBackButton()
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return WelcomeToSurvey(viewModel: viewModel, currentStep: .constant(1))
}
