//
//  ExerciseImage.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

// MARK: - Exercise Image Component
struct ExerciseImage: View {
    let imageName: String
    let size: ImageSize
    let cornerRadius: CGFloat
    let muscleGroup: MuscleGroup?
    
    init(
        imageName: String,
        size: ImageSize = .medium,
        cornerRadius: CGFloat = DesignTokens.CornerRadius.md,
        muscleGroup: MuscleGroup? = nil
    ) {
        self.imageName = imageName
        self.size = size
        self.cornerRadius = cornerRadius
        self.muscleGroup = muscleGroup
    }
    
    var body: some View {
        ZStack {
            // Background placeholder
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(placeholderGradient)
                .frame(width: size.width, height: size.height)
            
            // Try to load actual image
            Group {
                if let uiImage = UIImage(named: imageName), !imageName.isEmpty {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                } else {
                    // Fallback placeholder content
                    placeholderContent
                }
            }
        }
        .cornerRadius(cornerRadius)
    }
    
    private var placeholderContent: some View {
        VStack(spacing: 8) {
            Image(systemName: placeholderIcon)
                .font(.system(size: size.iconSize, weight: .light))
                .foregroundColor(.white.opacity(0.8))
            
            if size.showText {
                Text("No Image")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
    
    private var placeholderIcon: String {
        if let muscleGroup = muscleGroup {
            return muscleGroup.icon
        }
        return "figure.strengthtraining.traditional"
    }
    
    private var placeholderGradient: LinearGradient {
        if let muscleGroup = muscleGroup {
            return muscleGroup.gradientColors
        }
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.gray.opacity(0.3),
                Color.gray.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Image Size Enum
enum ImageSize {
    case small          // 60x60 - для списков
    case medium         // 80x80 - для карточек
    case large          // 120x120 - для больших карточек
    case hero           // 100% width x 300 height - для детального экрана
    case compact        // 100x80 - для компактных карточек
    
    var width: CGFloat {
        switch self {
        case .small: return 60
        case .medium: return 80
        case .large: return 120
        case .hero: return UIScreen.main.bounds.width
        case .compact: return 100
        }
    }
    
    var height: CGFloat {
        switch self {
        case .small: return 60
        case .medium: return 80
        case .large: return 120
        case .hero: return 300
        case .compact: return 80
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .small: return 20
        case .medium: return 24
        case .large: return 32
        case .hero: return 48
        case .compact: return 28
        }
    }
    
    var showText: Bool {
        switch self {
        case .small, .compact: return false
        case .medium, .large, .hero: return true
        }
    }
}

// MARK: - Specialized Image Components

/// Для использования в ExerciseListCard
struct ExerciseListImage: View {
    let exercise: Exercise
    
    var body: some View {
        ExerciseImage(
            imageName: exercise.imageName,
            size: .medium,
            cornerRadius: DesignTokens.CornerRadius.sm,
            muscleGroup: exercise.muscleGroup
        )
    }
}

/// Для использования в детальном экране
struct ExerciseHeroImage: View {
    let exercise: Exercise
    
    var body: some View {
        ExerciseImage(
            imageName: exercise.imageName,
            size: .hero,
            cornerRadius: 0,
            muscleGroup: exercise.muscleGroup
        )
        .overlay(
            // Gradient overlay for better text readability
            LinearGradient(
                gradient: Gradient(colors: [
                    .clear,
                    .clear,
                    .black.opacity(0.3),
                    .black.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

/// Для использования в компактных карточках на главной
struct CompactWorkoutImage: View {
    let imageName: String
    let muscleGroup: MuscleGroup?
    
    var body: some View {
        ExerciseImage(
            imageName: imageName,
            size: .compact,
            cornerRadius: DesignTokens.CornerRadius.md,
            muscleGroup: muscleGroup
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        // Small image
        ExerciseImage(
            imageName: "dumbbell_squat",
            size: .small,
            muscleGroup: .legs
        )
        
        // Medium image
        ExerciseImage(
            imageName: "push_ups",
            size: .medium,
            muscleGroup: .chest
        )
        
        // Large image
        ExerciseImage(
            imageName: "missing_image",
            size: .large,
            muscleGroup: .back
        )
        
        // Hero image
        ExerciseImage(
            imageName: "burpees",
            size: .hero,
            cornerRadius: 0,
            muscleGroup: .fullBody
        )
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
