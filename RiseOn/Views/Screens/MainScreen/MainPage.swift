//
//  MainPage.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 16/02/2025.
//

import SwiftUI

struct MainPage: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // Верхняя большая карточка (Marathon Start)
                topEventCard
                
                // Секция "The Best For You" с горизонтальным скроллом
                bestForYouSection
                
                // Секция "Warm Ups" с двумя карточками в ряд
                warmUpsSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 100) // Отступ для tab bar
        }
        .background(Color.black.ignoresSafeArea(.all))
    }
}

// MARK: - Top Event Card (Marathon Start)
extension MainPage {
    private var topEventCard: some View {
        ZStack {
            // Фоновое изображение (пустая карточка пока)
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.2, green: 0.3, blue: 0.4),
                            Color(red: 0.1, green: 0.15, blue: 0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack {
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Marathon Start")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("09.04.2023-09.05.2023")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Кнопка "Join to us"
                    Button(action: {}) {
                        Text("Join to us")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.84, green: 0.95, blue: 0.35))
                            .cornerRadius(16)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .frame(height: 200)
    }
}

// MARK: - The Best For You Section (Horizontal Scroll)
extension MainPage {
    private var bestForYouSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Заголовок с кнопкой "All"
            HStack {
                Text("The Best For You")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("All")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.84, green: 0.95, blue: 0.35))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.84, green: 0.95, blue: 0.35))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Горизонтальный скролл карточек
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Первая карточка - Tightened Legs and Glutes
                    BestForYouCard(
                        title: "Tightened Legs and Glutes",
                        difficulty: "Medium",
                        duration: "40 min",
                        calories: "350 kCal",
                        imageName: "legs_workout" // Пустая пока
                    )
                    
                    // Вторая карточка - частично видимая
                    BestForYouCard(
                        title: "Explosive Tone Up",
                        difficulty: "Hard",
                        duration: "50 min",
                        calories: "470 kCal",
                        imageName: "explosive_workout"
                    )
                    
                    // Третья карточка для демонстрации скролла
                    BestForYouCard(
                        title: "Core Strength",
                        difficulty: "Medium",
                        duration: "30 min",
                        calories: "280 kCal",
                        imageName: "core_workout"
                    )
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

// MARK: - Warm Ups Section
extension MainPage {
    private var warmUpsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Заголовок с кнопкой "All"
            HStack {
                Text("Warm Ups")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("All")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.84, green: 0.95, blue: 0.35))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.84, green: 0.95, blue: 0.35))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Две карточки в ряд
            HStack(spacing: 12) {
                // Morning Warm Up
                WarmUpCard(
                    title: "Morning Warm Up",
                    difficulty: "Light",
                    duration: "15 min",
                    calories: "75 kCal",
                    imageName: "morning_warmup"
                )
                
                // Office Warm Up
                WarmUpCard(
                    title: "Office Warm up",
                    difficulty: "Medium",
                    duration: "13 min",
                    calories: "46 kCal",
                    imageName: "office_warmup"
                )
            }
        }
    }
}

// MARK: - Best For You Card Component
struct BestForYouCard: View {
    let title: String
    let difficulty: String
    let duration: String
    let calories: String
    let imageName: String
    
    var body: some View {
        ZStack {
            // Фоновая карточка
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.2, green: 0.2, blue: 0.21))
            
            VStack {
                Spacer()
                
                // Контент внизу карточки
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        // Индикатор сложности
                        HStack(spacing: 4) {
                            Circle()
                                .fill(difficultyColor)
                                .frame(width: 8, height: 8)
                            
                            Text(difficulty)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Иконка сердца
                        Button(action: {}) {
                            Image(systemName: "heart")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(duration)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "flame")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(calories)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .frame(width: 280, height: 160)
    }
    
    private var difficultyColor: Color {
        switch difficulty.lowercased() {
        case "light":
            return .green
        case "medium":
            return .yellow
        case "hard":
            return .orange
        default:
            return .gray
        }
    }
}

// MARK: - Warm Up Card Component
struct WarmUpCard: View {
    let title: String
    let difficulty: String
    let duration: String
    let calories: String
    let imageName: String
    
    var body: some View {
        ZStack {
            // Фоновая карточка
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.2, green: 0.2, blue: 0.21))
            
            VStack {
                Spacer()
                
                // Контент внизу карточки
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        // Индикатор сложности
                        HStack(spacing: 4) {
                            Circle()
                                .fill(difficultyColor)
                                .frame(width: 8, height: 8)
                            
                            Text(difficulty)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Иконка сердца
                        Button(action: {}) {
                            Image(systemName: "heart")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(duration)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "flame")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(calories)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
    }
    
    private var difficultyColor: Color {
        switch difficulty.lowercased() {
        case "light":
            return .green
        case "medium":
            return .yellow
        case "hard":
            return .orange
        default:
            return .gray
        }
    }
}

// MARK: - Preview
#Preview {
    let appState = AppState()
    
    NavigationView {
        MainPage()
            .environmentObject(appState)
    }
    .preferredColorScheme(.dark)
}
