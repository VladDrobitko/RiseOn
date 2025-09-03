//
//  Typography.swift
//  RiseOn
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI

// MARK: - Typography System
/// Единая типографическая система для RiseOn
struct RiseOnTypography {
    
    // MARK: - Font Weights
    enum FontWeight {
        case light
        case regular
        case medium
        case semibold
        case bold
        
        var swiftUIWeight: Font.Weight {
            switch self {
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            }
        }
    }
    
    // MARK: - Typography Styles
    
    /// Главные заголовки (экраны, модальные окна)
    static func heading1(_ weight: FontWeight = .bold) -> Font {
        return Font.system(size: DesignTokens.Typography.heading1, weight: weight.swiftUIWeight)
    }
    
    /// Заголовки секций
    static func heading2(_ weight: FontWeight = .semibold) -> Font {
        return Font.system(size: DesignTokens.Typography.heading2, weight: weight.swiftUIWeight)
    }
    
    /// Заголовки подсекций
    static func heading3(_ weight: FontWeight = .medium) -> Font {
        return Font.system(size: DesignTokens.Typography.heading3, weight: weight.swiftUIWeight)
    }
    
    /// Мелкие заголовки
    static func heading4(_ weight: FontWeight = .medium) -> Font {
        return Font.system(size: DesignTokens.Typography.heading4, weight: weight.swiftUIWeight)
    }
    
    /// Основной текст
    static func body(_ weight: FontWeight = .regular) -> Font {
        return Font.system(size: DesignTokens.Typography.body, weight: weight.swiftUIWeight)
    }
    
    /// Мелкий основной текст
    static func bodySmall(_ weight: FontWeight = .regular) -> Font {
        return Font.system(size: DesignTokens.Typography.bodySmall, weight: weight.swiftUIWeight)
    }
    
    /// Подписи и вторичный текст
    static func caption(_ weight: FontWeight = .regular) -> Font {
        return Font.system(size: DesignTokens.Typography.caption, weight: weight.swiftUIWeight)
    }
    
    /// Очень мелкий текст
    static func overline(_ weight: FontWeight = .medium) -> Font {
        return Font.system(size: DesignTokens.Typography.overline, weight: weight.swiftUIWeight)
    }
    
    // MARK: - Special Typography (для специфичных случаев)
    
    /// Текст на кнопках
    static var button: Font {
        return Font.system(size: DesignTokens.Typography.body, weight: .medium)
    }
    
    /// Текст в полях ввода
    static var textField: Font {
        return Font.system(size: DesignTokens.Typography.body, weight: .regular)
    }
    
    /// Плейсхолдеры в полях ввода
    static var placeholder: Font {
        return Font.system(size: DesignTokens.Typography.body, weight: .light)
    }
    
    /// Навигационные заголовки
    static var navigationTitle: Font {
        return Font.system(size: DesignTokens.Typography.heading3, weight: .semibold)
    }
    
    /// Текст на табах
    static var tabTitle: Font {
        return Font.system(size: DesignTokens.Typography.caption, weight: .medium)
    }
}

// MARK: - Text Style Modifiers
extension Text {
    
    // MARK: - Headings
    func riseOnHeading1(_ weight: RiseOnTypography.FontWeight = .bold) -> some View {
        self.font(RiseOnTypography.heading1(weight))
            .lineSpacing(DesignTokens.Typography.lineHeightTight - 1)
    }
    
    func riseOnHeading2(_ weight: RiseOnTypography.FontWeight = .semibold) -> some View {
        self.font(RiseOnTypography.heading2(weight))
            .lineSpacing(DesignTokens.Typography.lineHeightTight - 1)
    }
    
    func riseOnHeading3(_ weight: RiseOnTypography.FontWeight = .medium) -> some View {
        self.font(RiseOnTypography.heading3(weight))
            .lineSpacing(DesignTokens.Typography.lineHeightTight - 1)
    }
    
    func riseOnHeading4(_ weight: RiseOnTypography.FontWeight = .medium) -> some View {
        self.font(RiseOnTypography.heading4(weight))
            .lineSpacing(DesignTokens.Typography.lineHeightNormal - 1)
    }
    
    // MARK: - Body Text
    func riseOnBody(_ weight: RiseOnTypography.FontWeight = .regular) -> some View {
        self.font(RiseOnTypography.body(weight))
            .lineSpacing(DesignTokens.Typography.lineHeightNormal - 1)
    }
    
    func riseOnBodySmall(_ weight: RiseOnTypography.FontWeight = .regular) -> some View {
        self.font(RiseOnTypography.bodySmall(weight))
            .lineSpacing(DesignTokens.Typography.lineHeightNormal - 1)
    }
    
    func riseOnCaption(_ weight: RiseOnTypography.FontWeight = .regular) -> some View {
        self.font(RiseOnTypography.caption(weight))
            .lineSpacing(DesignTokens.Typography.lineHeightNormal - 1)
    }
    
    func riseOnOverline(_ weight: RiseOnTypography.FontWeight = .medium) -> some View {
        self.font(RiseOnTypography.overline(weight))
            .lineSpacing(DesignTokens.Typography.lineHeightTight - 1)
            .textCase(.uppercase)
    }
    
    // MARK: - Special Styles
    func riseOnButton() -> some View {
        self.font(RiseOnTypography.button)
    }
    
    func riseOnPlaceholder() -> some View {
        self.font(RiseOnTypography.placeholder)
            .foregroundColor(.typographyGrey)
    }
    
    func riseOnNavigationTitle() -> some View {
        self.font(RiseOnTypography.navigationTitle)
    }
    
    func riseOnTabTitle() -> some View {
        self.font(RiseOnTypography.tabTitle)
    }
}

// MARK: - Preview для демонстрации типографики
struct TypographyPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                Group {
                    Text("Heading 1 - Main Titles")
                        .riseOnHeading1()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Heading 2 - Section Titles")
                        .riseOnHeading2()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Heading 3 - Subsection Titles")
                        .riseOnHeading3()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Heading 4 - Small Headings")
                        .riseOnHeading4()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Body - Main content text that provides detailed information and explanations. This is the primary text style used throughout the application for paragraphs and content.")
                        .riseOnBody()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Body Small - Secondary content text for less important information")
                        .riseOnBodySmall()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Caption - Supplementary text, descriptions, and metadata")
                        .riseOnCaption()
                        .foregroundColor(.typographyGrey)
                    
                    Text("Overline - Labels and categories")
                        .riseOnOverline()
                        .foregroundColor(.typographyGrey)
                }
                
                Divider()
                    .background(Color.typographyGrey)
                
                Group {
                    Text("Button Text Style")
                        .riseOnButton()
                        .foregroundColor(.black)
                        .padding(DesignTokens.Padding.button)
                        .background(Color.primaryButton)
                        .cornerRadius(DesignTokens.Radius.button)
                    
                    Text("Navigation Title")
                        .riseOnNavigationTitle()
                        .foregroundColor(.typographyPrimary)
                    
                    Text("Tab Title")
                        .riseOnTabTitle()
                        .foregroundColor(.typographyGrey)
                }
            }
            .padding(DesignTokens.Padding.screen)
        }
        .background(Color.black)
    }
}

#Preview {
    TypographyPreview()
        .preferredColorScheme(.dark)
}
