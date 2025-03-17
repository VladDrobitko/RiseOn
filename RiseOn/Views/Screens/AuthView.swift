//
//  AuthView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 17/03/2025.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.card)
                .cornerRadius(8)
                .foregroundColor(.white)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.card)
                .cornerRadius(8)
                .foregroundColor(.white)
            
            CustomButton(
                title: "Continue",
                state: .normal
            ) {
                // Симулируем успешную авторизацию
                coordinator.login()
            }
            
            Button {
                // Закрываем sheet
                coordinator.showAuthSheet = false
            } label: {
                Text("Cancel")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ограничиваем размер
        .background(Color.black)
    }
}

#Preview {
    AuthView()
        .environmentObject(AppCoordinator())
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
}
