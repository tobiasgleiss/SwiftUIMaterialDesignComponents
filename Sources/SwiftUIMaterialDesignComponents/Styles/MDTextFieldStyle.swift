//
// 📄 MDTextFieldStyle.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

public enum MDTextFieldStyle: Equatable {
    
    case filled(
        focusedColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultFocusedColor,
        textColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultTextColor,
        textColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultTextColor,
        backgroundColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultBackgroundColor,
        backgroundColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultBackgroundColor,
        borderColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultBorderColor,
        borderColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultBorderColor,
        textFieldHeight: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultHeight,
        errorFieldHeight: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultErrorFieldHeight,
        errorMessageFontSize: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageFontSize,
        errorMessageColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageColor,
        errorMessageBackgroundColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageBackgroundColor,
        cornerRadius: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultTopCornerRadius,
        padding: (horizontal: CGFloat, vertical: CGFloat) = (MDTextFieldStyle.mdFilledTextFieldDefaultHorizontalPadding, MDTextFieldStyle.mdFilledTextFieldDefaultVerticalPadding),
        icon: Image? = nil,
        iconSize: CGSize = MDTextFieldStyle.mdFilledTextFieldDefaultTrailingIconSize)
    
    case filledSecured(
        focusedColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultFocusedColor,
        textColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultTextColor,
        textColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultTextColor,
        backgroundColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultBackgroundColor,
        backgroundColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultBackgroundColor,
        borderColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultBorderColor,
        borderColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultBorderColor,
        textFieldHeight: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultHeight,
        errorFieldHeight: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultErrorFieldHeight,
        errorMessageFontSize: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageFontSize,
        errorMessageColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageColor,
        errorMessageBackgroundColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageBackgroundColor,
        cornerRadius: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultTopCornerRadius,
        padding: (horizontal: CGFloat, vertical: CGFloat) = (MDTextFieldStyle.mdFilledTextFieldDefaultHorizontalPadding, MDTextFieldStyle.mdFilledTextFieldDefaultVerticalPadding),
        secureIcon: (slashed: Image, unslashed: Image) = (MDTextFieldStyle.mdFilledSecuredTextFieldDefaultSlashedImage, MDTextFieldStyle.mdFilledSecuredTextFieldDefaultUnslashedImage),
        iconSize: CGSize = MDTextFieldStyle.mdFilledTextFieldDefaultTrailingIconSize,
        securedByDefault: Bool = true)
    
    // TODO: Remove background color from .outlined
    case outlined(
        focusedColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultFocusedColor,
        textColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultTextColor,
        textColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultTextColor,
        backgroundColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultBackgroundColor,
        backgroundColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultBackgroundColor,
        borderColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultBorderColor,
        borderColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultBorderColor,
        textFieldHeight: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultHeight,
        errorFieldHeight: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultErrorFieldHeight,
        errorMessageFontSize: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageFontSize,
        errorMessageColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageColor,
        errorMessageBackgroundColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageBackgroundColor,
        cornerRadius: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultTopCornerRadius,
        padding: (horizontal: CGFloat, vertical: CGFloat) = (MDTextFieldStyle.mdFilledTextFieldDefaultHorizontalPadding, MDTextFieldStyle.mdFilledTextFieldDefaultVerticalPadding),
        icon: Image? = nil,
        iconSize: CGSize = MDTextFieldStyle.mdFilledTextFieldDefaultTrailingIconSize)
    
    case outlinedSecured(
        focusedColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultFocusedColor,
        textColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultTextColor,
        textColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultTextColor,
        backgroundColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultBackgroundColor,
        backgroundColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultBackgroundColor,
        borderColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultBorderColor,
        borderColorDisabled: Color = MDTextFieldStyle.mdFilledDisabledTextFieldDefaultBorderColor,
        textFieldHeight: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultHeight,
        errorFieldHeight: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultErrorFieldHeight,
        errorMessageFontSize: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageFontSize,
        errorMessageColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageColor,
        errorMessageBackgroundColor: Color = MDTextFieldStyle.mdFilledTextFieldDefaultErrorMessageBackgroundColor,
        cornerRadius: CGFloat = MDTextFieldStyle.mdFilledTextFieldDefaultTopCornerRadius,
        padding: (horizontal: CGFloat, vertical: CGFloat) = (MDTextFieldStyle.mdFilledTextFieldDefaultHorizontalPadding, MDTextFieldStyle.mdFilledTextFieldDefaultVerticalPadding),
        secureIcon: (slashed: Image, unslashed: Image) = (MDTextFieldStyle.mdFilledSecuredTextFieldDefaultSlashedImage, MDTextFieldStyle.mdFilledSecuredTextFieldDefaultUnslashedImage),
        iconSize: CGSize = MDTextFieldStyle.mdFilledTextFieldDefaultTrailingIconSize,
        securedByDefault: Bool = true)
    
    var focusedColor: Color {
        switch self {
        case let .filled(color, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .filledSecured(color, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlined(color, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlinedSecured(color, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        }
    }
    
    var textColor: Color {
        switch self {
        case let .filled(_, color, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .filledSecured(_, color, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlined(_, color, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlinedSecured(_, color, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        }
    }
    
    var textColorDisabled: Color {
        switch self {
        case let .filled(_, _, color, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .filledSecured(_, _, color, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlined(_, _, color, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlinedSecured(_, _, color, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case let .filled(_, _, _, color, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .filledSecured(_, _, _, color, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlined(_, _, _, color, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlinedSecured(_, _, _, color, _, _, _, _, _, _, _, _, _, _, _, _, _): return color
        }
    }
    
    var backgroundColorDisabled: Color {
        switch self {
        case let .filled(_, _, _, _, color, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .filledSecured(_, _, _, _, color, _, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlined(_, _, _, _, color, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlinedSecured(_, _, _, _, color, _, _, _, _, _, _, _, _, _, _, _, _): return color
        }
    }
    
    var borderColor: Color {
        switch self {
        case let .filled(_, _, _, _, _, color, _, _, _, _, _, _, _, _, _, _): return color
        case let .filledSecured(_, _, _, _, _, color, _, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlined(_, _, _, _, _, color, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlinedSecured(_, _, _, _, _, color, _, _, _, _, _, _, _, _, _, _, _): return color
        }
    }
    
    var borderColorDisabled: Color {
        switch self {
        case let .filled(_, _, _, _, _, _, color, _, _, _, _, _, _, _, _, _): return color
        case let .filledSecured(_, _, _, _, _, _, color, _, _, _, _, _, _, _, _, _, _): return color
        case let .outlined(_, _, _, _, _, _, color, _, _, _, _, _, _, _, _, _): return color
        case let .outlinedSecured(_, _, _, _, _, _, color, _, _, _, _, _, _, _, _, _, _): return color
        }
    }
    
    var textFieldHeight: CGFloat {
        switch self {
        case let .filled(_, _, _, _, _, _, _, height, _, _, _, _, _, _, _, _): return height
        case let .filledSecured(_, _, _, _, _, _, _, height, _, _, _, _, _, _, _, _, _): return height
        case let .outlined(_, _, _, _, _, _, _, height, _, _, _, _, _, _, _, _): return height
        case let .outlinedSecured(_, _, _, _, _, _, _, height, _, _, _, _, _, _, _, _, _): return height
        }
    }
    
    var errorFieldHeight: CGFloat {
        switch self {
        case let .filled(_, _, _, _, _, _, _, _, height, _, _, _, _, _, _, _): return height
        case let .filledSecured(_, _, _, _, _, _, _, _, height, _, _, _, _, _, _, _, _): return height
        case let .outlined(_, _, _, _, _, _, _, _, height, _, _, _, _, _, _, _): return height
        case let .outlinedSecured(_, _, _, _, _, _, _, _, height, _, _, _, _, _, _, _, _): return height
        }
    }
    
    var errorMessageFontSize: CGFloat {
        switch self {
        case let .filled(_, _, _, _, _, _, _, _, _, size, _, _, _, _, _, _): return size
        case let .filledSecured(_, _, _, _, _, _, _, _, _, size, _, _, _, _, _, _, _): return size
        case let .outlined(_, _, _, _, _, _, _, _, _, size, _, _, _, _, _, _): return size
        case let .outlinedSecured(_, _, _, _, _, _, _, _, _, size, _, _, _, _, _, _, _): return size
        }
    }
    
    var errorMessageColor: Color {
        switch self {
        case let .filled(_, _, _, _, _, _, _, _, _, _, color, _, _, _, _, _): return color
        case let .filledSecured(_, _, _, _, _, _, _, _, _, _, color, _, _, _, _, _, _): return color
        case let .outlined(_, _, _, _, _, _, _, _, _, _, color, _, _, _, _, _): return color
        case let .outlinedSecured(_, _, _, _, _, _, _, _, _, _, color, _, _, _, _, _, _): return color
        }
    }
    
    var errorMessageBackgroundColor: Color {
        switch self {
        case let .filled(_, _, _, _, _, _, _, _, _, _, _, color, _, _, _, _): return color
        case let .filledSecured(_, _, _, _, _, _, _, _, _, _, _, color, _, _, _, _, _): return color
        case let .outlined(_, _, _, _, _, _, _, _, _, _, _, color, _, _, _, _): return color
        case let .outlinedSecured(_, _, _, _, _, _, _, _, _, _, _, color, _, _, _, _, _): return color
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case let .filled(_, _, _, _, _, _, _, _, _, _, _, _, radius, _, _, _): return radius
        case let .filledSecured(_, _, _, _, _, _, _, _, _, _, _, _, radius, _, _, _, _): return radius
        case let .outlined(_, _, _, _, _, _, _, _, _, _, _, _, radius, _, _, _): return radius
        case let .outlinedSecured(_, _, _, _, _, _, _, _, _, _, _, _, radius, _, _, _, _): return radius
        }
    }
    
    var padding: (horizontal: CGFloat, vertical: CGFloat) {
        switch self {
        case let .filled(_, _, _, _, _, _, _, _, _, _, _, _, _, padding, _, _): return padding
        case let .filledSecured(_, _, _, _, _, _, _, _, _, _, _, _, _, padding, _, _, _): return padding
        case let .outlined(_, _, _, _, _, _, _, _, _, _, _, _, _, padding, _, _): return padding
        case let .outlinedSecured(_, _, _, _, _, _, _, _, _, _, _, _, _, padding, _, _, _): return padding
        }
    }
    
    var icon: Image? {
        switch self {
        case let .filled(_, _, _, _, _, _, _, _, _, _, _, _, _, _, icon, _): return icon
        case .filledSecured(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return nil
        case let .outlined(_, _, _, _, _, _, _, _, _, _, _, _, _, _, icon, _): return icon
        case .outlinedSecured(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return nil
        }
    }
    
    var secureIcon: (slashed: Image, unslashed: Image)? {
        switch self {
        case .filled(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return nil
        case let .filledSecured(_, _, _, _, _, _, _, _, _, _, _, _, _, _, icon, _, _): return icon
        case .outlined(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return nil
        case let .outlinedSecured(_, _, _, _, _, _, _, _, _, _, _, _, _, _, icon, _, _): return icon
        }
    }
    
    var iconSize: CGSize {
        switch self {
        case let .filled(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, size): return size
        case let .filledSecured(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, size, _): return size
        case let .outlined(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, size): return size
        case let .outlinedSecured(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, size, _): return size
        }
    }
    
    var isSecured: Bool {
        switch self {
        case .filled(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return false
        case let .filledSecured(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, isSecured): return isSecured
        case .outlined(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _): return false
        case let .outlinedSecured(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, isSecured): return isSecured
        }
    }
    
    public static func == (lhs: MDTextFieldStyle, rhs: MDTextFieldStyle) -> Bool {
        return lhs.focusedColor == rhs.focusedColor &&
        lhs.textColor == rhs.textColor &&
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.borderColor == rhs.borderColor &&
        lhs.textFieldHeight == rhs.textFieldHeight &&
        lhs.errorFieldHeight == rhs.errorFieldHeight &&
        lhs.errorMessageFontSize == rhs.errorMessageFontSize &&
        lhs.errorMessageColor == rhs.errorMessageColor &&
        lhs.errorMessageBackgroundColor == rhs.errorMessageBackgroundColor &&
        lhs.cornerRadius == rhs.cornerRadius &&
        lhs.padding == rhs.padding &&
        lhs.iconSize == rhs.iconSize &&
        lhs.isSecured == rhs.isSecured
    }
    
    // Default values
    public static let mdFilledTextFieldDefaultHeight = CGFloat(56)
    public static let mdFilledTextFieldDefaultErrorFieldHeight = CGFloat(24)
    public static let mdFilledTextFieldDefaultErrorMessageFontSize = CGFloat(13)
    public static let mdFilledTextFieldDefaultHorizontalPadding = CGFloat(12)
    public static let mdFilledTextFieldDefaultVerticalPadding = CGFloat(12)
    public static let mdFilledTextFieldDefaultTopCornerRadius = CGFloat(5)
    public static let mdFilledTextFieldDefaultTrailingIconSize = CGSize(width: 24, height: 24)
    
    // Default Colors
    public static let mdFilledTextFieldDefaultFocusedColor = Color(#colorLiteral(red: 0.3843137255, green: 0, blue: 0.9333333333, alpha: 1))
    public static let mdFilledTextFieldDefaultBackgroundColor = Color(#colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1))
    public static let mdFilledDisabledTextFieldDefaultBackgroundColor = Color(#colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1))
    public static let mdFilledTextFieldDefaultBorderColor = Color(#colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1))
    public static let mdFilledDisabledTextFieldDefaultBorderColor = Color(#colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1))
    public static let mdFilledTextFieldDefaultTextColor = Color(#colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1))
    public static let mdFilledDisabledTextFieldDefaultTextColor = Color(#colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1))
    public static let mdFilledTextFieldDefaultErrorMessageColor = Color(#colorLiteral(red: 0.8156862745, green: 0.2, blue: 0.1529411765, alpha: 1))
    public static let mdFilledTextFieldDefaultErrorMessageBackgroundColor = Color(#colorLiteral(red: 0.9882352941, green: 0.9450980392, blue: 0.9294117647, alpha: 1))
    
    // Default Images
    public static let mdFilledSecuredTextFieldDefaultSlashedImage = Image(systemName: "eye.slash.fill")
    public static let mdFilledSecuredTextFieldDefaultUnslashedImage = Image(systemName: "eye.fill")
    
}
