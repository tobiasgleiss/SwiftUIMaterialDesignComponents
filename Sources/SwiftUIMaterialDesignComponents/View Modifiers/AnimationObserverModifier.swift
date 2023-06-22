//
// 📄 AnimationObserverModifier.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

extension View {

    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - onCompletionExecute: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    @discardableResult func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, onCompletionExecute: @escaping () -> Void) -> ModifiedContent<Self, AnimationObserverModifier<Value>> {
        modifier(AnimationObserverModifier(observedValue: value, onCompletionExecute: onCompletionExecute))
    }

}

struct AnimationObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {

    var animatableData: Value {
        didSet {
            notifyIfValueMatched()
            notifyCompletionIfFinished()
        }
    }

    private var matchValue: Value?
    private var targetValue: Value
    private var onMatchExecute: () -> Void
    private var onCompletionExecute: () -> Void

    init(observedValue: Value, matchValue: Value? = nil, onMatchExecute: @escaping () -> Void = { }, onCompletionExecute: @escaping () -> Void = { }) {
        self.animatableData = observedValue
        self.matchValue = matchValue
        self.targetValue = observedValue
        self.onMatchExecute = onMatchExecute
        self.onCompletionExecute = onCompletionExecute
    }

    func body(content: Content) -> some View {
        content
    }

    private func notifyIfValueMatched() {
        guard animatableData == matchValue else { return }
        DispatchQueue.main.async {
            onMatchExecute()
        }
    }

    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }
        DispatchQueue.main.async {
            onCompletionExecute()
        }
    }

}
