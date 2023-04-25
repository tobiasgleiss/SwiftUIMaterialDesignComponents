//
// 📄 SwiftUIMDButton.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct SwiftUIMDButton: View {

    @Environment(\.isButtonPending) private var isPending: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.buttonTapAreaInsets) private var tapAreaInsets: EdgeInsets

    // Default values
    public static let defaultWidth: CGFloat = 300
    public static let defaultHeight: CGFloat = 45

    // View States
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

    // Button Styling
    let style: MDButtonStyle
    let borderWidth: CGFloat
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let horizontalAlignment: HorizontalAlignment
    let rippleEffectColor: Color
    let pendingIndicatorColor: Color
    let elevationShadowColor: Color
    let isRippleEffectDisabled: Bool // TODO: Invert logic to be positive --> isRippleEffectEnabled

    // Button Content
    let title: String
    let leadingIcon: SwiftUIMDButtonIcon?
    let trailingIcon: SwiftUIMDButtonIcon?

    // Button Action
    let action: () -> Void

    // Computed Properties
    var backgroundColor: Color { isEnabled ? style.buttonColor.normal : style.buttonColor.disabled }
    var titleColor: Color { isEnabled ? style.textColor.normal : style.textColor.disabled }
    var isAlignedTextButton: Bool { style.isText && style.buttonAlignment != .center } // TODO: This doesn't have to be computed!
    var isButtonShapeRemoved: Bool { isRippleEffectDisabled || isAlignedTextButton } // TODO: This doesn't have to be computed & invert logic to be positive: useButtonShape
    var dragArea: CGRect { CGRect(x: 0, y: 0, width: width, height: height) } // TODO: Does this have to be computed?

    /// The SwiftUI Material Design Button
    /// - Parameters:
    ///   - title: The text appearing on the button
    ///   - style: The button style (see `MDButtonStyle` for options)
    ///   - icon: The icon to display alongside the button title
    ///   - width: The width of the button
    ///   - height: The height of the button
    ///   - isRippleEffectDisabled: Indicates if the RippleEffect should be disabled
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
    ///             SwiftUIMDButton(title: "Do stuff", style: .secondary, action: togglePending)
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
    public init(title: String, style: MDButtonStyle = .contained(), icon: SwiftUIMDButtonIcon? = nil, width: CGFloat = SwiftUIMDButton.defaultWidth, height: CGFloat = SwiftUIMDButton.defaultHeight, isRippleEffectDisabled: Bool = false, action: @escaping () -> Void = { }) {
        self.title = title
        self.style = style
        self.leadingIcon = icon?.position == .leading ? icon : nil
        self.trailingIcon = icon?.position == .trailing ? icon : nil
        self.width = width
        self.height = height
        self.isRippleEffectDisabled = isRippleEffectDisabled
        self.action = action
        self.touchLocation = CGPoint(x: height / 2, y: width / 2)
        self.cornerRadius = style.buttonCornerRadius
        self.horizontalAlignment = style.buttonAlignment
        self.borderWidth = style.buttonBorderWidth
        self.rippleEffectColor = style.rippleEffectColor.whileActive
        self.pendingIndicatorColor = style.pendingIndicatorColor
        self.elevationShadowColor = style.buttonElevationShadow.color
    }

    public var body: some View {
        alignedButton
            .frame(maxWidth: .infinity)
    }

    private var alignedButton: some View {
        HStack {
            Spacer()
                .hidden(horizontalAlignment == .leading, andRemoved: true)

            button
                .contentShape(Rectangle())
                .conditionalFrameWidth(width, if: !isAlignedTextButton)
                .frame(height: height)
                .cornerRadius(cornerRadius)
                .onChange(of: isPending, perform: pendingStateChanged)
                .onAnimationCompleted(for: titleOpacity, onCompletionExecute: resetButtonTitleAnimation)
                .shadow(color: elevationShadowColor.opacity(elevationShadowOpacity), radius: elevationShadowRadius, x: 0, y: elevationShadowOffset)
                .increaseTapArea(tapAreaInsets)
                .onTouchGesture(onStarted: gestureStarted, onLocationUpdate: updateTouchLocation, onEnded: gestureEnded, onCancelled: gestureCancelled)

            Spacer()
                .hidden(horizontalAlignment == .trailing, andRemoved: true)
        }
    }

    private var button: some View {
        ZStack {
            buttonBackgroundShape

            SwiftUIMDRippleEffect(isPressed: $isPressed, tapLocation: $touchLocation, rippleEffectColor: rippleEffectColor)
                .hidden(isButtonShapeRemoved, andRemoved: true)

            buttonTitleContent
        }
    }

    @ViewBuilder private var buttonBackgroundShape: some View {
        switch style {
        case .contained: containedButtonBackground
        case .outlined: outlinedButtonBackground
        case .text: EmptyView()
        }
    }

    @ViewBuilder private var buttonTitleContent: some View {
        if showIndicator {
            SwiftUIMDActivityIndicator()
                .activityIndicatorColor(pendingIndicatorColor)
        } else {
            HStack {
                leadingIcon
                    .foregroundColor(titleColor)

                Text(title)
                    .foregroundColor(titleColor)
                    .font(style.buttonFont)
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

    private var textButtonBackground: some View {
        Rectangle()
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
        resetButtonElevationAnimation()
    }

    private func gestureEnded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            endButtonRippleEffectAnimation()
            action()
            resetButtonElevationAnimation()
        }
    }

    private func pendingStateChanged(to pending: Bool) {
        if pending {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showIndicator = true }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showIndicator = false }
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

// Implementation inspired by https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-the-location-of-a-tap-inside-a-view
struct TouchLocationView: UIViewRepresentable {

    struct TouchType: OptionSet {
        let rawValue: Int
        static let started = TouchType(rawValue: 1)
        static let ended = TouchType(rawValue: 2)
        static let cancelled = TouchType(rawValue: 3)
        static let all: TouchType = [.started, .ended, .cancelled]
    }

    let onStarted: () -> Void
    let onLocationUpdate: (CGPoint) -> Void
    let onEnded: () -> Void
    let onCancelled: () -> Void

    let types = TouchType.all

    func makeUIView(context: Context) -> TouchLocationUIView {
        let view = TouchLocationUIView()
        view.onStarted = onStarted
        view.onLocationUpdate = onLocationUpdate
        view.onEnded = onEnded
        view.onCancelled = onCancelled
        view.touchTypes = types
        return view
    }

    func updateUIView(_ uiView: TouchLocationUIView, context: Context) { }

    class TouchLocationUIView: UIView {

        var onStarted: (() -> Void)?
        var onLocationUpdate: ((CGPoint) -> Void)?
        var onEnded: (() -> Void)?
        var onCancelled: (() -> Void)?
        var touchTypes: TouchLocationView.TouchType = .all

        override init(frame: CGRect) {
            super.init(frame: frame)
            isUserInteractionEnabled = true
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            isUserInteractionEnabled = true
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            determineAction(with: location, forEvent: .started)
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            determineAction(with: location, forEvent: .ended)
        }

        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            determineAction(with: location, forEvent: .cancelled)
        }

        private func determineAction(with location: CGPoint, forEvent event: TouchType) {
            guard touchTypes.contains(event) else { return }
            onLocationUpdate?(location)
            switch event {
            case .started: onStarted?()
            case .ended: onEnded?()
            case .cancelled: onCancelled?()
            default: do { }
            }
        }

    }

}
