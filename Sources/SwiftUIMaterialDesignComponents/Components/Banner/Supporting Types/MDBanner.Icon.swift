//
// 📄 MDBanner.Icon.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

public extension MDBanner {

    struct Icon: View {

        private let image: Image
        private let width: Double
        private let height: Double

        /// The icon for a SwiftUI Material Design Banner.
        /// - Parameters:
        ///   - image: The image to use as the icon of the banner
        ///   - width: The maximum width of the icon (will be scaled to fit).
        ///   - height: The maximum height of the icon (will be scaled to fit)
        ///   - verticalOffset: The vertical offset of the icon relative to the banner
        public init?(image: Image?, width: Double = 40, height: Double = 40) {
            guard let image else { return nil }
            self.image = image
            self.width = width
            self.height = height
        }

        /// The icon for a SwiftUI Material Design Banner.
        /// - Parameters:
        ///   - image: The image to use as the icon of the banner
        ///   - size: The maximum width and height of the icon (will be scaled to fit)
        public init?(image: Image?, size: Double = 40) {
            self.init(image: image, width: size, height: size)
        }

        /// The icon for a SwiftUI Material Design Banner.
        /// - Parameters:
        ///   - image: The image to use as the icon of the banner
        ///   - size: The maximum width and height of the icon (will be scaled to fit)
        public init?(image: UIImage?, size: Double = 40) {
            guard let image else { return nil }
            self.init(image: Image(uiImage: image), width: size, height: size)
        }

        public var body: some View {
            VStack(spacing: 0) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: width, alignment: .center)
            }
        }

    }

}
