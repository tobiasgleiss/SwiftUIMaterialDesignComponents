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
        private let width: CGFloat
        private let height: CGFloat
        private let font: Font
        private let textColor: MDButton.ColorPair

        public init(title: String, action: @escaping () -> Void = { }, shouldDismissBanner: Binding<Bool> = .constant(false), width: CGFloat = 100, height: CGFloat = 30, textColor: MDButton.ColorPair = .init(.defaultMaterialAccent, disabled: .defaultMaterialAccent.opacity(0.5)), font: Font = .title3) {
            self._shouldDismissBanner = shouldDismissBanner
            self.title = title
            self.action = action
            self.width = width
            self.height = height
            self.font = font
            self.textColor = textColor
        }

        public var body: some View {
            MDButton(title: title, style: .bannerAction(textColor: textColor, font: font), width: width, height: height, action: executeActionAndDismissBanner)
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
