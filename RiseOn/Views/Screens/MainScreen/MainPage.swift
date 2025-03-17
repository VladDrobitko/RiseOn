//
//  MainPage.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 16/02/2025.
//

import SwiftUI

struct MainPage: View {
    @EnvironmentObject var viewModel: MainViewModel
    @EnvironmentObject var coordinator: AppCoordinator  // Добавляем доступ к координатору
    @State private var showResetConfirmation = false    // Состояние для показа подтверждения
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Главная страница")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                // Ваше основное содержимое
                Spacer()
                
                // Кнопка для сброса всех данных
                Button {
                    showResetConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise.circle")
                        Text("Сбросить все данные")
                    }
                    .foregroundColor(.red)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 1)
                            .background(Color.black.opacity(0.3))
                    )
                }
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Главная")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Сбросить данные?", isPresented: $showResetConfirmation) {
                Button("Отмена", role: .cancel) {}
                Button("Сбросить", role: .destructive) {
                    // Сбрасываем все данные и возвращаемся к начальному экрану
                    coordinator.resetAppState()
                }
            } message: {
                Text("Это действие удалит все ваши данные и вернет приложение к начальному состоянию. Вам нужно будет пройти авторизацию и опрос заново.")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    // Для превью нам нужно предоставить две зависимости
    let mainViewModel = MainViewModel()
    let coordinator = AppCoordinator()
    
    return MainPage()
        .environmentObject(mainViewModel)
        .environmentObject(coordinator)
        .preferredColorScheme(.dark)
}
