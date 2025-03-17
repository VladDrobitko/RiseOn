//
//  SplashScreenView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 13/03/2025.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    // Состояния для анимации
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            // Черный фон
            Color.black
                .ignoresSafeArea()
            
            // Логотип
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 125, height: 125)
                .opacity(opacity)
        }
        .onAppear {
            // Запускаем анимацию и переход через 1.5 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.interactiveSpring(duration: 0.3)) {
                    opacity = 0 // Логотип исчезает
                }
                
                // Вместо прямого переключения представления, используем координатор
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    coordinator.navigateToNextScreen()
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
