//
//  ExerciseService.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import Foundation

// MARK: - Exercise Service
class ExerciseService: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    static let shared = ExerciseService()
    
    private init() {
        loadExercises()
    }
    
    // MARK: - Load Exercises from JSON
    func loadExercises() {
        isLoading = true
        errorMessage = nil
        
        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
            // Если JSON файла нет, загружаем моковые данные
            loadMockExercises()
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            exercises = try decoder.decode([Exercise].self, from: data)
            isLoading = false
        } catch {
            errorMessage = "Failed to load exercises: \(error.localizedDescription)"
            loadMockExercises() // Загружаем моковые данные в случае ошибки
        }
    }
    
    // MARK: - Mock Data
    private func loadMockExercises() {
        exercises = [
            Exercise(
                id: "1",
                name: "Dumbbell Squat",
                description: "The dumbbell squat is a strength exercise that primarily targets the muscles of the lower body, including the quads, glutes, and hamstrings. To perform dumbbell squats, you hold a dumbbell in each hand at your sides, or one dumbbell with both hands, stand with your feet shoulder-width apart, and lower your body by bending your knees and pushing your hips back, as if you were sitting in a chair. Then you stand up pushing through your heels and engaging your leg muscles.",
                instructions: [
                    "Stand with feet shoulder-width apart",
                    "Hold dumbbells at your sides or one dumbbell with both hands",
                    "Keep your chest up and core engaged",
                    "Lower your body by bending your knees",
                    "Push your hips back as if sitting in a chair",
                    "Go down until your thighs are parallel to the floor",
                    "Push through your heels to return to starting position",
                    "Repeat for desired number of reps"
                ],
                muscleGroup: .legs,
                difficulty: .intermediate,
                duration: 15,
                calories: 120,
                equipment: [.dumbbells],
                imageName: "dumbbell_squat",
                videoName: "dumbbell_squat_video",
                resistanceIntensity: .medium,
                targetMuscles: ["Quadriceps", "Glutes", "Hamstrings", "Calves"],
                tips: [
                    "Keep your knees in line with your toes",
                    "Don't let your knees cave inward",
                    "Maintain a neutral spine throughout the movement",
                    "Start with lighter weights to master the form"
                ],
                variations: [
                    "Goblet Squat",
                    "Sumo Squat",
                    "Split Squat",
                    "Jump Squat"
                ]
            ),
            Exercise(
                id: "2",
                name: "Push-Up",
                description: "The push-up is a classic bodyweight exercise that targets the chest, shoulders, and triceps. It's an excellent compound movement that also engages the core for stability.",
                instructions: [
                    "Start in a plank position with hands slightly wider than shoulders",
                    "Keep your body in a straight line from head to heels",
                    "Lower your chest toward the floor",
                    "Push back up to starting position",
                    "Keep your core engaged throughout"
                ],
                muscleGroup: .chest,
                difficulty: .beginner,
                duration: 10,
                calories: 80,
                equipment: [.none],
                imageName: "push_up",
                videoName: nil,
                resistanceIntensity: .low,
                targetMuscles: ["Pectorals", "Deltoids", "Triceps", "Core"],
                tips: [
                    "Don't let your hips sag",
                    "Keep your head in neutral position",
                    "Control the movement on both up and down phases"
                ],
                variations: [
                    "Incline Push-Up",
                    "Decline Push-Up",
                    "Diamond Push-Up",
                    "Wide-Grip Push-Up"
                ]
            )
        ]
        isLoading = false
    }
    
    // MARK: - Helper Methods
    func getExercise(by id: String) -> Exercise? {
        return exercises.first { $0.id == id }
    }
    
    func getExercises(for muscleGroup: MuscleGroup) -> [Exercise] {
        return exercises.filter { $0.muscleGroup == muscleGroup }
    }
    
    func getExercises(for difficulty: ExerciseDifficulty) -> [Exercise] {
        return exercises.filter { $0.difficulty == difficulty }
    }
    
    func getExercises(for equipment: Equipment) -> [Exercise] {
        return exercises.filter { $0.equipment.contains(equipment) }
    }
}
