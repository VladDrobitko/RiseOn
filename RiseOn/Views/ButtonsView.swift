//
//  ButtonsView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 01/02/2025.
//

import SwiftUI

// MARK: - Button States
enum ButtonState {
    case normal, hover, focused, disabled
    
    var backgroundColor: Color {
        switch self {
        case .normal: return Color.primaryButton
        case .hover: return Color.hoverButton
        case .focused: return Color.focusedButton
        case .disabled: return Color.disabledButton
        }
    }
}

// MARK: - Custom Button with Animation
struct CustomButton: View {
    let title: String
    @State private var isHovered = false
    var state: ButtonState = .normal
    var destination: AnyView // Параметр для передачи экрана назначения
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .padding()
                .frame(maxWidth: .infinity)
                .background(state.backgroundColor)
                .foregroundColor(state == .disabled ? Color.disabled : Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .contentShape(Rectangle()) // Делаем всю кнопку кликабельной
                .scaleEffect(isHovered ? 1.05 : 1.0) // Легкое увеличение при наведении
                .animation(.easeInOut(duration: 0.2), value: isHovered)
        }
        .disabled(state == .disabled)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}


// MARK: - Animated Toggle Switch
struct CustomToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 50, height: 30)
                .foregroundColor(isOn ? Color.primaryButton : Color.gray)
                .animation(.easeInOut(duration: 0.2), value: isOn)
            
            Circle()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.white)
                .offset(x: isOn ? 10 : -10)
                .animation(.spring(), value: isOn)
        }
        .onTapGesture {
            isOn.toggle()
        }
    }
}

// MARK: - Animated Radio Button
struct RadioButton: View {
    let title: String
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Circle()
                .stroke(isSelected ? Color.primaryButton : Color.gray, lineWidth: 2)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle()
                        .fill(isSelected ? Color.primaryButton : Color.clear)
                        .frame(width: 12, height: 12)
                )
                .animation(.easeInOut(duration: 0.2), value: isSelected)
            
            Text(title)
                .foregroundColor(.white)
        }
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

// MARK: - Animated Checkbox
struct Checkbox: View {
    @Binding var isChecked: Bool

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(isChecked ? Color.primaryButton : Color.clear) // Заливка при активации
                .frame(width: 24, height: 24) // Увеличил размер для удобства нажатия
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isChecked ? Color.primaryButton : Color.typographyDisabled, lineWidth: 2) // Граница чекбокса
                )
                .overlay(
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12) // Иконка меньше чекбокса
                        .foregroundColor(Color.typographyDisabled) // Оставляем цвет неизменным
                        .opacity(isChecked ? 1 : 0) // Плавное появление
                        .animation(.easeInOut(duration: 0.2), value: isChecked)
                )

            Text("Check me")
                .foregroundColor(.white)
        }
        .onTapGesture {
            isChecked.toggle()
        }
    }
}


// MARK: - Animated Tab Button
struct TabButton: View {
    let title: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Text(title)
            .padding()
            .frame(width: 100)
            .background(isSelected ? LinearGradient.gradientDarkGreen : LinearGradient.gradientDarkGrey)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(isSelected ? Color.primaryButton : Color.typographyDisabled, lineWidth: 1) // Граница чекбокса
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .animation(.spring(), value: isSelected)
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

// MARK: - Animated Selection Card
struct SelectionCard: View {
    let title: String
    let subtitle: String
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack { // Добавляем HStack, чтобы выровнять текст влево
            VStack(alignment: .leading) { // Меняем alignment на .leading
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.typographyGrey)
            }
            Spacer() // Раздвигает элементы, текст уходит влево
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(isSelected ? LinearGradient.gradientDarkGreen : LinearGradient.gradientDarkGrey)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.primaryButton : Color.typographyDisabled, lineWidth: 1) // Граница чекбокса
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

struct SegmentedControl: View {
    enum UnitType: String {
        case imperial = "lbs/ft"
        case metric = "kg/cm"
    }
    
    @Binding var selectedUnit: UnitType
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach([UnitType.imperial, UnitType.metric], id: \.self) { unit in
                Text(unit.rawValue)
                    .font(.subheadline)
                    .foregroundColor(selectedUnit == unit ? .white : .typographyGrey)
                    .frame(maxWidth: .infinity, minHeight: 32) // Гибкая ширина
                    .background(selectedUnit == unit ? LinearGradient.gradientDarkGreen : LinearGradient.gradientDarkGrey)
                    .clipShape(Capsule()) // Скругление
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedUnit = unit
                        }
                    }
            }
        }
        .clipShape(Capsule()) // Общая форма
        .overlay(
            Capsule()
                .stroke(Color.typographyGrey, lineWidth: 0.3) // Граница
        )
        .frame(width: 120, height: 32) // Фиксированный размер, можно убрать для гибкости
    }
}




// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


