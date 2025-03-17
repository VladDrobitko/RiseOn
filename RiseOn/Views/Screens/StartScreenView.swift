//
//  StartScreenView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 03/02/2025.
//

import SwiftUI

struct StartScreenView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
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
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    
                    CustomButton(
                        title: "Get Started",
                        state: .normal
                    ) {
                        // Открываем авторизацию как sheet
                        coordinator.markAppAsLaunched()
                        coordinator.showAuthSheet = true
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                .padding(.bottom, 60)
            }
        }
    }
}


#Preview {
    let coordinator = AppCoordinator()
    return StartScreenView()
        .environmentObject(coordinator)
        .preferredColorScheme(.dark)
}
