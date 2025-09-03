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
    @Published var goal: Goal?
    @Published var height: Double? = nil
    @Published var weight: Double? = nil
    @Published var level: Level?
    @Published var diet: Diet?
    @Published var targetWeight: Double? = nil
    @Published var selectedUnit: SegmentedControl.UnitType = .metric
    @Published var selectedTrainingTypes: Set<Prefer> = []
    @Published var canProceedFromCurrentStep: Bool = false
    
    // MARK: - Методы сохранения значений
    func save<T>(_ value: T?, to property: inout T?) {
        property = value
    }
    
    func saveName(_ value: String) { name = value }
    func saveGender(_ value: Gender) { gender = value }
    func saveGoal(_ value: Goal) { goal = value }
    func saveDiet(_ value: Diet) { diet = value }
    func saveHeight(_ value: Double) { height = value }
    func saveWeight(_ value: Double) { weight = value }
    func saveLevel(_ value: Level) { level = value }
    func saveTargetWeight(_ value: Double) { targetWeight = value }
    
    // MARK: - Конвертация единиц измерения
    func formatHeight() -> String {
        guard let height = height else { return "—" }
        return selectedUnit == .metric ? "\(height) cm" : String(format: "%.1f ft", height / 30.48)
    }

    func formatWeight() -> String {
        guard let weight = weight else { return "—" }
        return selectedUnit == .metric ? "\(weight) kg" : String(format: "%.1f lbs", weight * 2.205)
    }
    
    func formatTargetWeight() -> String {
        guard let targetWeight = targetWeight else { return "—" }
        return selectedUnit == .metric ? "\(targetWeight) kg" : String(format: "%.1f lbs", targetWeight * 2.205)
    }
    
    // MARK: - Выбор предпочтений
    func toggleSelection(for type: Prefer) {
        selectedTrainingTypes.formSymmetricDifference([type])
    }
    
    // MARK: - Проверка на заполненность данных
    var isSurveyComplete: Bool {
        return !name.isEmpty &&
               age != nil &&
               gender != nil &&
               goal != nil &&
               height != nil &&
               weight != nil &&
               level != nil &&
               diet != nil &&
               targetWeight != nil &&
               !selectedTrainingTypes.isEmpty
    }
}