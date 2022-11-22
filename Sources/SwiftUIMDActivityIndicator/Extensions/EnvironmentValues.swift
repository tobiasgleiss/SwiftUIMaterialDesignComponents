//
// 📄 EnvironmentValues.swift
// 👨‍💻 Author: Tobias Gleiss
//

import SwiftUI

private struct ActivityIndicatorColor: EnvironmentKey {
    static let defaultValue: Color = .blue
}

private struct ActivityIndicatorDiameter: EnvironmentKey {
    static let defaultValue: CGFloat = 50
}

private struct ActivityIndicatorStrokeWidth: EnvironmentKey {
    static let defaultValue: CGFloat = 10
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
