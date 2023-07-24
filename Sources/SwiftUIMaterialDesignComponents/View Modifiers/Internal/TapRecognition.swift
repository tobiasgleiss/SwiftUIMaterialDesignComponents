//
// 📄 TapRecognition.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

extension View {

    @discardableResult func onTapRecognition(update tapLocation: Binding<CGPoint>, isPressed: Binding<Bool>) -> some View {
        modifier(TapRecognitionModifier(updating: tapLocation, isPressed: isPressed))
    }

}

private struct TapRecognitionModifier: ViewModifier {

    @Binding private var tapLocation: CGPoint
    @Binding private var isPressed: Bool

    init(updating tapLocation: Binding<CGPoint>, isPressed: Binding<Bool>) {
        self._tapLocation = tapLocation
        self._isPressed = isPressed
    }

    // TODO: Add Long Press Gesture Recognition without destroying scroll behovior inside ScrollViews (preferably also with Tap Location Recognition)
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .onTapGesture(perform: action)
        } else {
            content
                .onTapGesture(perform: actionWithoutLocation)
        }
    }

    private func action(with location: CGPoint) {
        isPressed = true
        tapLocation = location
    }

    @available(iOS, deprecated: 16, message: "Also remove if #available check in body!")
    private func actionWithoutLocation() {
        isPressed = true
    }

}
