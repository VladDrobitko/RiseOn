//
//  StartScreenView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 03/02/2025.
//

import SwiftUI

struct StartScreenView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Start")
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
                                
                                Text("Create your account to get a personalized plan.")
                                    .font(.title2)
                                    .foregroundStyle(.typographyPrimary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        CustomButton(title: "Create", state: .normal, destination: AnyView(SurveyView()))
                        .padding(20)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}


#Preview {
    StartScreenView()
}
