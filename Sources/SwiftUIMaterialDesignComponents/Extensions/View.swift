//
// 📄 View.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

extension View {

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
