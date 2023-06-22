//
// 📄 MDTextField.State.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

extension MDTextField {

    enum TextFieldState {
        case disabled
        case focused
        case focusedError
        case unfocused
        case unfocusedError
        case unfocusedPopulated
    }

}
