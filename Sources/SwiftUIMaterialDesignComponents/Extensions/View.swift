//
// 📄 View.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

extension View {

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    /// Measures the size of the view inside the current surroundings.
    /// - Parameter onMeasurementDone: The callback (can be used to print or save the proposed size into a state variable)
    func measureSize(_ onMeasurementDone: @escaping (CGSize) -> Void) -> some View {
        background(GeometryReader { Color.clear.preference(key: SizeKey.self, value: $0.size) }
            .onPreferenceChange(SizeKey.self, perform: onMeasurementDone))
    }

    /// Measures the width of the view inside the current surroundings.
    /// - Parameter onMeasurementDone: The callback (can be used to print or save the proposed width into a state variable)
    func measureWidth(_ onMeasurementDone: @escaping (CGFloat) -> Void) -> some View {
        measureSize { onMeasurementDone($0.width) }
    }

}

struct SizeKey: PreferenceKey {

    static let defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }

}
