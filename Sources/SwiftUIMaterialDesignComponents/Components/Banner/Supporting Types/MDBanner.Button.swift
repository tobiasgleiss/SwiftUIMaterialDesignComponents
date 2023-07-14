//
// 📄 MDBanner.Button.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

public extension MDBanner {

    struct Button: View {

        @Binding private var shouldDismissBanner: Bool

        private let title: String
        private let action: () -> Void

        // Style
        private let maxWidth: CGFloat
        private let height: CGFloat
        private let font: Font
        private let textColor: MDButton.ColorPair

        public init(title: String, action: @escaping () -> Void = { }, shouldDismissBanner: Binding<Bool> = .constant(false), maxWidth: CGFloat = 100, height: CGFloat = 30, textColor: MDButton.ColorPair = .init(.defaultMaterialAccent, disabled: .defaultMaterialAccent.opacity(0.5)), font: Font = .title3) {
            self._shouldDismissBanner = shouldDismissBanner
            self.title = title
            self.action = action
            self.maxWidth = maxWidth
            self.height = height
            self.font = font
            self.textColor = textColor
        }

        public var body: some View {
            MDButton(title: title, style: .textOnly(textColor: textColor, font: font), height: height, action: executeActionAndDismissBanner)
                .frame(maxWidth: maxWidth)
        }

        // Private Methods
        
        private func executeActionAndDismissBanner() {
            action()
            DispatchQueue.main.async {
                shouldDismissBanner.toggle()
            }
        }

    }

}
