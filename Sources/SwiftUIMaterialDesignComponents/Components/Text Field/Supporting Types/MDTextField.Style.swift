//
// 📄 MDTextField.Style.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

public extension MDTextField {

    struct Style {

        public static let filled = Style(appearance: .filled)
        public static let filledSecure = Style(appearance: .filled, isSecured: true)
        public static let outlined = Style(appearance: .outlined)
        public static let outlinedSecure = Style(appearance: .outlined, isSecured: true)

        let appearance: Appearance
        let focusedColor: Color
        let textColor: Color
        let textColorDisabled: Color
        let textFontSize: CGFloat
        let placeholderFontSize: CGFloat
        let backgroundColor: Color
        let backgroundColorDisabled: Color
        let borderColor: Color
        let borderColorDisabled: Color
        let textFieldHeight: CGFloat
        let errorFieldHeight: CGFloat
        let errorMessageFontSize: CGFloat
        let errorMessageColor: Color
        let errorMessageBackgroundColor: Color
        let cornerRadius: CGFloat
        let padding: (horizontal: CGFloat, vertical: CGFloat)
        let iconSize: CGSize
        let isSecured: Bool

        public init(
            appearance: Appearance,
            isSecured: Bool = false,
            focusedColor: Color = Style.Default.focusedAccentColor,
            textColor: Color = Style.Default.textColor,
            textColorDisabled: Color = Style.Default.disabledTextColor,
            textFontSize: CGFloat = Style.Default.fontSize,
            placeholderFontSize: CGFloat = Style.Default.placeholderFontSize,
            backgroundColor: Color = Style.Default.backgroundColor,
            backgroundColorDisabled: Color = Style.Default.disabledBackgroundColor,
            borderColor: Color = Style.Default.borderColor,
            borderColorDisabled: Color = Style.Default.disabledBorderColor,
            textFieldHeight: CGFloat = Style.Default.textFieldHeight,
            errorFieldHeight: CGFloat = Style.Default.errorFieldHeight,
            errorMessageFontSize: CGFloat = Style.Default.errorMessageFontSize,
            errorMessageColor: Color = Style.Default.errorMessageColor,
            errorMessageBackgroundColor: Color = Style.Default.errorMessageBackgroundColor,
            cornerRadius: CGFloat = Style.Default.cornerRadius,
            padding: (horizontal: CGFloat, vertical: CGFloat) = (Style.Default.horizontalPadding, Style.Default.verticalPadding),
            iconSize: CGSize = Style.Default.trailingIconSize
        ) {
            self.appearance = appearance
            self.focusedColor = focusedColor
            self.textColor = textColor
            self.textColorDisabled = textColorDisabled
            self.textFontSize = textFontSize
            self.placeholderFontSize = placeholderFontSize
            self.backgroundColor = backgroundColor
            self.backgroundColorDisabled = backgroundColorDisabled
            self.borderColor = borderColor
            self.borderColorDisabled = borderColorDisabled
            self.textFieldHeight = textFieldHeight
            self.errorFieldHeight = errorFieldHeight
            self.errorMessageFontSize = errorMessageFontSize
            self.errorMessageColor = errorMessageColor
            self.errorMessageBackgroundColor = errorMessageBackgroundColor
            self.cornerRadius = cornerRadius
            self.padding = padding
            self.iconSize = iconSize
            self.isSecured = isSecured
        }

        public struct Default {

            public static let textFieldHeight: CGFloat = 56
            public static let errorFieldHeight: CGFloat = 24
            public static let fontSize: CGFloat = 16
            public static let placeholderFontSize: CGFloat = 16
            public static let errorMessageFontSize: CGFloat = 13
            public static let horizontalPadding: CGFloat = 12
            public static let verticalPadding: CGFloat = 12
            public static let cornerRadius: CGFloat = 5
            public static let trailingIconSize = CGSize(width: 24, height: 24)

            public static let focusedAccentColor = Color(#colorLiteral(red: 0.3843137255, green: 0, blue: 0.9333333333, alpha: 1))
            public static let backgroundColor = Color(#colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1))
            public static let disabledBackgroundColor = Color(#colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1))
            public static let borderColor = Color(#colorLiteral(red: 0.4784313725, green: 0.4784313725, blue: 0.4784313725, alpha: 1))
            public static let disabledBorderColor = Color(#colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1))
            public static let textColor = Color(#colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1))
            public static let disabledTextColor = Color(#colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1))
            public static let errorMessageColor = Color(#colorLiteral(red: 0.8156862745, green: 0.2, blue: 0.1529411765, alpha: 1))
            public static let errorMessageBackgroundColor = Color(#colorLiteral(red: 0.9882352941, green: 0.9450980392, blue: 0.9294117647, alpha: 1))

        }

    }

}
