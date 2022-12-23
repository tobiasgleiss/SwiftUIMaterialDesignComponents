//
// 📄 EnvironmentValues.swift
// 👨‍💻 Author: Tobias Gleiss
//

import SwiftUI

private struct ActivityIndicatorColor: EnvironmentKey {
    static let defaultValue: Color = .black
}

private struct ActivityIndicatorDiameter: EnvironmentKey {
    static let defaultValue: CGFloat = 48
}

private struct ActivityIndicatorStrokeWidth: EnvironmentKey {
    static let defaultValue: CGFloat = 5
}

private struct ButtonPendingState: EnvironmentKey {
    static let defaultValue = false
}

private struct ButtonTapAreaInsets: EnvironmentKey {
    static let defaultValue = EdgeInsets.zero
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
    
    var isButtonPending: Bool {
        get { self[ButtonPendingState.self] }
        set { self[ButtonPendingState.self] = newValue }
    }
    
    var buttonTapAreaInsets: EdgeInsets {
        get { self[ButtonTapAreaInsets.self] }
        set { self[ButtonTapAreaInsets.self] = newValue }
    }
    
}

extension EdgeInsets {
    
    static let zero = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    
}
