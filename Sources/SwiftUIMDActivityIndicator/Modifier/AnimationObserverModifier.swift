//
// 📄 AnimationObserverModifier.swift
// 👨‍💻 Author: Tobias Gleiss
//

import SwiftUI

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

    init(observedValue: Value, matchValue: Value? = nil, onMatchExecute: @escaping () -> Void = {}, onCompletionExecute: @escaping () -> Void = {}) {
        self.animatableData = observedValue
        self.matchValue = matchValue
        self.targetValue = observedValue
        self.onMatchExecute = onMatchExecute
        self.onCompletionExecute = onCompletionExecute
    }
    
    private func notifyIfValueMatched() {
        guard animatableData == matchValue else { return }
        DispatchQueue.main.async {
            self.onMatchExecute()
        }
    }

    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }
        DispatchQueue.main.async {
            self.onCompletionExecute()
        }
    }

    func body(content: Content) -> some View {
        content
    }
}

extension View {

    
}

