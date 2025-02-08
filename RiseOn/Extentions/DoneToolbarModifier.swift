//
//  DoneToolbarModifier.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 08/02/2025.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
