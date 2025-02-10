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
                    .foregroundColor(.primary) // Заменил .typographyPrimary на стандартный цвет
                    .padding(.horizontal)
                
                // Grid для отображения тегов
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 7) {
                    ForEach(Prefer.allCases, id: \.self) { type in
                        Button(action: {
                            viewModel.toggleSelection(for: type)
                        }) {
                            // Определяем фоны и цвета текста заранее, чтобы улучшить производительность
                            let isSelected = viewModel.selectedTrainingTypes.contains(type)
                            let textColor: Color = isSelected ? .white : .typographyPrimary
                            let borderColor: Color = isSelected ? Color.primaryButton : Color.gray
                            
                            Text(type.rawValue)
                                .font(.headline)
                                .fontWeight(.regular)
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .background( isSelected ? LinearGradient.gradientDarkGreen : nil )
                                .background( !isSelected ? Color.card : nil)
                                .foregroundColor(textColor)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(borderColor, lineWidth: 0.5)
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
            .background(Color.black.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .customBackButton()
        }
    }
}


                                        

#Preview {
    let viewModel = SurveyViewModel()
    return UserPreferScreen(viewModel: viewModel, currentStep: .constant(5))
}
