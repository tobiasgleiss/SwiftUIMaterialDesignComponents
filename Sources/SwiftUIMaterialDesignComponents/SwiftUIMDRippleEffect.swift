//
// 📄 SwiftUIMDRippleEffect.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct SwiftUIMDRippleEffect: View {
    
    // Default values
    let rippleEffectScalingDefault: CGFloat = 3
    let rippleEffectOpacityDefault: CGFloat = 0
    
    // View States
    @Binding var isPressed: Bool
    @Binding var tapLocation: CGPoint
    @State var rippleEffectScaling: CGFloat
    @State var rippleEffectOpacity: CGFloat
    @State var animationCompleted: Bool = true
    @Binding var animationCompletedCallback: Bool
    
    // Colors
    let rippleEffectColor: Color
    
    // Animations
    let rippleEffectScalingAnimation: Animation = .easeIn(duration: 0.3)
    let rippleEffectFadeOutAnimation: Animation = .easeInOut(duration: 0.2)
    
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
        self.rippleEffectScaling = rippleEffectScalingDefault
        self.rippleEffectOpacity = rippleEffectOpacityDefault
        self.rippleEffectColor = rippleEffectColor
        self._animationCompletedCallback = isFinished
    }
    
    public var body: some View {
        Circle()
            .scale(rippleEffectScaling)
            .position(x: tapLocation.x, y: tapLocation.y)
            .foregroundColor(rippleEffectColor)
            .opacity(rippleEffectOpacity)
            .clipped()
            .onChange(of: isPressed, perform: pressedStateChanged)
            .onAnimationCompleted(for: rippleEffectOpacity, onCompletionExecute: markAnimationCompleted)
    }
    
    private func pressedStateChanged(to pressedState: Bool) {
        switch pressedState {
        case true: startRippleEffectScalingAnimation()
        case false: releaseRippleEffectAnimation()
        }
    }
    
    private func startRippleEffectScalingAnimation() {
        animationCompleted = false
        animationCompletedCallback = false
        var transaction = Transaction(animation: rippleEffectScalingAnimation)
        transaction.disablesAnimations = true
        rippleEffectOpacity = 0.2
        withTransaction(transaction) {
            rippleEffectOpacity = 0.3
            rippleEffectScaling = 30
        }
    }
    
    private func releaseRippleEffectAnimation() {
        guard animationCompleted else { return }
        var transaction = Transaction(animation: rippleEffectScalingAnimation)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            rippleEffectOpacity = rippleEffectOpacityDefault
            rippleEffectScaling = rippleEffectScalingDefault
        }
    }
    
    private func markAnimationCompleted() {
        animationCompleted = true
        animationCompletedCallback = true
        if !isPressed { releaseRippleEffectAnimation() }
    }
}
