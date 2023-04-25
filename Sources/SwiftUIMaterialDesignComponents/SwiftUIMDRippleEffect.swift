//
// 📄 SwiftUIMDRippleEffect.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct SwiftUIMDRippleEffect: View {

    // Default values
    let defaultScaling: CGFloat = 3
    let defaultOpacity: CGFloat = 0

    // View States
    @Binding private var isPressed: Bool
    @Binding private var tapLocation: CGPoint
    @Binding private var animationCompletedCallback: Bool
    @State private var scaling: CGFloat
    @State private var opacity: CGFloat
    @State private var animationCompleted = true

    // Properties
    let color: Color

    // Animations
    let scalingAnimation: Animation = .easeIn(duration: 0.25)
    let fadeOutAnimation: Animation = .easeInOut(duration: 0.2)

    /// A Material Design Ripple Effect in SwiftUI.
    /// - Parameters:
    ///   - isPressed: A Binding which indicates if the Ripple Effect should be started.
    ///   - tapLocation: A Binding which indicates where the tap occoured.
    ///   - rippleEffectColor: The color of the Ripple Effect.
    ///   - isFinished: A Binding which can be used as a callback indicator to determine if the animation is finished.
    ///
    public init(isPressed: Binding<Bool>, tapLocation: Binding<CGPoint>, rippleEffectColor: Color, isFinished: Binding<Bool> = .constant(true)) {
        self._isPressed = isPressed
        self._tapLocation = tapLocation
        self.scaling = defaultScaling
        self.opacity = defaultOpacity
        self.color = rippleEffectColor
        self._animationCompletedCallback = isFinished
    }

    public var body: some View {
        Circle()
            .scale(scaling)
            .position(x: tapLocation.x, y: tapLocation.y)
            .foregroundColor(color)
            .opacity(opacity)
            .clipped()
            .onChange(of: isPressed, perform: pressedStateChanged)
            .onAnimationCompleted(for: opacity, onCompletionExecute: markAnimationCompleted)
    }

    private func pressedStateChanged(to isPressed: Bool) {
        if isPressed {
            startRippleEffectScalingAnimation()
        } else {
            finishRippleEffectAnimation()
        }
    }

    private func startRippleEffectScalingAnimation() {
        animationCompleted = false
        animationCompletedCallback = false
        var transaction = Transaction(animation: scalingAnimation)
        transaction.disablesAnimations = true
        opacity = 0.2
        withTransaction(transaction) {
            opacity = 0.3
            scaling = 30
        }
    }

    private func finishRippleEffectAnimation() {
        guard animationCompleted else { return }
        var transaction = Transaction(animation: scalingAnimation)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            opacity = defaultOpacity
            scaling = defaultScaling
        }
    }

    private func markAnimationCompleted() {
        animationCompleted = true
        animationCompletedCallback = true
        if !isPressed { finishRippleEffectAnimation() }
    }

}
