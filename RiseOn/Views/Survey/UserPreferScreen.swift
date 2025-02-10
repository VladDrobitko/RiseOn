//
//  UserPreferScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

struct UserPreferScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Select your preferred training types:")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.typographyPrimary)
                    .padding(.horizontal)
                
                // Grid для отображения тегов
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 7) {
                    ForEach(Prefer.allCases, id: \.self) { type in
                        Button(action: {
                            viewModel.toggleSelection(for: type)
                        }) {
                            Text(type.rawValue)
                                .font(.headline)
                                .fontWeight(.regular)
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .background(viewModel.selectedTrainingTypes.contains(type) ? LinearGradient.gradientDarkGreen : nil
                                .background(viewModel.selectedTrainingTypes.contains(type) ? Color.card : nil)
                                .foregroundColor(.typographyPrimary)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(viewModel.selectedTrainingTypes.contains(type) ? Color.primaryButton : Color.gray, lineWidth: 0.5)
                                )
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Кнопка "Далее" или "Сохранить"
                CustomButton(
                    title: "Next",
                    state: viewModel.selectedTrainingTypes.isEmpty ? .disabled : .normal,
                    destination: AnyView(UserDietesScreen(viewModel: viewModel, currentStep: .constant(6))) // Следующий экран
                )
                .padding()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .customBackButton()
        }
    }
}


#Preview {
    let viewModel = SurveyViewModel()
    return UserPreferScreen(viewModel: viewModel, currentStep: .constant(5))
}
