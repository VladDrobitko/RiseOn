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
        case .normal: return Color.gray.opacity(0.2)
        case .hover: return Color.blue.opacity(0.4)
        case .focused: return Color.blue.opacity(0.6)
        case .disabled: return Color.gray.opacity(0.3)
        }
    }
}

// MARK: - Custom Button with Animation
struct CustomButton: View {
    let title: String
    @State private var isHovered = false
    var state: ButtonState = .normal
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            if state != .disabled {
                action()
            }
        }) {
            Text(title)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(state.backgroundColor)
                .foregroundColor(state == .disabled ? Color.gray : Color.white)
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
                .foregroundColor(isOn ? Color.green : Color.gray)
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
                .stroke(isSelected ? Color.yellow : Color.gray, lineWidth: 2)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle()
                        .fill(isSelected ? Color.yellow : Color.clear)
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
            RoundedRectangle(cornerRadius: 5)
                .stroke(isChecked ? Color.green : Color.gray, lineWidth: 2)
                .frame(width: 20, height: 20)
                .overlay(
                    Image(systemName: isChecked ? "checkmark" : "")
                        .foregroundColor(Color.green)
                        .opacity(isChecked ? 1 : 0)
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
            .background(isSelected ? Color.yellow : Color.gray.opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(isSelected ? 1.05 : 1.0) // Увеличение при выборе
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
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 200)
        .background(isSelected ? Color.yellow.opacity(0.5) : Color.gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


