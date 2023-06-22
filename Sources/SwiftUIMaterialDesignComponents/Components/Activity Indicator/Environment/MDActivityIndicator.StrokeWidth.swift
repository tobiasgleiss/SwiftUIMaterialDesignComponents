//
// 📄 MDActivityIndicator.StrokeWidth.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public extension View {

    /// Sets the stroke width of the MDActivityIndicator
    /// - Parameter strokeWidth: The scaled stroke width to be used (will not be scaled for the device later)
    /// - Returns: The MDActivityIndicator using the specifed stroke width.
    @discardableResult func activityIndicatorStrokeWidth(_ strokeWidth: CGFloat) -> some View {
        environment(\.activityIndicatorStrokeWidth, strokeWidth)
    }

}

private struct ActivityIndicatorStrokeWidth: EnvironmentKey {

    static let defaultValue: CGFloat = 3

}

extension EnvironmentValues {

    var activityIndicatorStrokeWidth: CGFloat {
        get { self[ActivityIndicatorStrokeWidth.self] }
        set { self[ActivityIndicatorStrokeWidth.self] = newValue }
    }

}
