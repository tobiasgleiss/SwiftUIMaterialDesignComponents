//
// 📄 HiddenModifier.swift
// 👨🏼‍💻 Author: Benno Kress (https://github.com/bennokress)
//

import SwiftUI

internal struct HiddenModifier: ViewModifier {

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
