//
// 📄 mdButtonStyle.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public enum MDButtonStyle: Equatable {
    
    public static func == (lhs: MDButtonStyle, rhs: MDButtonStyle) -> Bool {
        return lhs.buttonColor == rhs.buttonColor &&
        lhs.textColor == rhs.textColor &&
        lhs.buttonFont == rhs.buttonFont &&
        lhs.buttonBorderWidth == rhs.buttonBorderWidth &&
        lhs.buttonCornerRadius == rhs.buttonCornerRadius &&
        lhs.rippleEffectColor == rhs.rippleEffectColor &&
        lhs.pendingIndicatorColor == rhs.pendingIndicatorColor &&
        lhs.buttonElevationShadow == rhs.buttonElevationShadow
    }
    
    
    case outlined(buttonColor: (normal: Color, disabled: Color) = (.mdOutlinedButtonDefaultColor, .mdOutlinedButtonDisabledDefaultColor), textColor: (normal: Color, disabled: Color) = (.mdOutlinedButtonCaptionDefaultColor, .mdOutlinedButtonCaptionDisabledDefaultColor), font: Font = .subheadline, borderWidth: CGFloat = 2, cornerRadius: CGFloat = 5, horizontalAlignment: HorizontalAlignment = .center, pendingIndicatorColor: Color = .mdOutlinedButtonPendingIndicatorDefaultColor)
    case contained(buttonColor: (normal: Color, disabled: Color) = (.mdContainedButtonDefaultColor, .mdContainedButtonDisabledDefaultColor), textColor: (normal: Color, disabled: Color) = (.mdContainedButtonCaptionDefaultColor, .mdContainedButtonCaptionDisabledDefaultColor), font: Font = .subheadline, borderWidth: CGFloat = 2, cornerRadius: CGFloat = 5, horizontalAlignment: HorizontalAlignment = .center, pendingIndicatorColor: Color = .mdContainedButtonPendingIndicatorDefaultColor)
    case text(buttonColor: (normal: Color, disabled: Color) = (.mdTextButtonDefaultColor, .mdTextButtonDisabledDefaultColor), textColor: (normal: Color, disabled: Color) = (.mdTextButtonCaptionDefaultColor, .mdTextButtonCaptionDisabledDefaultColor), font: Font = .subheadline, cornerRadius: CGFloat = 5, horizontalAlignment: HorizontalAlignment = .center, pendingIndicatorColor: Color = .mdTextButtonPendingIndicatorDefaultColor)
    
    var buttonColor: (normal: Color, disabled: Color) {
        switch self {
        case let .outlined(buttonColor, _, _, _, _, _, _): return buttonColor
        case let .contained(buttonColor, _, _, _, _, _, _): return buttonColor
        case let .text(buttonColor, _, _, _, _, _): return buttonColor
        }
    }
    
    var textColor: (normal: Color, disabled: Color) {
        switch self {
        case let .outlined(_, textColor, _, _, _, _, _): return textColor
        case let .contained(_, textColor, _, _, _, _, _): return textColor
        case let .text(_, textColor, _, _, _, _): return textColor
        }
    }
    
    var buttonFont: Font {
        switch self {
        case let .outlined(_, _, buttonFont, _, _, _, _): return buttonFont
        case let .contained(_, _, buttonFont, _, _, _, _): return buttonFont
        case let .text(_, _, buttonFont, _, _, _): return buttonFont
        }
    }
    
    var buttonBorderWidth: CGFloat {
        switch self {
        case let .outlined(_, _, _, borderWidth, _, _, _): return borderWidth
        case let .contained(_, _, _, borderWidth, _, _, _): return borderWidth
        case .text: return 0
        }
    }
    
    var buttonCornerRadius: CGFloat {
        switch self {
        case let .outlined(_, _, _, _, cornerRadius, _, _): return cornerRadius
        case let .contained(_, _, _, _, cornerRadius, _, _): return cornerRadius
        case let .text(_, _, _, cornerRadius, _, _): return cornerRadius
        }
    }
    
    var buttonAlignment: HorizontalAlignment {
        switch self {
        case let .outlined(_, _, _, _, _, horizontalAlignment, _): return horizontalAlignment
        case let .contained(_, _, _, _, _, horizontalAlignment, _): return horizontalAlignment
        case let .text(_, _, _, _, horizontalAlignment, _): return horizontalAlignment
            
        }
    }
    
    var rippleEffectColor: (whileActive: Color, whilePending: Color) {
        switch self {
        case .outlined: return (whileActive: buttonColor.normal, whilePending: .clear)
        case .contained: return (whileActive: .white, whilePending: .clear)
        case .text: return (whileActive: buttonColor.normal, whilePending: .clear)
        }
    }
    
    var pendingIndicatorColor: Color {
        switch self {
        case let .outlined(_, _, _, _, _, _, pendingIndicatorColor): return pendingIndicatorColor
        case let .contained(_, _, _, _, _, _, pendingIndicatorColor): return pendingIndicatorColor
        case let .text(_, _, _, _, _, pendingIndicatorColor): return pendingIndicatorColor
        }
    }
    
    var buttonElevationShadow: (radius: CGFloat, color: Color) {
        switch self {
        case .outlined: return (radius: 0, color: .clear)
        case .contained: return (radius: 8, color: .black.opacity(0.2))
        case .text: return (radius: 0, color: .clear)
        }
    }
    
    
}

public extension Color {
    
    // Default values for Material Design outlined button
    static let mdOutlinedButtonDefaultColor: Color = Color(#colorLiteral(red: 0.3843137255, green: 0, blue: 0.9333333333, alpha: 1))
    static let mdOutlinedButtonDisabledDefaultColor: Color = .gray
    static let mdOutlinedButtonCaptionDefaultColor: Color = Color(#colorLiteral(red: 0.3843137255, green: 0, blue: 0.9333333333, alpha: 1))
    static let mdOutlinedButtonCaptionDisabledDefaultColor: Color = .gray
    static let mdOutlinedButtonPendingIndicatorDefaultColor: Color = Color(#colorLiteral(red: 0.3843137255, green: 0, blue: 0.9333333333, alpha: 1))
    
    // Default values for Material Design contained button
    static let mdContainedButtonDefaultColor: Color = Color(#colorLiteral(red: 0.3843137255, green: 0, blue: 0.9333333333, alpha: 1))
    static let mdContainedButtonDisabledDefaultColor: Color = .gray
    static let mdContainedButtonCaptionDefaultColor: Color = .white
    static let mdContainedButtonCaptionDisabledDefaultColor: Color = .white.opacity(0.5)
    static let mdContainedButtonPendingIndicatorDefaultColor: Color = .white
    
    // Default values for Material Design text button
    static let mdTextButtonDefaultColor: Color = Color(#colorLiteral(red: 0.3843137255, green: 0, blue: 0.9333333333, alpha: 1))
    static let mdTextButtonDisabledDefaultColor: Color = .clear
    static let mdTextButtonCaptionDefaultColor: Color = Color(#colorLiteral(red: 0.3843137255, green: 0, blue: 0.9333333333, alpha: 1))
    static let mdTextButtonCaptionDisabledDefaultColor: Color = .gray
    static let mdTextButtonPendingIndicatorDefaultColor: Color = Color(#colorLiteral(red: 0.3843137255, green: 0, blue: 0.9333333333, alpha: 1))
    
}
