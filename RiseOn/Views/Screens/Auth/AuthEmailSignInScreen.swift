//
//  AuthEmailSignInScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

struct AuthEmailSignInScreen: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var authCoordinator: AuthCoordinator
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with back button - фиксированный сверху
            HStack {
                Button {
                    authCoordinator.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Sign In")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Welcome back!")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.top, 25)
                
                Spacer()
                
                // Invisible button for balance
                Button {} label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.clear)
                }
                .disabled(true)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 16)
            
            // Основной контент в центре
            VStack(spacing: 20) {
                // Error message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .transition(.opacity)
                }
                
                // Form
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        TextField("Enter your email", text: $email)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(Color.card)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(email.isEmpty ? Color.clear : Color.primaryButton.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        SecureField("Enter your password", text: $password)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(Color.card)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .textContentType(.password)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(password.isEmpty ? Color.clear : Color.primaryButton.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Forgot password link
                    HStack {
                        Spacer()
                        Button {
                            authCoordinator.navigate(to: .forgotPassword)
                        } label: {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .foregroundColor(.primaryButton)
                        }
                    }
                }
                
                // Sign in button
                Button {
                    handleSignIn()
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .scaleEffect(0.8)
                        } else {
                            Text("Sign In")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(isFormValid ? Color.primaryButton : Color.disabledButton)
                    .cornerRadius(12)
                }
                .disabled(!isFormValid || isLoading)
            }
            .padding(.horizontal, 16)
            
            Spacer() // Отталкивает нижний контент вниз
            
            // Switch to sign up - фиксированный снизу
            HStack {
                Text("Don't have an account?")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Button {
                    authCoordinator.navigate(to: .emailSignUp)
                } label: {
                    Text("Sign Up")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.primaryButton)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        !email.isEmpty && email.contains("@") && password.count >= 6
    }
    
    // MARK: - Methods
    private func handleSignIn() {
        guard isFormValid else { return }
        
        errorMessage = ""
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            // Simple validation (replace with real auth)
            if email.lowercased() == "test@test.com" && password == "123456" {
                appCoordinator.login()
            } else {
                withAnimation {
                    errorMessage = "Invalid email or password"
                }
            }
        }
    }
}
