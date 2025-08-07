//
//  AuthCoordinator.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

// Enum для всех экранов авторизации
enum AuthScreen {
    case main           // Основной экран с социальными логинами
    case emailSignIn    // Вход с email
    case emailSignUp    // Регистрация с email
    case forgotPassword // Восстановление пароля
}

// Координатор для управления навигацией внутри авторизации
class AuthCoordinator: ObservableObject {
    @Published var currentScreen: AuthScreen = .main
    @Published var isAnimating = false
    
    // Переход к экрану с анимацией
    func navigate(to screen: AuthScreen, direction: TransitionDirection = .forward) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = screen
        }
    }
    
    // Возврат на главный экран
    func goBack() {
        navigate(to: .main, direction: .backward)
    }
}

// Направление анимации
enum TransitionDirection {
    case forward, backward
}
