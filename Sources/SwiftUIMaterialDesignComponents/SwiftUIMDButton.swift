//
// 📄 SwiftUIMDButton.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct SwiftUIMDButton: View {
    
    @Environment(\.isButtonPending) private var isPending: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    // Default values
    public static let defaultWidth: CGFloat = 300
    public static let defaultHeight: CGFloat = 45
    
    // View States
    @State private var isPressed: Bool = false
    @State private var showIndicator: Bool = false
    @State private var tapLocation: CGPoint
    @State private var rippleEffectAnimationFinished: Bool = false
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
    let leadingIcon: Image?
    let isRippleEffectDisabled: Bool
    
    // Computed Properties
    var backgroundColor: Color { isEnabled ? style.buttonColor.normal : style.buttonColor.disabled }
    var titleColor: Color { isEnabled ? style.textColor.normal : style.textColor.disabled }
    var isAlignedTextButton: Bool { style.isText && style.buttonAlignment != .center }
    var isButtonShapeRemoved: Bool { isRippleEffectDisabled || isAlignedTextButton}
    
    // Button Content
    let title: String
    
    // Button Action
    let action: () -> Void
    
    /// A Material Design button in SwiftUI
    /// - Parameters:
    ///   - title: The text appearing on the button
    ///   - style: The button style (see MDButtonStyle for options).
    ///   - customHeight: The height of the button.
    ///   - customWidth: The width of the button.
    ///   - leadingIcon: The image which is displayed as a leading icon.
    ///   - disableRippleEffect: If the RippleEffect should be disabled.
    ///   - action: The action that is executed when the user taps the button.
    ///
    /// If the button is followed by a `pending`, it will be overlayed with an Activity Indicator replacing the title for as long as it is in pending state. A typical use case would look like this:
    ///
    ///     struct ExampleView: View {
    ///
    ///         @State private var isPending: Bool = false
    ///         @State private var isDisabled: Bool = false
    ///
    ///         var body: some View {
    ///             SGButton("Do stuff", style: .secondary, action: buttonAction)
    ///                 .pending(isPending)
    ///                 .disabled(isDisabled)
    ///         }
    ///
    ///         /// Call from anywhere to toggle the pending indicator on the SGButton
    ///         private func togglePending() {
    ///             isPending.toggle()
    ///         }
    ///
    ///     }
    ///
    /// - Attention: If the MDButtonStyle is set to `.text` and it´s property `horizontalAlignment` is set to `.leading` or `.trailing` the RippleEffect will automatically be disabled as well as the button shape. Only a centered text button has the ability to have a RippleEffect. 
    public init(title: String, style: MDButtonStyle = .contained(), width: CGFloat = SwiftUIMDButton.defaultWidth, height: CGFloat = SwiftUIMDButton.defaultHeight, leadingIcon: Image? = nil, disableRippleEffect: Bool = false, action: @escaping () -> Void = { }) {
        self.tapLocation = CGPoint(x: height / 2, y: width / 2)
        self.title = title
        self.action = action
        self.style = style
        self.width = width
        self.height = height
        self.cornerRadius = style.buttonCornerRadius
        self.horizontalAlignment = style.buttonAlignment
        self.borderWidth = style.buttonBorderWidth
        self.rippleEffectColor = style.rippleEffectColor.whileActive
        self.pendingIndicatorColor = style.pendingIndicatorColor
        self.elevationShadowColor = style.buttonElevationShadow.color
        self.leadingIcon = leadingIcon
        self.isRippleEffectDisabled = disableRippleEffect
    }
    
    public var body: some View {
        alignedButton
            .frame(maxWidth: .infinity)
    }
    
    private var tap: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if !isPressed {
                    tapLocation = value.location
                }
                isPressed = true
            }
            .onEnded { value in
                isPressed = false
            }
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
                .onChange(of: isPressed, perform: pressedStateChanged)
                .onChange(of: rippleEffectAnimationFinished, perform: animationStateChanged)
                .onAnimationCompleted(for: titleOpacity, onCompletionExecute: resetButtonTitleAnimation)
                .shadow(color: elevationShadowColor.opacity(elevationShadowOpacity), radius: elevationShadowRadius, x: 0, y: elevationShadowOffset)
                .gesture(tap)
            
            Spacer()
                .hidden(horizontalAlignment == .trailing, andRemoved: true)
        }
    }
    
    private var button: some View {
        ZStack {
            buttonBackgroundShape
            
            SwiftUIMDRippleEffect(isPressed: $isPressed, tapLocation: $tapLocation, rippleEffectColor: rippleEffectColor, isFinished: $rippleEffectAnimationFinished)
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
                .padding(.all, 10)
                .scaledToFit() // REVIEW: Das war nur gegen das eiern, oder? Vielleicht sollte das in den Activity Indicator selbst rein und vielleicht wäre fixedSize besser?
        } else {
            HStack {
                leadingIcon
                    .foregroundColor(titleColor)
               
                Text(title)
                    .foregroundColor(titleColor)
                    .font(style.buttonFont)
                    .fontWeight(.bold)
                    .opacity(titleOpacity)
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
    
    private func pendingStateChanged(to pending: Bool) {
        if pending {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showIndicator = true
            }
        } else {
            showIndicator = false
        }
    }
    
    private func setRippleEffectAnimationFinished() {
        rippleEffectAnimationFinished = true
    }
    
    private func pressedStateChanged(to pressed: Bool) {
        if pressed {
            startButtonTitleTapAnimation()
        }
        else {
            action()
            elevationShadowOffset = 0
            elevationShadowRadius = 0
            elevationShadowOpacity = 0
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
    
    private func animationStateChanged(to finished: Bool) {
        if isPressed {
            var transaction = Transaction(animation: .default)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                elevationShadowOffset = 10
                elevationShadowRadius = 5
                elevationShadowOpacity = 1
            }
        }
    }
    
    private func resetElevationAnimation() {
        elevationShadowRadius = 0
        elevationShadowOffset = 0
    }
    
    private func resetButtonTitleAnimation() {
        var transaction = Transaction(animation: titleOpacityAnimation)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            titleOpacity = 1
        }
    }
    
}
