//
// 📄 TouchLocationModifier.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

extension View {

    /// Provides a Touch Gesture with options to execute actions on start, end or on cancel of the gesture.
    @discardableResult func onTouchGesture(onStarted: @escaping () -> Void, onLocationUpdate: @escaping (CGPoint) -> Void, onEnded: @escaping () -> Void, onCancelled: @escaping () -> Void) -> some View {
        modifier(TouchLocationModifier(onStarted: onStarted, onLocationUpdate: onLocationUpdate, onEnded: onEnded, onCancelled: onCancelled))
    }

}

private struct TouchLocationModifier: ViewModifier {

    let onStarted: () -> Void
    let onLocationUpdate: (CGPoint) -> Void
    let onEnded: () -> Void
    let onCancelled: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay(touchLocationView)
    }

    private var touchLocationView: some View {
        TouchLocationView(onStarted: onStarted, onLocationUpdate: onLocationUpdate, onEnded: onEnded, onCancelled: onCancelled)
    }

}

// Implementation inspired by https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-the-location-of-a-tap-inside-a-view
private struct TouchLocationView: UIViewRepresentable {

    let onStarted: () -> Void
    let onLocationUpdate: (CGPoint) -> Void
    let onEnded: () -> Void
    let onCancelled: () -> Void

    let types = TouchType.all

    func makeUIView(context: Context) -> TouchLocationUIView {
        let view = TouchLocationUIView()
        view.onStarted = onStarted
        view.onLocationUpdate = onLocationUpdate
        view.onEnded = onEnded
        view.onCancelled = onCancelled
        view.touchTypes = types
        return view
    }

    func updateUIView(_ uiView: TouchLocationUIView, context: Context) { }

    class TouchLocationUIView: UIView {

        var onStarted: (() -> Void)?
        var onLocationUpdate: ((CGPoint) -> Void)?
        var onEnded: (() -> Void)?
        var onCancelled: (() -> Void)?
        var touchTypes: TouchLocationView.TouchType = .all

        override init(frame: CGRect) {
            super.init(frame: frame)
            isUserInteractionEnabled = true
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            isUserInteractionEnabled = true
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            determineAction(with: location, forEvent: .started)
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            determineAction(with: location, forEvent: .ended)
        }

        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            determineAction(with: location, forEvent: .cancelled)
        }

        private func determineAction(with location: CGPoint, forEvent event: TouchType) {
            guard touchTypes.contains(event) else { return }
            onLocationUpdate?(location)
            switch event {
            case .started: onStarted?()
            case .ended: onEnded?()
            case .cancelled: onCancelled?()
            default: do { }
            }
        }

    }

    struct TouchType: OptionSet {
        static let started = TouchType(rawValue: 1)
        static let ended = TouchType(rawValue: 2)
        static let cancelled = TouchType(rawValue: 3)
        static let all: TouchType = [.started, .ended, .cancelled]

        let rawValue: Int
    }

}
