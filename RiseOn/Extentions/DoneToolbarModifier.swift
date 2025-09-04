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
    
    func keyboardToolbar() -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    hideKeyboard()
                }
                .foregroundColor(.primaryButton)
                .font(.system(size: 16, weight: .medium))
            }
        }
    }
}
