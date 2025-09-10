# RiseOn

RiseOn is a fitness-oriented iOS application designed to help users achieve their health and workout goals through personalized exercise programs, progress tracking, and smart recommendations. The app focuses on user-centric features such as tailored workout plans, detailed exercise information, and seamless profile management.

## Features

- **Personalized Workout Plans:** Users can set their fitness goals (e.g., lose weight, build muscle, maintain weight, develop flexibility) and receive customized exercise routines.
- **Comprehensive Exercise Library:** Includes detailed descriptions, instructions, equipment requirements, tips, and variations for each exercise.
- **User Profile Management:** Stores user data including name, age, gender, physical characteristics, workout preferences, and dietary choices.
- **Progress Tracking:** Tracks workout days, reminders, and progress toward goals.
- **Search & Filter:** Advanced filtering and searching for exercises by muscle group, difficulty, equipment, duration, and calories.
- **Statistics:** Provides insights such as total number of exercises and muscle group breakdowns.
- **SwiftUI & SwiftData:** Built with modern Apple frameworks for smooth user experience and reliable data management.

## Technologies Used

- **Swift / SwiftUI**: For UI and core app logic.
- **SwiftData**: For local data storage and user profile management.
- **Combine**: For reactive data flows and state management.

## Core Models

- **Exercise Model**: Represents an exercise with fields for name, instructions, muscle group, difficulty, duration, calories, equipment, images, and more.
- **UserProfileModel**: Stores user information and preferences.
- **Goal**: Enum for fitness objectives.
- **AppState**: Centralized state management for authentication, app flow, and global flags.

## Example Exercise

```swift
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
    imageName: "overhead_press"
)
```

## Getting Started

1. Clone the repository:
    ```bash
    git clone https://github.com/VladDrobitko/RiseOn.git
    ```
2. Open `RiseOn.xcodeproj` in Xcode.
3. Build and run the project on the simulator or your device.

## Project Structure

- `Models/` — Core data models and services (exercises, user profiles, app state, etc.)
- `Views/` — SwiftUI views and UI components.
- `Resources/` — Assets such as images, JSON exercise data, etc.

## Contributing

Feel free to open issues or submit pull requests for new features, bug fixes, or improvements!

## License

This project is licensed under the MIT License.

---

Made by Vladislav Drobitko
