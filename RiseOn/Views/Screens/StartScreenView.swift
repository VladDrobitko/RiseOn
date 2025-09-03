//
//  StartScreenView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 03/02/2025.
//

import SwiftUI

struct StartScreenView: View {
    @EnvironmentObject var appState: AppState
    
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
                
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Welcome to RiseOn!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.typographyPrimary)
                            
                            Text("Achieve your best shape with workouts and nutrition plans made just for you.")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundStyle(.typographyPrimary)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Preview что будет дальше
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            Image(systemName: "figure.run.circle.fill")
                                .font(.title2)
                                .foregroundColor(.primaryButton)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Personalized Training")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                Text("Plan that fits your goals & level")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 16) {
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.title2)
                                .foregroundColor(.primaryButton)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Smart Nutrition Guide")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                Text("Easy and tasty meals to fuel your progress")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                        
                        HStack(spacing: 16) {
                            Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                                .font(.title2)
                                .foregroundColor(.primaryButton)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Progress Tracking")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                Text("Track progress & stay motivated")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                    }
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                            )
                    )
                    .padding(.horizontal)
                    
                    CustomButton(
                        title: "Start Your Journey",
                        state: .normal
                    ) {
                        appState.markFirstLaunchCompleted()
                        
                    }
                    .padding(.horizontal)
                    
                    .padding(.bottom, 30)
                }
                .padding(.horizontal)
                .padding(.bottom, 60)
            }
        }
    }
}

#Preview {
   let appState = AppState()
   return StartScreenView()
       .environmentObject(appState)
       .preferredColorScheme(.dark)
}
