//
// 📄 MDActivityIndicator.Color.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public extension View {

    /// Sets the color of the MDActivityIndicator
    /// - Parameter color: The color to be used
    /// - Returns: The MDActivityIndicator using the specifed color.
    @discardableResult func activityIndicatorColor(_ color: Color) -> some View {
        environment(\.activityIndicatorColor, color)
    }

}

private struct ActivityIndicatorColor: EnvironmentKey {

    static let defaultValue: Color = .black

}

extension EnvironmentValues {

    var activityIndicatorColor: Color {
        get { self[ActivityIndicatorColor.self] }
        set { self[ActivityIndicatorColor.self] = newValue }
    }

}
