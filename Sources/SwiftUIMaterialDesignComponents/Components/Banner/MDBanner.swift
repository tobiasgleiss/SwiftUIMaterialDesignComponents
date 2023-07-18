//
// 📄 MDBanner.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct MDBanner: View {

    // Banner Content
    private let icon: Icon?
    private let message: String
    private let leadingButton: MDBanner.Button?
    private let trailingButton: MDBanner.Button?

    // Layout
    private let maxBannerWidth: CGFloat
    private let minBannerHeight: CGFloat = 120
    private let topPadding: CGFloat = 24
    private let horizontalPadding: CGFloat = 16
    private let verticalSpacing: CGFloat = 16
    private let buttonSpacing: CGFloat = 8
    private let messageFont: Font

    // Colors
    private let backgroundColor: Color
    private let bottomBorderColor: Color

    // Computed Properties
    private var hasButtons: Bool { leadingButton != nil || trailingButton != nil }

    /// The SwiftUI Material Design Banner
    /// - Parameters:
    ///   - width: The width of the banner container. Will span over the whole available space if not set.
    ///   - icon: The icon which will be displayed before the banner´s message text.
    ///   - action: The action that is executed when the user taps the button.
    ///   - message: The text of the banner.
    ///   - messageFont: The font for the banner message.
    ///   - leadingButton: The leading button of the banner.
    ///   - traillingButton: The trailling button of the banner.
    ///   - borderColor: The color for the bottom border.
    ///
    public init(width: CGFloat = .infinity, icon: Icon? = nil, message: String, messageFont: Font = .body, leadingButton: MDBanner.Button? = nil, trailingButton: MDBanner.Button? = nil, backgroundColor: Color = .white, borderColor: Color = .gray.opacity(0.8)) {
        self.maxBannerWidth = width
        self.leadingButton = leadingButton
        self.trailingButton = trailingButton
        self.icon = icon
        self.message = message
        self.messageFont = messageFont
        self.backgroundColor = backgroundColor
        self.bottomBorderColor = borderColor
    }

    public var body: some View {
        container
            .background(backgroundColor)
            .frame(maxWidth: maxBannerWidth, minHeight: minBannerHeight)
    }

    private var container: some View {
        VStack(spacing: 0) {
            content
                .padding(.horizontal, horizontalPadding)
                .padding(.top, topPadding)
                .padding(.bottom, verticalSpacing)

            buttons
                .frame(maxWidth: .infinity)
                .conditionalPadding(.horizontal, horizontalPadding, if: hasButtons)
                .conditionalPadding(.bottom, verticalSpacing, if: hasButtons, otherwiseHidden: true)

            bottomBorder
        }
    }

    private var content: some View {
        HStack(spacing: 0) {
            icon
                .padding(.trailing, horizontalPadding)

            Text(message)
                .font(messageFont)

            Spacer(minLength: 0)
        }
    }

    private var buttons: some View {
        HStack(spacing: buttonSpacing) {
            Spacer(minLength: 0)

            leadingButton
                .hidden(leadingButton == nil, andRemoved: true)

            trailingButton
                .hidden(trailingButton == nil, andRemoved: true)
        }
    }

    private var bottomBorder: some View {
        Rectangle()
            .foregroundColor(bottomBorderColor)
            .frame(height: 1)
            .shadow(color: bottomBorderColor.opacity(0.5), radius: 2, y: 1)
    }

}

struct MDBanner_Previews: PreviewProvider {

    static let message = "When you look at the dark side, careful you must be. For the dark side looks back. - Yoda"
    static let button1 = MDBanner.Button(title: "Dismiss")
    static let button2 = MDBanner.Button(title: "Action")
    static let icon = MDBanner.Icon(image: Image(systemName: "quote.opening"))

    static var previews: some View {
        MDBanner(icon: icon, message: message, leadingButton: button1, trailingButton: button2)
    }

}
