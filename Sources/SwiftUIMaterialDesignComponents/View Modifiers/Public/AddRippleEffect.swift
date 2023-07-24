//
// 📄 AddRippleEffect.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

public extension View {

    /// Adds a Ripple Effect Animation for taps on  the view.
    /// - Parameters:
    ///   - color: The color of the Ripple Effect
    ///   - action: The action to run when the Ripple Effect is tapped.
    /// - Attention: Long Press Gestures are not recognized yet!
    @discardableResult func addRippleEffect(in color: Color, performing action: @escaping () -> Void = { }) -> some View {
        modifier(RippleEffectModifier(in: color, performing: action))
    }

}

private struct RippleEffectModifier: ViewModifier {

    @State private var isTapped = false
    @State private var isRippleEffectAnimationFinished = false
    @State private var tapLocation = CGPoint.zero

    let color: Color
    let externalAction: () -> Void

    init(in color: Color, performing action: @escaping () -> Void) {
        self.color = color
        self.externalAction = action
    }

    func body(content: Content) -> some View {
        rippleEffectLayer(over: content)
            .onChange(of: isRippleEffectAnimationFinished, perform: action)
    }

    @ViewBuilder func rippleEffectLayer(over content: Content) -> some View {
        // TODO: Respect View Shape -> import if we want to use it on a rounded button as well
        if #available(iOS 15.0, *) {
            content
                .contentShape(Rectangle())
                .onTapRecognition(update: $tapLocation, isPressed: $isTapped)
                .overlay(content: rippleEffect)
        } else {
            content
                .contentShape(Rectangle())
                .onTapRecognition(update: $tapLocation, isPressed: $isTapped)
                .overlay(iOS14RippleEffect)
        }
    }

    private func rippleEffect() -> some View {
        MDRippleEffect(isPressed: $isTapped, tapLocation: $tapLocation, rippleEffectColor: color, isFinished: $isRippleEffectAnimationFinished)
            .allowsHitTesting(false)
    }

    @available(iOS, deprecated: 15, message: "Also remove if #available check in body!")
    private var iOS14RippleEffect: some View {
        rippleEffect()
    }

    // MARK: Private View Logic

    private func action(if isRippleEffectAnimationFinished: Bool) {
        guard isRippleEffectAnimationFinished else { return }
        isTapped = false
        externalAction()
    }

}
