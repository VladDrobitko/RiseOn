//
//  ContentView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 30/01/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isToggled = false
    @State private var isRadioSelected = false
    @State private var isChecked = false
    @State private var isTabSelected = false
    @State private var isCardSelected = false
    @State private var selectedUnit: SegmentedControl.UnitType = .imperial
    @State private var name: String = ""
    @State private var height: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Custom Buttons").font(.title).foregroundColor(.white)
                
                CustomButton(title: "Start", state: .normal) { print("Start clicked") }
                CustomButton(title: "Start (Hover)", state: .hover) { }
                CustomButton(title: "Start (Focused)", state: .focused) { }
                CustomButton(title: "Start (Disabled)", state: .disabled) { }
                
                SegmentedControl(selectedUnit: $selectedUnit)
                
                VStack(spacing: 16) {
                    CustomTextField(title: "Name", text: $name, placeholder: "Enter your name", state: .default)
                    
                    CustomTextField(title: "Height", text: $height, placeholder: "cm", errorMessage: "Cannot be less than 122 cm", state: .error, keyboardType: .numberPad)
                }
                .padding()
                
                Divider().background(Color.white)
                
                Text("Toggle Switch").font(.title2).foregroundColor(.white)
                CustomToggle(isOn: $isToggled)
                
                Divider().background(Color.white)
                
                Text("Radio Button").font(.title2).foregroundColor(.white)
                RadioButton(title: "Male", isSelected: $isRadioSelected)
                
                Divider().background(Color.white)
                
                Text("Checkbox").font(.title2).foregroundColor(.white)
                Checkbox(isChecked: $isChecked)
                
                Divider().background(Color.white)
                
                Text("Tabs").font(.title2).foregroundColor(.white)
                TabButton(title: "Balance", isSelected: $isTabSelected)
                
                Divider().background(Color.white)
                
                Text("Selection Card").font(.title2).foregroundColor(.white)
                SelectionCard(title: "Lose weight", subtitle: "Reduce body fat", isSelected: $isCardSelected)
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ContentView()
}
