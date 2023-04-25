//
// 📄 SwiftUIMDButtonIcon.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

public struct SwiftUIMDButtonIcon: View {

    let icon: Image
    let position: SwiftUIMDButtonIconPosition

    private let width: Double
    private let height: Double
    private let topOffset: CGFloat
    private let bottomOffset: CGFloat

    /// The icon for a SwiftUI Material Design Button.
    /// - Parameters:
    ///   - icon: The image to use as the icon of the button
    ///   - position: The position of the icon relative to the button title
    ///   - width: The maximum width of the icon (will be scaled to fit)
    ///   - height: The maximum height of the icon (will be scaled to fit)
    ///   - verticalOffset: The vertical offset of the icon relative to the button
    public init?(icon: Image?, position: SwiftUIMDButtonIconPosition, width: Double, height: Double, verticalOffset: Double = 0) {
        guard let icon else { return nil }
        self.icon = icon
        self.position = position
        self.width = width
        self.height = height
        self.topOffset = verticalOffset > 0 ? verticalOffset : 0
        self.bottomOffset = verticalOffset < 0 ? (verticalOffset * -1) : 0
    }

    /// The icon for a SwiftUI Material Design Button.
    /// - Parameters:
    ///   - icon: The image to use as the icon of the button
    ///   - position: The position of the icon relative to the button title
    ///   - size: The maximum width and height of the icon (will be scaled to fit)
    ///   - verticalOffset: The vertical offset of the icon relative to the button
    public init?(icon: Image?, position: SwiftUIMDButtonIconPosition, size: Double, verticalOffset: Double = 0) {
        self.init(icon: icon, position: position, width: size, height: size, verticalOffset: verticalOffset)
    }

    public var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: topOffset)

            icon
                .resizable()
                .frame(maxWidth: width, maxHeight: height, alignment: .center)

            Spacer(minLength: bottomOffset)
        }
    }

}

public enum SwiftUIMDButtonIconPosition {

    case leading
    case trailing

}
