//
// 📄 TouchLocationModifier.swift
// 👨‍💻 Author: Tobias Gleiss
//


import SwiftUI

internal struct TouchLocationModifier: ViewModifier {
    let onStarted: () -> Void
    let onLocationUpdate: (CGPoint) -> Void
    let onEnded: () -> Void
    let onCancelled: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay(
                TouchLocationView(onStarted: onStarted, onLocationUpdate: onLocationUpdate, onEnded: onEnded, onCancelled: onCancelled)
            )
    }
}
