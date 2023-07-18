//
// 📄 TouchLocation.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public extension View {

    /// Provides a Touch Gesture with options to execute actions on start, end or on cancel of the gesture.
    @discardableResult func handleTouchGesture(limitGestureToBounds: Bool = true, onStarted: @escaping () -> Void = { }, onLocationUpdate: @escaping (CGPoint) -> Void = { _ in }, onEnded: @escaping () -> Void = { }, onCancelled: @escaping () -> Void = { }) -> some View {
        modifier(TouchLocationModifier(limitGestureToBounds: limitGestureToBounds, onStarted: onStarted, onLocationUpdate: onLocationUpdate, onEnded: onEnded, onCancelled: onCancelled))
    }

}

private struct TouchLocationModifier: ViewModifier {

    let limitGestureToBounds: Bool
    let onStarted: () -> Void
    let onLocationUpdate: (CGPoint) -> Void
    let onEnded: () -> Void
    let onCancelled: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay(touchLocationView)
    }

    private var touchLocationView: some View {
        TouchLocationView(limitGestureToBounds: limitGestureToBounds, onStarted: onStarted, onLocationUpdate: onLocationUpdate, onEnded: onEnded, onCancelled: onCancelled)
    }

}

// Implementation inspired by https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-the-location-of-a-tap-inside-a-view
private struct TouchLocationView: UIViewRepresentable {

    let limitGestureToBounds: Bool
    let onStarted: () -> Void
    let onLocationUpdate: (CGPoint) -> Void
    let onEnded: () -> Void
    let onCancelled: () -> Void

    func makeUIView(context: Context) -> TouchLocationUIView {
        let view = TouchLocationUIView()
        view.onStarted = onStarted
        view.onLocationUpdate = onLocationUpdate
        view.onEnded = onEnded
        view.onCancelled = onCancelled
        view.limitGestureToBounds = limitGestureToBounds
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: view, action: #selector(view.handleLongPressGesture(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0.01
        view.addGestureRecognizer(longPressGestureRecognizer)
        return view
    }

    func updateUIView(_ uiView: TouchLocationUIView, context: Context) { }

    class TouchLocationUIView: UIView {

        var onStarted: (() -> Void)?
        var onLocationUpdate: ((CGPoint) -> Void)?
        var onEnded: (() -> Void)?
        var onCancelled: (() -> Void)?
        var limitGestureToBounds = true

        override init(frame: CGRect) {
            super.init(frame: frame)
            isUserInteractionEnabled = true
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            isUserInteractionEnabled = true
        }

        @objc dynamic func handleLongPressGesture(_ recognizer: UILongPressGestureRecognizer) {
            let location = recognizer.location(in: self)
            onLocationUpdate?(location)
            switch recognizer.state {
            case .began: onStarted?()
            case .changed: checkBounds(location: location, recognizer: recognizer)
            case .ended: onEnded?()
            case .cancelled: onCancelled?()
            default: do { }
            }
        }

        private func checkBounds(location: CGPoint, recognizer: UIGestureRecognizer) {
            if limitGestureToBounds, !bounds.contains(location) {
                recognizer.state = .cancelled
            }
        }

    }

}
