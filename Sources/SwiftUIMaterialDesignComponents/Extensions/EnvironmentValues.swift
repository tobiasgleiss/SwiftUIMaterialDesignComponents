//
// 📄 EnvironmentValues.swift
// 👨‍💻 Author: Tobias Gleiss
//

import SwiftUI

// MARK: Default style values for the SwiftUIMDActivityIndicator

private struct ActivityIndicatorColor: EnvironmentKey {
    static let defaultValue: Color = .black
}

private struct ActivityIndicatorDiameter: EnvironmentKey {
    static let defaultValue: CGFloat = 48
}

private struct ActivityIndicatorStrokeWidth: EnvironmentKey {
    static let defaultValue: CGFloat = 5
}

extension EnvironmentValues {
    var activityIndicatorColor: Color {
        get { self[ActivityIndicatorColor.self] }
        set { self[ActivityIndicatorColor.self] = newValue }
    }

    var activityIndicatorDiameter: CGFloat {
        get { self[ActivityIndicatorDiameter.self] }
        set { self[ActivityIndicatorDiameter.self] = newValue }
    }

    var activityIndicatorStrokeWidth: CGFloat {
        get { self[ActivityIndicatorStrokeWidth.self] }
        set { self[ActivityIndicatorStrokeWidth.self] = newValue }
    }
}
