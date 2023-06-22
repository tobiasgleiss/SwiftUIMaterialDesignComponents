//
// 📄 MDActivityIndicator.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct MDActivityIndicator: View {

    @Environment(\.activityIndicatorColor) private var color: Color
    @Environment(\.activityIndicatorDiameter) private var diameter: CGFloat
    @Environment(\.activityIndicatorStrokeWidth) private var strokeWidth: CGFloat

    @Binding private var isActive: Bool

    // Animation States
    @State private var trimStart: CGFloat = 0.0
    @State private var trimEnd: CGFloat = 0.1
    @State private var rotation: Double = 0
    @State private var animatedRotation: Double = 0

    // Animation Target Values
    let trimStartAnimationTarget: CGFloat = 0.90
    let trimEndAnimationTarget: CGFloat = 0.85

    // Animations
    let springAnimation: Animation = .spring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.5)
    let rotationAnimation: Animation = .linear(duration: 2)

    ///  A Material Design Acitvity Indicator in SwiftUI
    /// - Parameters:
    ///   - isActive: Controls if the indicator is showing constant activity.
    ///
    /// If instantiated without setting `isActive`, the activity indicator will be constantly animating. If it is set false, the activity indicator will stop after the next animation loop. To control the animation and all the parameters you can use it like this:
    ///
    ///     struct ExampleView: View {
    ///
    ///         @State private var isLoading: Bool = true
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 SGActivityIndicator(isAnimating: $isLoading)
    ///                     .activityIndicatorColor(.indivMint)
    ///                     .activityIndicatorDiameter(Size(25).scaled)
    ///                     .activityIndicatorStrokeWidth(Size(10).scaled)
    ///                 Button(action: buttonAction) { Text("Toggle Activity") }
    ///             }
    ///         }
    ///
    ///         private func buttonAction() {
    ///             isLoading.toggle()
    ///         }
    ///
    ///     }
    ///
    public init(isActive: Binding<Bool> = .constant(true)) {
        self._isActive = isActive
    }

    public var body: some View {
        Circle()
            .trim(from: trimStart, to: trimEnd)
            .stroke(color, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .square))
            .frame(width: diameter, height: diameter)
            .rotationEffect(Angle(degrees: rotation))
            .rotationEffect(Angle(degrees: animatedRotation))
            .onAppear(perform: startRotationAnimation)
            .onAnimationCompleted(for: trimEnd, onCompletionExecute: startReducingAnimation)
            .onAnimationCompleted(for: animatedRotation, onCompletionExecute: restartAnimationLoop)
            .onChange(of: isActive, perform: animationStateChanged)
    }

    private func animationStateChanged(to animated: Bool) {
        if animated { startRotationAnimation() }
    }

    private func startRotationAnimation() {
        guard isActive else { return finishAnimation() }
        var transaction = Transaction(animation: rotationAnimation)
        transaction.disablesAnimations = true
        withTransaction(transaction) { animatedRotation = 720 }
        startExpandingAnimation()
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
            rotation -= 52
        }
        startRotationAnimation()
    }

    private func finishAnimation() {
        var transaction = Transaction(animation: springAnimation)
        transaction.disablesAnimations = true
        withTransaction(transaction) { trimEnd = 1 }
    }

}

struct MDActivityIndicator_Previews: PreviewProvider {

    static var previews: some View {
        MDActivityIndicator()
    }

}
