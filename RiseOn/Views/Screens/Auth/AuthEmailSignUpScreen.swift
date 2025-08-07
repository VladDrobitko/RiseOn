//
//  AuthEmailSignUpScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

struct AuthEmailSignUpScreen: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var authCoordinator: AuthCoordinator
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with back button
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
                    Text("Sign Up")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Create your account")
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
                                .stroke(email.isEmpty ? Color.clear : (isValidEmail ? Color.primaryButton.opacity(0.3) : Color.red.opacity(0.3)), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    SecureField("Create a password", text: $password)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(Color.card)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .textContentType(.newPassword)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(password.isEmpty ? Color.clear : (isValidPassword ? Color.primaryButton.opacity(0.3) : Color.red.opacity(0.3)), lineWidth: 1)
                        )
                    
                    if !password.isEmpty && !isValidPassword {
                        Text("Password must be at least 6 characters")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    SecureField("Confirm your password", text: $confirmPassword)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(Color.card)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .textContentType(.newPassword)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(confirmPassword.isEmpty ? Color.clear : (passwordsMatch ? Color.primaryButton.opacity(0.3) : Color.red.opacity(0.3)), lineWidth: 1)
                        )
                    
                    if !confirmPassword.isEmpty && !passwordsMatch {
                        Text("Passwords don't match")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            // Sign up button
            Button {
                handleSignUp()
            } label: {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .scaleEffect(0.8)
                    } else {
                        Text("Create Account")
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
            
            Spacer()
            
            // Switch to sign in
            HStack {
                Text("Already have an account?")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Button {
                    authCoordinator.navigate(to: .emailSignIn)
                } label: {
                    Text("Sign In")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.primaryButton)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    // MARK: - Computed Properties
    private var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }
    
    private var isValidPassword: Bool {
        password.count >= 6
    }
    
    private var passwordsMatch: Bool {
        password == confirmPassword
    }
    
    private var isFormValid: Bool {
        isValidEmail && isValidPassword && passwordsMatch
    }
    
    // MARK: - Methods
    private func handleSignUp() {
        guard isFormValid else { return }
        
        errorMessage = ""
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isLoading = false
            
            // Simple validation (replace with real auth)
            if email.lowercased() == "existing@test.com" {
                withAnimation {
                    errorMessage = "An account with this email already exists"
                }
            } else {
                appCoordinator.login()
            }
        }
    }
}
