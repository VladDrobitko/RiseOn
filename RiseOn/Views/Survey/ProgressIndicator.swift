//
//  ProgressIndicator.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 11/02/2025.
//

import SwiftUI

struct ProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Rectangle()
                    .fill(index < currentStep ? Color.primaryButton : Color.gray.opacity(0.3))
                    .frame(height: 2) // Высота полоски
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: 120)// Ограничиваем ширину индикатора
    }
}

#Preview {
    ProgressIndicator(currentStep: 1, totalSteps: 6)
}
