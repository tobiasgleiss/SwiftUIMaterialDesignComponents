//
// 📄 MDActivityIndicator.Diameter.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public extension View {

    /// Sets the diameter of the MDActivityIndicator
    /// - Parameter diameter: The scaled diameter to be used (will not be scaled for the device later)
    /// - Returns: The MDActivityIndicator using the specifed diameter.
    @discardableResult func activityIndicatorDiameter(_ diameter: CGFloat) -> some View {
        environment(\.activityIndicatorDiameter, diameter)
    }

}

private struct ActivityIndicatorDiameter: EnvironmentKey {

    static let defaultValue: CGFloat = 26

}

extension EnvironmentValues {

    var activityIndicatorDiameter: CGFloat {
        get { self[ActivityIndicatorDiameter.self] }
        set { self[ActivityIndicatorDiameter.self] = newValue }
    }

}
