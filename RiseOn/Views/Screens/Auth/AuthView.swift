//
//  AuthView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var authCoordinator = AuthCoordinator()
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                switch authCoordinator.currentScreen {
                case .main:
                    AuthMainScreen(authCoordinator: authCoordinator)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                    
                case .emailSignIn:
                    AuthEmailSignInScreen(authCoordinator: authCoordinator)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    
                case .emailSignUp:
                    AuthEmailSignUpScreen(authCoordinator: authCoordinator)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    
                case .forgotPassword:
                    AuthForgotPasswordScreen(authCoordinator: authCoordinator)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authCoordinator.currentScreen)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Rectangle()
                            .fill(Color.black.opacity(0.2))
                    )
                    .ignoresSafeArea(.all) // Фон покрывает всю область включая safe area
            )
        }
    }
}

// MARK: - Forgot Password Screen (простой экран)
struct AuthForgotPasswordScreen: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var authCoordinator: AuthCoordinator
    @State private var email = ""
    @State private var isLoading = false
    @State private var isEmailSent = false
    
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
                    Text("Reset Password")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("We'll send you a link")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.top, 25)
                
                Spacer()
                
                Button {} label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.clear)
                }
                .disabled(true)
            }
            
            if isEmailSent {
                VStack(spacing: 16) {
                    Image(systemName: "envelope.badge.checkmark")
                        .font(.system(size: 48))
                        .foregroundColor(.primaryButton)
                    
                    Text("Email Sent!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Check your email for a password reset link")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        authCoordinator.navigate(to: .emailSignIn)
                    } label: {
                        Text("Back to Sign In")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(Color.primaryButton)
                            .cornerRadius(12)
                    }
                }
            } else {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.footnote)
                            .foregroundColor(.white)
                        
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
                    }
                    
                    Button {
                        handlePasswordReset()
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .scaleEffect(0.8)
                            } else {
                                Text("Send Reset Link")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(email.contains("@") ? Color.primaryButton : Color.disabledButton)
                        .cornerRadius(12)
                    }
                    .disabled(!email.contains("@") || isLoading)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private func handlePasswordReset() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            withAnimation {
                isEmailSent = true
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AppCoordinator())
            .preferredColorScheme(.dark)
            .frame(height: 400)
    }
}
