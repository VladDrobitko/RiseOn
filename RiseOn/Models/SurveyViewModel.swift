//
//  SurveyViewModel.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import Foundation
class SurveyViewModel: ObservableObject {
    @Published var name: String? = nil
    @Published var age: Int? = nil
    @Published var gender: String? = nil
    @Published var goal: Goal?
    @Published var height: Int? = nil
    @Published var weight: Int? = nil
    @Published var experience: String? = nil
    @Published var targetWeight: Int? = nil
    
    
    
    func saveGender(_ value: String) { gender = value }
    func saveHeight(_ value: Int) { height = value }
    func saveWeight(_ value: Int) { weight = value }
    func saveExperience(_ value: String) { experience = value }
    func saveTargetWeight(_ value: Int) { targetWeight = value }
}
