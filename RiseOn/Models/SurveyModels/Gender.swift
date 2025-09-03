//
//  Gender.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 05/02/2025.
//

import Foundation
enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    

    var description: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}
