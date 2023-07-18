//
// 📄 MDButton.Style.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public extension MDButton {

    struct ColorPair: Equatable {

        let primary: Color
        let secondary: Color

        public init(_ active: Color, disabled: Color) {
            self.primary = active
            self.secondary = disabled
        }

    }

    struct Style: Equatable {

        enum BaseType {
            case contained
            case outlined
            case textOnly
            case bannerAction
        }

        let baseType: BaseType
        let buttonColor: ColorPair
        let textColor: ColorPair
        let buttonAlignment: HorizontalAlignment?
        let font: Font
        let borderWidth: CGFloat
        let cornerRadius: CGFloat
        let activityIndicatorColor: Color
        let rippleEffectColor: ColorPair
        let shadowColor: Color
        let elevation: CGFloat

        private init(baseType: BaseType, buttonColor: ColorPair, textColor: ColorPair, buttonAlignment: HorizontalAlignment? = .center, font: Font = .subheadline, borderWidth: CGFloat = 2, cornerRadius: CGFloat = 5) {
            self.baseType = baseType
            self.buttonColor = buttonColor
            self.textColor = textColor
            self.buttonAlignment = buttonAlignment
            self.font = font
            self.borderWidth = borderWidth
            self.cornerRadius = cornerRadius
            self.activityIndicatorColor = textColor.primary
            self.rippleEffectColor = ColorPair(textColor.primary, disabled: .clear)
            self.shadowColor = baseType == .contained ? .black.opacity(0.2) : .clear // TODO: Handling for Dark Mode -> No Elevation, something else?
            self.elevation = baseType == .contained ? 8 : 0
        }

        public static let contained = contained()
        public static func contained(buttonColor: ColorPair = .defaultMaterialAccent, textColor: ColorPair = .defaultMaterialForeground, buttonAlignment: HorizontalAlignment = .center, font: Font = .subheadline, borderWidth: CGFloat = 2, cornerRadius: CGFloat = 5) -> Style {
            Style(baseType: .contained, buttonColor: buttonColor, textColor: textColor, buttonAlignment: buttonAlignment, font: font, borderWidth: borderWidth, cornerRadius: cornerRadius)
        }

        public static let outlined = outlined()
        public static func outlined(buttonColor: ColorPair = .defaultMaterialAccent, textColor: ColorPair = .defaultMaterialAccent, buttonAlignment: HorizontalAlignment = .center, font: Font = .subheadline, borderWidth: CGFloat = 2, cornerRadius: CGFloat = 5) -> Style {
            Style(baseType: .outlined, buttonColor: buttonColor, textColor: textColor, buttonAlignment: buttonAlignment, font: font, borderWidth: borderWidth, cornerRadius: cornerRadius)
        }

        public static let textOnly = textOnly()
        public static func textOnly(buttonColor: ColorPair = .defaultMaterialAccent, textColor: ColorPair = .defaultMaterialAccent, buttonAlignment: HorizontalAlignment = .center, font: Font = .subheadline, borderWidth: CGFloat = 0, cornerRadius: CGFloat = 5) -> Style {
            Style(baseType: .textOnly, buttonColor: buttonColor, textColor: textColor, buttonAlignment: buttonAlignment, font: font, borderWidth: borderWidth, cornerRadius: cornerRadius)
        }

        internal static let bannerAction = bannerAction()
        internal static func bannerAction(textColor: ColorPair = .defaultMaterialAccent, font: Font = .subheadline) -> Style {
            Style(baseType: .bannerAction, buttonColor: .defaultMaterialAccent, textColor: textColor, buttonAlignment: nil, font: font, borderWidth: 0, cornerRadius: 5)
        }

        internal var isTextOnly: Bool {
            switch baseType {
            case .textOnly: return true
            default:
                return false
            }
        }

    }

}

public extension MDButton.ColorPair {

    static let defaultMaterialAccent = MDButton.ColorPair(.defaultMaterialAccent, disabled: .gray)
    static let defaultMaterialForeground = MDButton.ColorPair(.white, disabled: .white.opacity(0.5))

}

public extension Color {

    static let defaultMaterialAccent = Color(#colorLiteral(red: 0.3843137255, green: 0, blue: 0.9333333333, alpha: 1))

}
