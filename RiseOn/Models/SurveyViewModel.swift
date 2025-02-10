//
//  SurveyViewModel.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import Foundation
class SurveyViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var age: Int? = nil
    @Published var gender: Gender?
    @Published var goal: Goal? = nil
    @Published var height: Double? = nil
    @Published var weight: Double? = nil
    @Published var level: Level? = nil
    @Published var diet: Diet? = nil
    @Published var targetWeight: Double? = nil
    @Published var selectedUnit: SegmentedControl.UnitType = .metric
    @Published var selectedTrainingTypes: Set<Prefer> = []
    
    
    func saveGender(_ value: Gender) { gender = value }
    func saveGoal(_ value: Goal) { goal = value }
    func saveDiet(_ value: Diet) { diet = value }
    func saveHeight(_ value: Int) { height = Double(value) }
    func saveWeight(_ value: Int) { weight = Double(value) }
    func saveLevel(_ value: Level) { level = value }
    func saveTargetWeight(_ value: Int) { targetWeight = Double(value) }
    func saveName(_ value: String) { name = value }
    func convertHeightToSelectedUnit() -> String {
        guard let height = height else { return "" }
        return selectedUnit == .metric ? "\(height) cm" : String(format: "%.1f ft", height / 30.48)
    }

    func convertWeightToSelectedUnit() -> String {
        guard let weight = weight else { return "" }
        return selectedUnit == .metric ? "\(weight) kg" : String(format: "%.1f lbs", weight * 2.205)
    }
    func convertTargetWeightToSelectedUnit() -> String {
        guard let targetWeight = targetWeight else { return "" }
        return selectedUnit == .metric ? "\(targetWeight) kg" : String(format: "%.1f lbs", targetWeight * 2.205)
    }
    
    func toggleSelection(for type: Prefer) {
            if selectedTrainingTypes.contains(type) {
                selectedTrainingTypes.remove(type)
            } else {
                selectedTrainingTypes.insert(type)
            }
        }
}
