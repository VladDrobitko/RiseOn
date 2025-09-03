//
//  Goal.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 05/02/2025.
//

import Foundation
enum Goal: String, CaseIterable {
    case loseWeight = "Lose weight"
    case buildMuscle = "Build muscle mass"
    case maintainWeight = "Maintain weight"
    case developFlexibility = "Develop flexibility"

    var description: String {
        switch self {
        case .loseWeight: return "Reduce body fat"
        case .buildMuscle: return "Develop strength and endurance"
        case .maintainWeight: return "Keep the entire body in a good shape"
        case .developFlexibility: return "Sit on twine and increase plasticity"
        }
    }
}
