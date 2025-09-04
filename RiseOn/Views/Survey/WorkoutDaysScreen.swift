//
//  WorkoutDaysScreen.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

// MARK: - Workout Days Model
enum WorkoutDay: String, CaseIterable {
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
    case sunday = "Sun"
    
    var fullName: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        }
    }
}

struct WorkoutDaysScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var currentStep: Int
    
    // Local state synchronized with ViewModel
    @State private var selectedDays: Set<WorkoutDay> = []
    @State private var remindersEnabled = false
    @State private var selectedHour = 11
    @State private var selectedMinute = 0
    @State private var isAM = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack {
                        Spacer()
                            .frame(height: DesignTokens.Spacing.xl)
                        
                        headerSection
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.15) // Header area
                    
                    // Content area divided into 3 equal parts
                    let contentHeight = geometry.size.height * 0.65 // Total content area
                    let sectionHeight = contentHeight / 3 // Each section gets 1/3
                    
                    // Section 1: Workout Days (Top third)
                    VStack {
                        Spacer()
                        workoutDaysSelector
                        Spacer()
                    }
                    .frame(height: sectionHeight)
                    
                    // Section 2: Reminders Toggle (Middle third)
                    VStack {
                        Spacer()
                        remindersToggleSection
                        Spacer()
                    }
                    .frame(height: sectionHeight)
                    
                    // Section 3: Time Picker (Bottom third)
                    VStack {
                        if remindersEnabled {
                            Spacer()
                            timePickerSection
                                .transition(.opacity)
                            Spacer()
                        }
                    }
                    .frame(height: sectionHeight)
                    
                    // Bottom area for button padding
                    Spacer()
                        .frame(height: geometry.size.height * 0.2)
                }
            }
        }
        .onAppear {
            loadSavedData()
            updateCanProceed()
        }
        .onChange(of: selectedDays) { _, _ in
            updateCanProceed()
            saveDaysToViewModel()
        }
        .onChange(of: remindersEnabled) { _, _ in
            saveRemindersToViewModel()
        }
        .onChange(of: selectedHour) { _, _ in
            saveTimeToViewModel()
        }
        .onChange(of: selectedMinute) { _, _ in
            saveTimeToViewModel()
        }
        .onChange(of: isAM) { _, _ in
            saveTimeToViewModel()
        }
        .animation(.easeInOut(duration: DesignTokens.Animation.normal), value: remindersEnabled)
    }
}

// MARK: - Header Section
extension WorkoutDaysScreen {
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Set your workout days")
                .riseOnHeading2()
                .foregroundColor(.typographyPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
           
        }
        .padding(.horizontal, DesignTokens.Padding.screen)
    }
}

// MARK: - Workout Days Selector
extension WorkoutDaysScreen {
    private var workoutDaysSelector: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            // Первая строка: Mon, Tue, Wed, Thu
            HStack(spacing: DesignTokens.Spacing.md) {
                ForEach([WorkoutDay.monday, .tuesday, .wednesday, .thursday], id: \.self) { day in
                    WorkoutDayCard(
                        day: day,
                        isSelected: selectedDays.contains(day)
                    ) {
                        toggleDay(day)
                    }
                }
            }
            
            // Вторая строка: Fri, Sat, Sun (центрированные)
            HStack(spacing: DesignTokens.Spacing.md) {
                Spacer()
                
                ForEach([WorkoutDay.friday, .saturday, .sunday], id: \.self) { day in
                    WorkoutDayCard(
                        day: day,
                        isSelected: selectedDays.contains(day)
                    ) {
                        toggleDay(day)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, DesignTokens.Padding.screen)
    }
}

// MARK: - Reminders Toggle Section
extension WorkoutDaysScreen {
    private var remindersToggleSection: some View {
        RiseOnCard(style: .basic, size: .medium) {
            HStack {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text("Reminders")
                        .riseOnBodySmall(.medium)
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Build a habit and never miss your workout day")
                        .riseOnCaption()
                        .foregroundColor(.typographyGrey)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Custom toggle
                CustomReminderToggle(isOn: $remindersEnabled)
            }
        }
        .padding(.horizontal, DesignTokens.Padding.screen)
    }
    
    private var timePickerSection: some View {
        // 3D Wheel Time Picker (like iOS Clock app) - clean without background
        WheelTimePicker(
            selectedHour: $selectedHour,
            selectedMinute: $selectedMinute,
            isAM: $isAM
        )
        .padding(.horizontal, DesignTokens.Padding.screen)
    }
    
    private func formatSelectedTime() -> String {
        return String(format: "%02d:%02d %@", selectedHour, selectedMinute, isAM ? "AM" : "PM")
    }
}

// MARK: - Workout Day Card Component
struct WorkoutDayCard: View {
    let day: WorkoutDay
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(day.rawValue)
                .riseOnBodySmall(.medium)
                .foregroundColor(isSelected ? .white : .typographyGrey)
                .frame(width: 60, height: 48)
                .background(
                    isSelected ? 
                    AnyShapeStyle(LinearGradient.gradientDarkGreen) : 
                    AnyShapeStyle(LinearGradient.gradientCard)
                )
                .cornerRadius(DesignTokens.CornerRadius.sm)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                        .stroke(isSelected ? Color.primaryButton : Color.typographyGrey.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: DesignTokens.Animation.fast), value: isSelected)
    }
}

// MARK: - Custom Reminder Toggle
struct CustomReminderToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 52, height: 32)
                .foregroundColor(isOn ? Color.primaryButton : Color.typographyGrey.opacity(0.3))
                .animation(.easeInOut(duration: 0.2), value: isOn)
            
            Circle()
                .frame(width: 28, height: 28)
                .foregroundColor(.white)
                .offset(x: isOn ? 10 : -10)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isOn)
        }
        .onTapGesture {
            isOn.toggle()
        }
    }
}


// MARK: - Helper Methods
extension WorkoutDaysScreen {
    private func toggleDay(_ day: WorkoutDay) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
    
    private func updateCanProceed() {
        viewModel.canProceedFromCurrentStep = !selectedDays.isEmpty
    }
    
    private func loadSavedData() {
        // Load saved data from ViewModel
        selectedDays = viewModel.selectedWorkoutDays
        remindersEnabled = viewModel.remindersEnabled
        
        // Extract time from reminderTime Date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: viewModel.reminderTime)
        
        let hour24 = components.hour ?? 11
        let minute = components.minute ?? 0
        
        // Convert 24-hour to 12-hour format
        if hour24 == 0 {
            selectedHour = 12
            isAM = true
        } else if hour24 < 12 {
            selectedHour = hour24
            isAM = true
        } else if hour24 == 12 {
            selectedHour = 12
            isAM = false
        } else {
            selectedHour = hour24 - 12
            isAM = false
        }
        
        selectedMinute = minute
    }
    
    private func saveDaysToViewModel() {
        viewModel.saveWorkoutDays(selectedDays)
    }
    
    private func saveRemindersToViewModel() {
        viewModel.saveReminders(remindersEnabled)
    }
    
    private func saveTimeToViewModel() {
        viewModel.saveReminderTime(hour: selectedHour, minute: selectedMinute, isAM: isAM)
    }
}

#Preview {
    let viewModel = SurveyViewModel()
    return WorkoutDaysScreen(viewModel: viewModel, currentStep: .constant(7))
        .background(Color.black)
        .preferredColorScheme(.dark)
}
