//
// 📄 MDButton.Pending.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public extension View {

    /// Sets the pending state of the MDButton.
    /// - Parameter isPending: The pending state to be used
    /// - Returns: The input with all contained MDButtons in the specifed pending state.
    @discardableResult func pending(_ isPending: Bool) -> some View {
        environment(\.isButtonPending, isPending)
    }

}

private struct ButtonPendingState: EnvironmentKey {

    static let defaultValue = false

}

extension EnvironmentValues {

    var isButtonPending: Bool {
        get { self[ButtonPendingState.self] }
        set { self[ButtonPendingState.self] = newValue }
    }

}
