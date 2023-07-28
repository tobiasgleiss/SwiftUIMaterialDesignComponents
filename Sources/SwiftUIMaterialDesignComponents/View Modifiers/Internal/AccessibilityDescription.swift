//
// 📄 AccessibilityDescription.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

extension View {

    /// Adds a label and an optional hint to the view that describes its contents.
    /// - Parameters:
    ///   - label: A string that succinctly identifies the accessibility element.
    ///   - hint: A string that briefly describes the result of performing an action on the accessibility element.
    @discardableResult func accessibilityDescription(_ label: any StringProtocol, hint: (any StringProtocol)? = nil) -> some View {
        modifier(AccessibilityDescriptionModifier(label, hint: hint))
    }

}

private struct AccessibilityDescriptionModifier: ViewModifier {

    private let label: any StringProtocol
    private let hint: (any StringProtocol)?

    init(_ label: any StringProtocol, hint: (any StringProtocol)?) {
        self.label = label
        self.hint = hint
    }

    func body(content: Content) -> some View {
        if let hint {
            content
                .accessibilityLabel(label)
                .accessibilityHint(hint)
        } else {
            content
                .accessibilityLabel(label)
        }
    }

}
