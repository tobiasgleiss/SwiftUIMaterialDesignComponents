//
// 📄 MDButton.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct MDButton: View {

    @Environment(\.isButtonPending) private var isPending: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.buttonTapAreaInsets) private var tapAreaInsets: EdgeInsets

    // Default values
    public static let defaultWidth: CGFloat = 300
    public static let defaultHeight: CGFloat = 45

    // View States
    @State private var isSetupComplete = false
    @State private var isPressed = false
    @State private var showIndicator = false
    @State private var touchLocation: CGPoint
    @State private var elevationShadowRadius: CGFloat = 0
    @State private var elevationShadowOffset: CGFloat = 0
    @State private var elevationShadowOpacity: CGFloat = 0
    @State private var titleOpacity: CGFloat = 1

    // Animations
    let rippleEffectScalingAnimation: Animation = .easeIn(duration: 0.3)
    let rippleEffectFadeOutAnimation: Animation = .easeInOut(duration: 0.2)
    let titleOpacityAnimation: Animation = .easeIn(duration: 0.15)
    let dragArea: CGRect
    let limitGestureToBounds: Bool

    // Button Styling
    let style: Style
    let borderWidth: CGFloat
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let horizontalAlignment: HorizontalAlignment
    let rippleEffectColor: Color
    let pendingIndicatorColor: Color
    let elevationShadowColor: Color
    let isRippleEffectEnabled: Bool
    let isAlignedTextButton: Bool
    let isButtonShapeRemoved: Bool

    // Button Content
    let title: String
    let leadingIcon: Icon?
    let trailingIcon: Icon?

    // Button Action
    let action: () -> Void

    // Computed Properties
    var backgroundColor: Color { isEnabled ? style.buttonColor.primary : style.buttonColor.secondary }
    var titleColor: Color { isEnabled ? style.textColor.primary : style.textColor.secondary }

    /// The SwiftUI Material Design Button
    /// - Parameters:
    ///   - title: The text appearing on the button
    ///   - style: The button style (see `MDButtonStyle` for options)
    ///   - icon: The icon to display alongside the button title
    ///   - width: The width of the button
    ///   - height: The height of the button
    ///   - isRippleEffectEnabled: Indicates if the RippleEffect should be enabled
    ///   - limitGestureToBounds: Indicates if the gesture should be cancelled if a drag gesture exceeds the bounds of the button
    ///   - action: The action that is executed when the user taps the button
    ///
    /// If the button is followed by a `pending` view modifier, it will be overlayed with an Activity Indicator replacing the title and icon for as long as it is in pending state. A typical use case would look like this:
    ///
    ///     struct ExampleView: View {
    ///
    ///         @State private var isPending: Bool = false
    ///         @State private var isDisabled: Bool = false
    ///
    ///         var body: some View {
    ///             MDButton(title: "Do stuff", style: .secondary, action: togglePending)
    ///                 .pending(isPending)
    ///                 .disabled(isDisabled)
    ///         }
    ///
    ///         /// Call from anywhere to toggle the pending indicator on the Button
    ///         private func togglePending() {
    ///             isPending.toggle()
    ///         }
    ///
    ///     }
    ///
    /// - Attention: If the style is set to `.text` and it´s property `horizontalAlignment` is set to `.leading` or `.trailing` the ripple effect will automatically be disabled as well as the button shape. Only a centered text button has the ability to have a RippleEffect.
    public init(title: String, style: Style = .contained, icon: Icon? = nil, width: CGFloat = defaultWidth, height: CGFloat = defaultHeight, isRippleEffectEnabled: Bool = true, limitGestureToBounds: Bool = true, action: @escaping () -> Void = { }) {
        self.title = title
        self.style = style
        self.leadingIcon = icon?.position == .leading ? icon : nil
        self.trailingIcon = icon?.position == .trailing ? icon : nil
        self.width = width
        self.height = height
        self.isRippleEffectEnabled = isRippleEffectEnabled
        self.action = action
        self.touchLocation = CGPoint(x: height / 2, y: width / 2)
        self.cornerRadius = style.cornerRadius
        self.horizontalAlignment = style.textAlignment
        self.borderWidth = style.borderWidth
        self.rippleEffectColor = style.rippleEffectColor.primary
        self.pendingIndicatorColor = style.activityIndicatorColor
        self.elevationShadowColor = style.shadowColor
        self.isAlignedTextButton = style.isTextOnly && style.textAlignment != .center
        self.dragArea = CGRect(x: 0, y: 0, width: width, height: height)
        self.limitGestureToBounds = limitGestureToBounds
        self.isButtonShapeRemoved = !isRippleEffectEnabled || isAlignedTextButton
    }

    public var body: some View {
        alignedButton
            .frame(maxWidth: .infinity)
            .onChange(of: isPending, perform: pendingStateChanged)
            .onAppear(perform: setInitialPendingState)
    }

    private var alignedButton: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
                .hidden(horizontalAlignment == .leading, andRemoved: true)

            button
                .contentShape(Rectangle())
                .conditionalFrameWidth(width, if: !isAlignedTextButton)
                .frame(height: height)
                .cornerRadius(cornerRadius)
                .shadow(color: elevationShadowColor.opacity(elevationShadowOpacity), radius: elevationShadowRadius, x: 0, y: elevationShadowOffset)
                .increaseTapArea(tapAreaInsets)
                .onAnimationCompleted(for: titleOpacity, onCompletionExecute: resetButtonTitleAnimation)
                .handleTouchGesture(limitGestureToBounds: limitGestureToBounds, onStarted: gestureStarted, onLocationUpdate: updateTouchLocation, onEnded: gestureEnded, onCancelled: gestureCancelled)

            Spacer(minLength: 0)
                .hidden(horizontalAlignment == .trailing, andRemoved: true)
        }
    }

    private var button: some View {
        ZStack {
            buttonBackgroundShape

            MDRippleEffect(isPressed: $isPressed, tapLocation: $touchLocation, rippleEffectColor: rippleEffectColor)
                .hidden(isButtonShapeRemoved, andRemoved: true)

            buttonTitleContent
        }
    }

    @ViewBuilder private var buttonBackgroundShape: some View {
        switch style.baseType {
        case .contained: containedButtonBackground
        case .outlined: outlinedButtonBackground
        case .textOnly: EmptyView()
        }
    }

    @ViewBuilder private var buttonTitleContent: some View {
        if showIndicator {
            MDActivityIndicator()
                .activityIndicatorColor(pendingIndicatorColor)
        } else {
            HStack {
                leadingIcon
                    .foregroundColor(titleColor)

                Text(title)
                    .foregroundColor(titleColor)
                    .font(style.font)
                    .fontWeight(.bold)
                    .opacity(titleOpacity)

                trailingIcon
                    .foregroundColor(titleColor)
            }
        }
    }

    private var containedButtonBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(backgroundColor)
    }

    private var outlinedButtonBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(backgroundColor, lineWidth: borderWidth)
    }

    // MARK: Private View Logic

    private func updateTouchLocation(to location: CGPoint) {
        touchLocation = location
    }

    private func gestureStarted() {
        startButtonRippleEffectAnimation()
        startButtonTitleTapAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { startButtonElevationAnimation() }
    }

    private func gestureCancelled() {
        endButtonRippleEffectAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { resetButtonElevationAnimation() }
    }

    private func gestureEnded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            endButtonRippleEffectAnimation()
            action()
            resetButtonElevationAnimation()
        }
    }

    /// Update the Pending Indicator when the button appears (used from the `.onAppear` modifier).
    private func setInitialPendingState() {
        guard !isSetupComplete else { return }
        pendingStateChanged(to: isPending, after: 0.0)
    }

    /// Update the Pending Indicator with the default delay (used from the `.onChange` modifier).
    /// - Parameter pending: The new pending state
    private func pendingStateChanged(to pending: Bool) {
        pendingStateChanged(to: pending, after: isButtonShapeRemoved ? 0.0 : 0.3)
    }

    /// Update the Pending Indicator.
    /// - Parameters:
    ///   - pending: The new pending state
    ///   - delayInSeconds: The delay to start and stop the animation (used to wait for the ripple effect to finish first)
    private func pendingStateChanged(to pending: Bool, after delayInSeconds: Double) {
        if pending {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { showIndicator = true }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { showIndicator = false }
        }
    }

    private func startButtonTitleTapAnimation() {
        if isButtonShapeRemoved {
            var transaction = Transaction(animation: titleOpacityAnimation)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                titleOpacity = 0.6
            }
        }
    }

    private func startButtonRippleEffectAnimation() {
        isPressed = true
    }

    private func endButtonRippleEffectAnimation() {
        isPressed = false
    }

    private func startButtonElevationAnimation() {
        var transaction = Transaction(animation: .default)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            elevationShadowOffset = 10
            elevationShadowRadius = 5
            elevationShadowOpacity = 1
        }
    }

    private func resetButtonElevationAnimation() {
        elevationShadowOffset = 0
        elevationShadowRadius = 0
        elevationShadowOpacity = 0
    }

    private func resetButtonTitleAnimation() {
        var transaction = Transaction(animation: titleOpacityAnimation)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            titleOpacity = 1
        }
    }

}
