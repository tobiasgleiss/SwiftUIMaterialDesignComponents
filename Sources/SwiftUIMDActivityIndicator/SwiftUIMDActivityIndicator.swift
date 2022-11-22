
//
// 📄 SwiftUIMDActivityIndicator.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

struct SwiftUIMDActivityIndicator: View {

    @Binding var isActive: Bool

//    @Environment(\.provideTapToDismissKeyboard) private var shouldProvideTapToDismissKeyboard: Bool
//    private var prohibitTapToDismissKeyboard: Bool
//    private var isTapToDismissKeyboardEnabled: Bool { shouldProvideTapToDismissKeyboard && !prohibitTapToDismissKeyboard }

    @Environment(\.activityIndicatorColor) private var color: Color
    @Environment(\.activityIndicatorDiameter) private var diameter: CGFloat
    @Environment(\.activityIndicatorStrokeWidth) private var strokeWidth: CGFloat

    // Animation States
    @State var trimStart: CGFloat = 0.0
    @State var trimEnd: CGFloat = 0.1
    @State var rotation: Double = 0
    @State var animatedRotation: Double = 0

    // Animation Target Values
    let trimStartAnimationTarget: CGFloat = 0.95
    let trimEndAnimationTarget: CGFloat = 0.85

    // Animations
    let springAnimation: Animation = .spring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.5)
    let rotationAnimation: Animation = .linear(duration: 3)

    init(isActive: Binding<Bool> = .constant(true)) {
        self._isActive = isActive
    }

    var body: some View {

        VStack {
            Circle()
                .trim(from: trimStart, to: trimEnd)
                .stroke(color, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .square))
                .frame(maxWidth: diameter)
                .rotationEffect(Angle(degrees: rotation))
                .rotationEffect(Angle(degrees: animatedRotation))
                .onAppear(perform: startRotationAnimation)
                .onAnimationMatchesValue(for: animatedRotation, match: 180, onMatchExecute: startExpandingAnimation)
                .onAnimationMatchesValue(for: animatedRotation, match: 360, onMatchExecute: startReducingAnimation)
                .onAnimationCompleted(for: animatedRotation, onCompletionExecute: restartAnimationLoop)
        }
    }

    private func startRotationAnimation() {
        var transaction = Transaction(animation: rotationAnimation)
        transaction.disablesAnimations = true
        withTransaction(transaction) { animatedRotation = 720 }
    }

    private func startExpandingAnimation() {
        var transaction = Transaction(animation: springAnimation)
        transaction.disablesAnimations = true
        withTransaction(transaction) { trimEnd = trimStartAnimationTarget }
    }

    private func startReducingAnimation() {
        var transaction = Transaction(animation: springAnimation)
        transaction.disablesAnimations = true
        withTransaction(transaction) { trimStart = trimEndAnimationTarget }
    }

    private func restartAnimationLoop() {
        var transaction = Transaction(animation: nil)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            animatedRotation = 0
            trimStart = 0
            trimEnd = 0.1
            rotation -= 50
        }
        startRotationAnimation()
    }
}

struct SGActivityIndicatorReplacement_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIMDActivityIndicator()
    }
}
