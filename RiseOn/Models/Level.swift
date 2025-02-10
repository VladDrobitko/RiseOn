//
//  Level.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 10/02/2025.
//

import Foundation
enum Level: String, CaseIterable {
    case lowActivity = "Low activity"
    case averageActivity = "Average activity"
    case highActivity = "High activity"
    case veryHighActivity = "Very high activity"

    var description: String {
        switch self {
        case .lowActivity: return "I hardly do any exercise"
        case .averageActivity: return "1-3 workouts per week"
        case .highActivity: return "4-5 workouts per week"
        case .veryHighActivity: return "6-7 workouts per week"
        }
    }
}
