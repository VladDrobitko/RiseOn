//
//  KeyboardAdaptive.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 07/02/2025.
//

import Foundation
import SwiftUI
import Combine

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    @State private var cancellables: Set<AnyCancellable> = []

    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, spacing: 0) { // Вместо padding используем safeAreaInset
                Color.clear.frame(height: keyboardHeight) // Добавляем прозрачный отступ
            }
            .onAppear {
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                    .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
                    .sink { notification in
                        if notification.name == UIResponder.keyboardWillShowNotification,
                           let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            withAnimation {
                                keyboardHeight = keyboardFrame.height
                            }
                        } else {
                            withAnimation {
                                keyboardHeight = 0
                            }
                        }
                    }
                    .store(in: &cancellables)
            }
            .onDisappear {
                cancellables.removeAll()
            }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        self.modifier(KeyboardAdaptive())
    }
}


