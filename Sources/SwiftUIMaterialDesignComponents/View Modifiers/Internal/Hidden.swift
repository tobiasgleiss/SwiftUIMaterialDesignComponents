//
// 📄 Hidden.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

extension View {

    /// Hide or show the view based on a boolean value.
    /// - Parameters:
    ///   - isHidden: Boolean value indicating whether or not to hide the view
    ///   - remove: Boolean value indicating whether or not to remove the view (view must also be hidden to be removed)
    /// - Returns: The given view shown or hidden/removed.
    ///
    /// Example for visibility:
    /// ```
    /// Text("Label")
    ///     .hidden(true)
    /// ```
    ///
    /// Example for complete removal:
    /// ```
    /// Text("Label")
    ///     .hidden(true, remove: true)
    /// ```
    @discardableResult func hidden(_ isHidden: Bool, andRemoved remove: Bool = false) -> some View {
        modifier(HiddenModifier(isHidden: isHidden, remove: remove))
    }

}

private struct HiddenModifier: ViewModifier {

    private let isHidden: Bool
    private let remove: Bool

    init(isHidden: Bool, remove: Bool = false) {
        self.isHidden = isHidden
        self.remove = remove
    }

    func body(content: Content) -> some View {
        Group {
            if isHidden {
                if remove {
                    EmptyView()
                } else {
                    content
                        .hidden()
                }
            } else {
                content
            }
        }
    }

}
