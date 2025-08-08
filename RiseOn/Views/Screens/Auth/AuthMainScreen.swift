//
//  AuthMainScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

struct AuthMainScreen: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var authCoordinator: AuthCoordinator
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 6) {
                Text("Join RiseOn")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Save progress and sync across devices")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            // Social login buttons
            VStack(spacing: 15) {
                // Apple Sign In
                Button {
                    handleAppleSignIn()
                } label: {
                    HStack(spacing: 12) {
                        Image("apple")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                        
                        Text("Continue with Apple")
                            .font(.footnote)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(8)
                }
                
                // Google Sign In
                Button {
                    handleGoogleSignIn()
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .background(Color.white)
                                .frame(width: 18, height: 18)
                            
                            Image("google")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                                .colorInvert()
                        }
                        
                        Text("Continue with Google")
                            .font(.footnote)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.white)
                    .cornerRadius(8)
                }
                
                // Email buttons
                HStack(spacing: 8) {
                    Button {
                        authCoordinator.navigate(to: .emailSignIn)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 12))
                            
                            Text("Sign In")
                                .font(.footnote)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.card)
                        .cornerRadius(8)
                    }
                    
                    Button {
                        authCoordinator.navigate(to: .emailSignUp)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 12))
                            
                            Text("Sign Up")
                                .font(.footnote)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.primaryButton.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primaryButton.opacity(0.5), lineWidth: 1)
                        )
                        .cornerRadius(8)
                    }
                }
            }
            
            // Guest mode
            VStack(spacing: 8) {
                Button {
                    handleGuestMode()
                } label: {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 14))
                            .foregroundColor(.primaryButton)
                        
                        Text("Continue as Guest")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.primaryButton)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primaryButton.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                Button {
                    appCoordinator.showAuthSheet = false
                } label: {
                    Text("Maybe Later")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            // Terms
            Text("By continuing, you agree to our **Terms** and **Privacy Policy**")
                .font(.caption2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    // MARK: - Auth Methods
    func handleAppleSignIn() {
        appCoordinator.login()
    }
    
    func handleGoogleSignIn() {
        appCoordinator.login()
    }
    
    func handleGuestMode() {
        appCoordinator.showAuthSheet = false
        appCoordinator.login()
    }
}
