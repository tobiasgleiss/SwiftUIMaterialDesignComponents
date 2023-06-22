//
// 📄 ConditionalFrameModifier.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

extension View {

    /// Sets the width of the view based on a condition.
    @discardableResult func conditionalFrameWidth(_ width: CGFloat, if isActive: Bool) -> some View {
        modifier(ConditionalFrameModifier(isActive: isActive, width: width))
    }

    /// Sets the height of the view based on a condition.
    @discardableResult func conditionalFrameHeight(_ height: CGFloat, if isActive: Bool) -> some View {
        modifier(ConditionalFrameModifier(isActive: isActive, height: height))
    }

    /// Sets the frame of the view based on a condition.
    @discardableResult func conditionalFrame(width: CGFloat, height: CGFloat, if isActive: Bool) -> some View {
        modifier(ConditionalFrameModifier(isActive: isActive, width: width, height: height))
    }

}

private struct ConditionalFrameModifier: ViewModifier {

    private var isActive: Bool
    private var width: CGFloat?
    private var height: CGFloat?

    init(isActive: Bool, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.isActive = isActive
        self.width = width
        self.height = height
    }

    @ViewBuilder func body(content: Content) -> some View {
        if isActive {
            content
                .frame(width: width, height: height)
        } else {
            content
        }
    }

}
