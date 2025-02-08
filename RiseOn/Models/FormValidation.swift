//
//  FormValidation.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 07/02/2025.
//


import Foundation

struct FormValidation {
    static func validateName(_ name: String) -> Bool {
        return !name.isEmpty
    }

    static func validateAge(_ age: String) -> Bool {
        guard let ageInt = Int(age), ageInt >= 10, ageInt <= 130 else {
            return false
        }
        return true
    }

    static func validateWeight(_ weight: String) -> Bool {
        guard let weightDouble = Double(weight), weightDouble > 20, weightDouble <= 400 else {
            return false
        }
        return true
    }

    static func validateHeight(_ height: String) -> Bool {
        guard let heightDouble = Double(height), heightDouble > 30, heightDouble < 250 else {
            return false
        }
        return true
    }
    static func validateTargetWeight(_ targetWeight: String) -> Bool {
        guard let targetWeightDouble = Double(targetWeight), targetWeightDouble > 30, targetWeightDouble < 400 else {
            return false
        }
        return true
    }
}

