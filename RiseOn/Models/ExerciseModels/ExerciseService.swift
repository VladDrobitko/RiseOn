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
    
    // MARK: - Get Exercises by Muscle Group
    func getExercises(for muscleGroup: MuscleGroup) -> [Exercise] {
        return exercises.filter { $0.muscleGroup == muscleGroup }
    }
    
    // MARK: - Get Exercise by ID
    func getExercise(by id: String) -> Exercise? {
        return exercises.first { $0.id == id }
    }
    
    // MARK: - Filter Methods
    func getExercises(by difficulty: ExerciseDifficulty) -> [Exercise] {
        return exercises.filter { $0.difficulty == difficulty }
    }
    
    func getExercises(requiring equipment: Equipment) -> [Exercise] {
        return exercises.filter { $0.equipment.contains(equipment) }
    }
    
    func getExercises(withoutEquipment: Bool = true) -> [Exercise] {
        return exercises.filter { $0.equipment.isEmpty }
    }
    
    func getExercises(maxDuration duration: Int) -> [Exercise] {
        return exercises.filter { $0.duration <= duration }
    }
    
    func getExercises(maxCalories calories: Int) -> [Exercise] {
        return exercises.filter { $0.calories <= calories }
    }
    
    // MARK: - Search
    func searchExercises(_ query: String) -> [Exercise] {
        guard !query.isEmpty else { return exercises }
        
        let lowercaseQuery = query.lowercased()
        return exercises.filter { exercise in
            exercise.name.lowercased().contains(lowercaseQuery) ||
            exercise.description.lowercased().contains(lowercaseQuery) ||
            exercise.targetMuscles.contains { $0.lowercased().contains(lowercaseQuery) } ||
            exercise.muscleGroup.displayName.lowercased().contains(lowercaseQuery)
        }
    }
    
    // MARK: - Statistics
    func getTotalExercises() -> Int {
        return exercises.count
    }
    
    func getExerciseCount(for muscleGroup: MuscleGroup) -> Int {
        return getExercises(for: muscleGroup).count
    }
    
    func getEstimatedTime(for muscleGroup: MuscleGroup) -> Int {
        return getExercises(for: muscleGroup).reduce(0) { $0 + $1.duration }
    }
    
    func getTotalCalories(for muscleGroup: MuscleGroup) -> Int {
        return getExercises(for: muscleGroup).reduce(0) { $0 + $1.calories }
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
                    "Hold dumbbells at your sides",
                    "Lower your body by bending your knees",
                    "Push your hips back as if sitting in a chair",
                    "Keep your chest up and core engaged",
                    "Return to starting position"
                ],
                muscleGroup: .legs,
                difficulty: .intermediate,
                duration: 15,
                calories: 120,
                equipment: [.dumbbells],
                imageName: "dumbbell_squat",
                videoName: nil,
                resistanceIntensity: .medium,
                targetMuscles: ["Quadriceps", "Glutes", "Hamstrings"],
                tips: [
                    "Keep your knees in line with your toes",
                    "Don't let your knees cave inward",
                    "Keep your weight on your heels"
                ],
                variations: [
                    "Goblet Squat",
                    "Sumo Squat",
                    "Bulgarian Split Squat"
                ]
            ),
            Exercise(
                id: "2",
                name: "Bent-Over Row",
                description: "A compound pulling exercise that targets the muscles of the upper back, particularly the latissimus dorsi, rhomboids, and middle trapezius.",
                instructions: [
                    "Stand with feet hip-width apart, holding a barbell",
                    "Hinge at the hips and lean forward 45 degrees",
                    "Keep your back straight and core engaged",
                    "Pull the bar to your lower chest",
                    "Squeeze your shoulder blades together",
                    "Lower the bar with control"
                ],
                muscleGroup: .back,
                difficulty: .intermediate,
                duration: 15,
                calories: 120,
                equipment: [.barbell],
                imageName: "bent_over_row",
                videoName: nil,
                resistanceIntensity: .medium,
                targetMuscles: ["Latissimus Dorsi", "Rhomboids", "Middle Traps", "Biceps"],
                tips: [
                    "Keep your core tight throughout",
                    "Don't round your back",
                    "Pull with your back muscles, not your arms",
                    "Control the negative portion"
                ],
                variations: [
                    "Dumbbell Row",
                    "T-Bar Row",
                    "Cable Row",
                    "Single-Arm Row"
                ]
            ),
            Exercise(
                id: "3",
                name: "Push-Ups",
                description: "A classic bodyweight exercise that targets the chest, shoulders, and triceps while engaging the core.",
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
                equipment: [],
                imageName: "push_ups",
                videoName: nil,
                resistanceIntensity: .light,
                targetMuscles: ["Pectorals", "Anterior Deltoids", "Triceps"],
                tips: [
                    "Don't let your hips sag",
                    "Keep your head in neutral position",
                    "Breathe out as you push up"
                ],
                variations: [
                    "Incline Push-Ups",
                    "Diamond Push-Ups",
                    "Wide-Grip Push-Ups"
                ]
            ),
            Exercise(
                id: "4",
                name: "Plank",
                description: "A core stabilization exercise that strengthens the entire core and improves posture.",
                instructions: [
                    "Start in a push-up position",
                    "Lower to your forearms",
                    "Keep your body in a straight line",
                    "Hold the position",
                    "Breathe normally throughout"
                ],
                muscleGroup: .core,
                difficulty: .beginner,
                duration: 5,
                calories: 25,
                equipment: [.yoga_mat],
                imageName: "plank",
                videoName: nil,
                resistanceIntensity: .light,
                targetMuscles: ["Rectus Abdominis", "Transverse Abdominis", "Obliques"],
                tips: [
                    "Don't let your hips sag or pike up",
                    "Keep your head in neutral position",
                    "Engage your core muscles"
                ],
                variations: [
                    "Side Plank",
                    "Plank Up-Downs",
                    "Plank Jacks"
                ]
            ),
            Exercise(
                id: "5",
                name: "Glute Bridges",
                description: "An excellent exercise for activating and strengthening the glute muscles.",
                instructions: [
                    "Lie on your back with knees bent",
                    "Feet flat on the floor, hip-width apart",
                    "Squeeze your glutes and lift your hips",
                    "Create a straight line from knees to shoulders",
                    "Hold briefly, then lower slowly"
                ],
                muscleGroup: .glutes,
                difficulty: .beginner,
                duration: 8,
                calories: 60,
                equipment: [.yoga_mat],
                imageName: "glute_bridges",
                videoName: nil,
                resistanceIntensity: .light,
                targetMuscles: ["Glutes", "Hamstrings", "Core"],
                tips: [
                    "Squeeze your glutes at the top",
                    "Don't arch your back excessively",
                    "Keep your core engaged"
                ],
                variations: [
                    "Single-Leg Glute Bridge",
                    "Hip Thrusts",
                    "Weighted Glute Bridge"
                ]
            ),
            Exercise(
                id: "6",
                name: "Overhead Press",
                description: "A fundamental shoulder exercise that builds strength and stability in the shoulders and core.",
                instructions: [
                    "Stand with feet shoulder-width apart",
                    "Hold dumbbells at shoulder height",
                    "Press weights straight up overhead",
                    "Keep your core tight",
                    "Lower with control to starting position"
                ],
                muscleGroup: .shoulders,
                difficulty: .intermediate,
                duration: 12,
                calories: 100,
                equipment: [.dumbbells],
                imageName: "overhead_press",
                videoName: nil,
                resistanceIntensity: .medium,
                targetMuscles: ["Anterior Deltoids", "Medial Deltoids", "Triceps"],
                tips: [
                    "Don't arch your back excessively",
                    "Keep your core engaged",
                    "Press straight up, not forward"
                ],
                variations: [
                    "Military Press",
                    "Arnold Press",
                    "Pike Push-Ups"
                ]
            ),
            Exercise(
                id: "7",
                name: "Bicep Curls",
                description: "An isolation exercise that targets the biceps muscles of the upper arm.",
                instructions: [
                    "Stand with feet hip-width apart",
                    "Hold dumbbells with arms at your sides",
                    "Keep your elbows close to your body",
                    "Curl the weights up toward your shoulders",
                    "Squeeze at the top, then lower slowly"
                ],
                muscleGroup: .arms,
                difficulty: .beginner,
                duration: 10,
                calories: 70,
                equipment: [.dumbbells],
                imageName: "bicep_curls",
                videoName: nil,
                resistanceIntensity: .light,
                targetMuscles: ["Biceps", "Brachialis"],
                tips: [
                    "Don't swing the weights",
                    "Control the lowering phase",
                    "Keep your wrists straight"
                ],
                variations: [
                    "Hammer Curls",
                    "Concentration Curls",
                    "Cable Curls"
                ]
            ),
            Exercise(
                id: "8",
                name: "Burpees",
                description: "A full-body exercise that combines strength training and cardiovascular conditioning.",
                instructions: [
                    "Start standing upright",
                    "Drop into a squat position",
                    "Place hands on the floor and jump feet back",
                    "Perform a push-up",
                    "Jump feet back to squat position",
                    "Jump up with arms overhead"
                ],
                muscleGroup: .fullBody,
                difficulty: .advanced,
                duration: 15,
                calories: 150,
                equipment: [],
                imageName: "burpees",
                videoName: nil,
                resistanceIntensity: .high,
                targetMuscles: ["Full Body", "Cardiovascular System"],
                tips: [
                    "Maintain proper form throughout",
                    "Modify by stepping instead of jumping",
                    "Keep your core engaged"
                ],
                variations: [
                    "Half Burpees",
                    "Burpee Box Jumps",
                    "Burpee Pull-Ups"
                ]
            )
        ]
        isLoading = false
    }
}
