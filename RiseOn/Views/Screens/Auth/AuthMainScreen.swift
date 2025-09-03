//
//  AuthMainScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

struct AuthMainScreen: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var authCoordinator: AuthCoordinator
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            // Header
            headerSection
            
            // Social login buttons
            socialLoginSection
            
            // Guest mode
            guestModeSection
            
            // Terms
            termsSection
        }
        .padding(.horizontal, DesignTokens.Padding.screen)
        .padding(.top, DesignTokens.Spacing.lg)
    }
}

// MARK: - Header Section
extension AuthMainScreen {
    private var headerSection: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Text("Join RiseOn")
                .riseOnHeading2()
                .foregroundColor(.typographyPrimary)
            
            Text("Save progress and sync across devices")
                .riseOnCaption()
                .foregroundColor(.typographyGrey)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Social Login Section
extension AuthMainScreen {
    private var socialLoginSection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            // Apple Sign In
            SocialLoginButton(
                title: "Continue with Apple",
                icon: "apple",
                style: .dark
            ) {
                handleAppleSignIn()
            }
            
            // Google Sign In
            SocialLoginButton(
                title: "Continue with Google",
                icon: "google",
                style: .light
            ) {
                handleGoogleSignIn()
            }
            
            // Email buttons
            HStack(spacing: DesignTokens.Spacing.sm) {
                RiseOnButton.secondary("Sign In", size: .medium) {
                    authCoordinator.navigate(to: .emailSignIn)
                }
                
                RiseOnButton(
                    "Sign Up",
                    style: .secondary,
                    size: .medium
                ) {
                    authCoordinator.navigate(to: .emailSignUp)
                }
            }
        }
    }
}

// MARK: - Social Login Button Component
struct SocialLoginButton: View {
    let title: String
    let icon: String
    let style: Style
    let action: () -> Void
    
    enum Style {
        case dark, light
        
        var backgroundColor: Color {
            switch self {
            case .dark: return .black
            case .light: return .white
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .dark: return .white
            case .light: return .black
            }
        }
        
        var borderColor: Color {
            switch self {
            case .dark: return .white.opacity(0.3)
            case .light: return .clear
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                
                Text(title)
                    .riseOnBodySmall(.medium)
            }
            .foregroundColor(style.foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: DesignTokens.Size.button)
            .background(style.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                    .stroke(style.borderColor, lineWidth: 1)
            )
            .cornerRadius(DesignTokens.Radius.button)
        }
    }
}

// MARK: - Guest Mode Section
extension AuthMainScreen {
    private var guestModeSection: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            RiseOnCard(style: .outlined, size: .compact, onTap: handleGuestMode) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: DesignTokens.Sizes.iconSmall))
                        .foregroundColor(.primaryButton)
                    
                    Text("Continue as Guest")
                        .riseOnBodySmall(.medium)
                        .foregroundColor(.primaryButton)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10))
                        .foregroundColor(.typographyGrey)
                }
            }
            
            RiseOnButton.ghost("Maybe Later", size: .small) {
                appState.showAuthSheet = false
            }
        }
    }
}

// MARK: - Terms Section
extension AuthMainScreen {
    private var termsSection: some View {
        Text("By continuing, you agree to our **Terms** and **Privacy Policy**")
            .riseOnCaption()
            .foregroundColor(.typographyGrey)
            .multilineTextAlignment(.center)
    }
}

// MARK: - Auth Methods
extension AuthMainScreen {
    func handleAppleSignIn() {
        withAnimation(.easeInOut(duration: DesignTokens.Animation.fast)) {
            appState.login()
        }
    }

    func handleGoogleSignIn() {
        withAnimation(.easeInOut(duration: DesignTokens.Animation.fast)) {
            appState.login()
        }
    }

    func handleGuestMode() {
        withAnimation(.easeInOut(duration: DesignTokens.Animation.fast)) {
            appState.login()
        }
    }
}

#Preview {
    let appState = AppState()
    let authCoordinator = AuthCoordinator()
    
    return AuthMainScreen(authCoordinator: authCoordinator)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .background(Color.black)
}
