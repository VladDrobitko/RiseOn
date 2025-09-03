//
//  DesignTokens.swift
//  RiseOn
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI

// MARK: - Design Tokens
/// Централизованные значения для всей дизайн-системы RiseOn
struct DesignTokens {
    
    // MARK: - Spacing (8px grid system)
    struct Spacing {
        static let xs: CGFloat = 4      // Очень маленькие отступы
        static let sm: CGFloat = 8      // Маленькие отступы между элементами
        static let md: CGFloat = 12     // Средние отступы
        static let lg: CGFloat = 16     // Стандартные отступы (основные)
        static let xl: CGFloat = 20     // Большие отступы
        static let xxl: CGFloat = 24    // Очень большие отступы
        static let xxxl: CGFloat = 32   // Максимальные отступы
        
        // Специальные значения
        static let screenPadding: CGFloat = lg      // 16px - основные отступы экрана
        static let cardPadding: CGFloat = md        // 12px - внутри карточек
        static let buttonPadding: CGFloat = lg      // 16px - внутри кнопок
        static let sectionSpacing: CGFloat = xxl    // 24px - между секциями
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let xs: CGFloat = 4      // Мелкие элементы
        static let sm: CGFloat = 8      // Карточки, поля ввода
        static let md: CGFloat = 12     // Кнопки, основные элементы
        static let lg: CGFloat = 16     // Крупные карточки
        static let xl: CGFloat = 20     // Модальные окна, специальные элементы
        static let xxl: CGFloat = 24    // Очень крупные элементы
        
        // Специальные значения
        static let button: CGFloat = md         // 12px - стандартные кнопки
        static let card: CGFloat = sm           // 8px - карточки
        static let modal: CGFloat = xl          // 20px - модальные окна
        static let pill: CGFloat = 50           // Полностью скругленные элементы
    }
    
    // MARK: - Typography Scale
    struct Typography {
        // Размеры шрифтов
        static let heading1: CGFloat = 32       // Главные заголовки
        static let heading2: CGFloat = 24       // Заголовки секций
        static let heading3: CGFloat = 20       // Заголовки подсекций
        static let heading4: CGFloat = 18       // Мелкие заголовки
        static let body: CGFloat = 16           // Основной текст
        static let bodySmall: CGFloat = 14      // Мелкий основной текст
        static let caption: CGFloat = 12        // Подписи
        static let overline: CGFloat = 10       // Очень мелкий текст
        
        // Высота строк (line height)
        static let lineHeightTight: CGFloat = 1.2    // Для заголовков
        static let lineHeightNormal: CGFloat = 1.4   // Для основного текста
        static let lineHeightRelaxed: CGFloat = 1.6  // Для длинного текста
    }
    
    // MARK: - Elevation (Shadow/Blur)
    struct Elevation {
        // Тени для карточек и элементов
        static let none = (radius: CGFloat(0), x: CGFloat(0), y: CGFloat(0))
        static let sm = (radius: CGFloat(2), x: CGFloat(0), y: CGFloat(1))
        static let md = (radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
        static let lg = (radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
        static let xl = (radius: CGFloat(16), x: CGFloat(0), y: CGFloat(8))
        
        // Специальные тени
        static let button = md      // Для кнопок
        static let card = sm        // Для карточек
        static let modal = xl       // Для модальных окон
    }
    
    // MARK: - Animation Duration
    struct Animation {
        static let fast: Double = 0.15          // Быстрые анимации (hover)
        static let normal: Double = 0.25        // Стандартные анимации
        static let slow: Double = 0.4           // Медленные анимации (появление экранов)
        static let splash: Double = 2.0         // Длительность splash screen
        
        // Специальные анимации
        static let button: Double = fast        // Анимации кнопок
        static let modal: Double = normal       // Модальные окна
        static let transition: Double = slow    // Переходы между экранами
    }
    
    // MARK: - Sizes
    struct Sizes {
        // Высота элементов
        static let buttonHeight: CGFloat = 52           // Стандартная высота кнопок
        static let buttonHeightSmall: CGFloat = 40      // Маленькие кнопки
        static let textFieldHeight: CGFloat = 48        // Поля ввода
        static let tabBarHeight: CGFloat = 60           // Tab bar
        static let navigationBarHeight: CGFloat = 44    // Navigation bar
        
        // Ширина элементов
        static let buttonMinWidth: CGFloat = 120        // Минимальная ширина кнопки
        static let modalMaxWidth: CGFloat = 400         // Максимальная ширина модального окна
        
        // Иконки
        static let iconSmall: CGFloat = 16              // Маленькие иконки
        static let iconMedium: CGFloat = 24             // Средние иконки
        static let iconLarge: CGFloat = 32              // Большие иконки
        static let iconXLarge: CGFloat = 48             // Очень большие иконки
        
        // Специальные размеры
        static let progressIndicatorHeight: CGFloat = 4  // Индикатор прогресса
        static let dividerHeight: CGFloat = 1           // Разделители
    }
    
    // MARK: - Opacity Levels
    struct Opacity {
        static let invisible: Double = 0.0      // Полностью прозрачный
        static let faint: Double = 0.1          // Очень слабый
        static let light: Double = 0.3          // Слабый
        static let medium: Double = 0.5         // Средний
        static let strong: Double = 0.7         // Сильный
        static let opaque: Double = 0.9         // Почти непрозрачный
        static let solid: Double = 1.0          // Полностью непрозрачный
        
        // Специальные значения
        static let disabled: Double = light     // Неактивные элементы
        static let overlay: Double = medium     // Overlay для модальных окон
        static let separator: Double = faint    // Разделители
    }
}

// MARK: - Convenience Extensions
extension DesignTokens {
    
    /// Быстрый доступ к основным отступам
    struct Padding {
        static let screen = DesignTokens.Spacing.screenPadding
        static let card = DesignTokens.Spacing.cardPadding
        static let button = DesignTokens.Spacing.buttonPadding
        static let section = DesignTokens.Spacing.sectionSpacing
    }
    
    /// Быстрый доступ к скруглениям
    struct Radius {
        static let button = DesignTokens.CornerRadius.button
        static let card = DesignTokens.CornerRadius.card
        static let modal = DesignTokens.CornerRadius.modal
        static let pill = DesignTokens.CornerRadius.pill
    }
    
    /// Быстрый доступ к размерам
    struct Size {
        static let button = DesignTokens.Sizes.buttonHeight
        static let buttonSmall = DesignTokens.Sizes.buttonHeightSmall
        static let textField = DesignTokens.Sizes.textFieldHeight
        static let icon = DesignTokens.Sizes.iconMedium
    }
}
