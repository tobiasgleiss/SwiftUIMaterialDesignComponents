//
// 📄 MDTextField.Error.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public extension View {

    /// Manages the error message view of the MDTextField
    /// - Parameter errorMessage: The error message to be shown below a MDTextField
    /// - Returns: The input with all contained MDTextField showing/hiding the error message view with the specified message or the unchanged input otherwise.
    @discardableResult func textFieldErrorMessage(_ errorMessage: String) -> some View {
        environment(\.textFieldErrorMessage, errorMessage)
    }

}

private struct TextFieldErrorMessage: EnvironmentKey {

    static let defaultValue = ""

}

extension EnvironmentValues {

    var textFieldErrorMessage: String {
        get { self[TextFieldErrorMessage.self] }
        set { self[TextFieldErrorMessage.self] = newValue }
    }

}
