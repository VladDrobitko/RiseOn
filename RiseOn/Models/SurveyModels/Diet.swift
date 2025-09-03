//
//  Diet.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 10/02/2025.
//

import Foundation
enum Diet: String, CaseIterable {
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case keto = "Keto"
    case mediterranean = "Mediterranean"
    case noAnyDietes = "No"

    var description: String {
        switch self {
        case .vegetarian: return "Excludes meat"
        case .vegan: return "Excludes all animal products"
        case .keto: return "Low-carb, hight-fat"
        case .mediterranean: return "Rich in plant-based foods"
        case .noAnyDietes: return "I don’t follow any dietes"
        }
    }
}
