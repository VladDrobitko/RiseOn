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
    @Published var gender: Gender? = .male
    @Published var goal: Goal?
    @Published var height: Double? = nil
    @Published var weight: Double? = nil
    @Published var level: Level?
    @Published var diet: Diet?
    @Published var targetWeight: Double? = nil
    @Published var selectedUnit: SegmentedControl.UnitType = .metric
    @Published var selectedTrainingTypes: Set<Prefer> = []
    @Published var canProceedFromCurrentStep: Bool = false
    
    // MARK: - Workout Days Properties
    @Published var selectedWorkoutDays: Set<WorkoutDay> = []
    @Published var remindersEnabled: Bool = false
    @Published var reminderTime: Date = Calendar.current.date(from: DateComponents(hour: 11, minute: 0)) ?? Date()
    
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
    
    // MARK: - Workout Days Methods
    func saveWorkoutDays(_ days: Set<WorkoutDay>) {
        selectedWorkoutDays = days
    }
    
    func saveReminders(_ enabled: Bool) {
        remindersEnabled = enabled
    }
    
    func saveReminderTime(_ time: Date) {
        reminderTime = time
    }
    
    func saveReminderTime(hour: Int, minute: Int, isAM: Bool) {
        let adjustedHour = isAM ? (hour == 12 ? 0 : hour) : (hour == 12 ? 12 : hour + 12)
        
        var components = DateComponents()
        components.hour = adjustedHour
        components.minute = minute
        
        if let date = Calendar.current.date(from: components) {
            reminderTime = date
        }
    }
    
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
               !selectedTrainingTypes.isEmpty &&
               !selectedWorkoutDays.isEmpty // Добавили проверку на дни тренировок
    }
    
    // MARK: - Форматирование времени напоминания
    func formatReminderTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: reminderTime)
    }
    
    // MARK: - Получение выбранных дней как строка
    func getWorkoutDaysString() -> String {
        let sortedDays = selectedWorkoutDays.sorted { day1, day2 in
            let order: [WorkoutDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
            guard let index1 = order.firstIndex(of: day1),
                  let index2 = order.firstIndex(of: day2) else { return false }
            return index1 < index2
        }
        
        return sortedDays.map { $0.rawValue }.joined(separator: ", ")
    }
    
}
