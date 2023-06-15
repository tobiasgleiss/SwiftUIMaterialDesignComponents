//
// 📄 ConditionalFrameModifier.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

internal struct ConditionalFrameModifier: ViewModifier {

    var isActive: Bool
    var width: CGFloat

    @ViewBuilder func body(content: Content) -> some View {
        if isActive {
            content
                .frame(width: width)
        } else {
            content
        }
    }

}
