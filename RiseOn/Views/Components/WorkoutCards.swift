//
//  WorkoutCards.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

// MARK: - Best For You Card
struct BestForYouCard: View {
    let title: String
    let difficulty: String
    let duration: String
    let calories: String
    let imageName: String
    let onTap: (() -> Void)?
    
    init(
        title: String,
        difficulty: String,
        duration: String,
        calories: String,
        imageName: String,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.difficulty = difficulty
        self.duration = duration
        self.calories = calories
        self.imageName = imageName
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: { onTap?() }) {
            ZStack(alignment: .bottomLeading) {
                // Background Image with Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.4),
                                    Color.purple.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 180)
                    
                    // Try to load actual image
                    if let uiImage = UIImage(named: imageName), !imageName.isEmpty {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 180)
                            .clipped()
                    } else {
                        // Placeholder content
                        VStack(spacing: 8) {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 32, weight: .light))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Workout")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .overlay(
                    // Gradient overlay for text readability
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .clear,
                            .black.opacity(0.3),
                            .black.opacity(0.8)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(16)
                
                // Content overlay
                VStack(alignment: .leading, spacing: 8) {
                    // Title
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Stats
                    HStack(spacing: 12) {
                        // Difficulty
                        Text(difficulty)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.2))
                            )
                        
                        // Duration and Calories
                        VStack(alignment: .leading, spacing: 2) {
                            Text(duration)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text(calories)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                    }
                }
                .padding(16)
            }
            .frame(width: 200, height: 180)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Warm Up Card
struct WarmUpCard: View {
    let title: String
    let difficulty: String
    let duration: String
    let calories: String
    let imageName: String
    let onTap: (() -> Void)?
    
    init(
        title: String,
        difficulty: String,
        duration: String,
        calories: String,
        imageName: String,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.difficulty = difficulty
        self.duration = duration
        self.calories = calories
        self.imageName = imageName
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: { onTap?() }) {
            ZStack(alignment: .bottomLeading) {
                // Background Image with Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.orange.opacity(0.4),
                                    Color.yellow.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Try to load actual image
                    if let uiImage = UIImage(named: imageName), !imageName.isEmpty {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    } else {
                        // Placeholder content
                        VStack(spacing: 6) {
                            Image(systemName: "sun.max")
                                .font(.system(size: 24, weight: .light))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Warm Up")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .overlay(
                    // Gradient overlay
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .clear,
                            .black.opacity(0.2),
                            .black.opacity(0.7)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(12)
                
                // Content overlay
                VStack(alignment: .leading, spacing: 6) {
                    // Title
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Stats row
                    HStack(spacing: 8) {
                        // Difficulty badge
                        Text(difficulty)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white.opacity(0.2))
                            )
                        
                        Spacer()
                    }
                    
                    // Duration and calories
                    HStack(spacing: 8) {
                        HStack(spacing: 3) {
                            Image(systemName: "clock")
                                .font(.system(size: 8))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(duration)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        HStack(spacing: 3) {
                            Image(systemName: "flame")
                                .font(.system(size: 8))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(calories)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                    }
                }
                .padding(12)
            }
            .frame(height: 120)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Best For You Cards
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                BestForYouCard(
                    title: "Tightened Legs and Glutes",
                    difficulty: "Medium",
                    duration: "40 min",
                    calories: "350 kCal",
                    imageName: "legs_workout"
                ) {
                    print("Best for you card tapped")
                }
                
                BestForYouCard(
                    title: "Explosive Tone Up",
                    difficulty: "Hard",
                    duration: "50 min",
                    calories: "470 kCal",
                    imageName: "explosive_workout"
                ) {
                    print("Explosive card tapped")
                }
            }
            .padding(.horizontal, 16)
        }
        
        // Warm Up Cards
        HStack(spacing: 12) {
            WarmUpCard(
                title: "Morning Warm Up",
                difficulty: "Light",
                duration: "15 min",
                calories: "75 kCal",
                imageName: "morning_warmup"
            ) {
                print("Morning warm up tapped")
            }
            
            WarmUpCard(
                title: "Office Warm Up",
                difficulty: "Medium",
                duration: "13 min",
                calories: "46 kCal",
                imageName: "office_warmup"
            ) {
                print("Office warm up tapped")
            }
        }
        .padding(.horizontal, 16)
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
