//
//  CustomGradients.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 30/01/2025.
//

import Foundation
import SwiftUI

struct GradientFactory {
    /// Создаёт линейный градиент из HEX-цветов
    static func linearGradient(hexColors: [String], startPoint: UnitPoint, endPoint: UnitPoint) -> LinearGradient {
        let colors = hexColors.map { Color(hex: $0) }
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }
}

extension Color {
    /// Инициализация `Color` по HEX-коду
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b, a: Double
        switch hex.count {
        case 6: // RGB (без альфа)
            (r, g, b, a) = (
                Double((int >> 16) & 0xFF) / 255,
                Double((int >> 8) & 0xFF) / 255,
                Double(int & 0xFF) / 255,
                1.0
            )
        case 8: // RGBA
            (r, g, b, a) = (
                Double((int >> 24) & 0xFF) / 255,
                Double((int >> 16) & 0xFF) / 255,
                Double((int >> 8) & 0xFF) / 255,
                Double(int & 0xFF) / 255
            )
        default:
            (r, g, b, a) = (1, 1, 1, 1) // Белый по умолчанию
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension LinearGradient {
    /// 🔥 Определяем кастомные градиенты здесь 🔥
    static let gradientLightGreen = GradientFactory.linearGradient(
        hexColors: ["#323536", "#D7FB03"],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let gradientDarkGreen = GradientFactory.linearGradient(
        hexColors: ["#363E0C", "#74850B"],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let gradientDarkGrey = GradientFactory.linearGradient(
        hexColors: ["#323536", "#171717"],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientLightGrey = GradientFactory.linearGradient(
        hexColors: ["#4E5354", "#2F3233"],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let gradientCard = GradientFactory.linearGradient(
        hexColors: ["#323536", "#222425"],
        startPoint: .leading,
        endPoint: .trailing
    )
}
