//
// 📄 SwiftUIMDButton.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct SwiftUIMDButton: View {
    
    @Environment(\.isButtonPending) private var isPending: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    // Default values
    public static let buttonWidthDefault: CGFloat = 300
    public static let buttonHeightDefault: CGFloat = 45
    
    // View States
    @State var isPressed: Bool = false
    let isRippleEffectDisabled: Bool
    @State var showIndicator: Bool = false
    @State var tapLocation: CGPoint
    @State var rippleEffectAnimationFinished: Bool = false
    @State var buttonElevationShadowRadius: CGFloat = 0
    @State var buttonElevationShadowOffset: CGFloat = 0
    @State var buttonElevationShadowOpacity: CGFloat = 0
    @State var buttonCaptionOpacity: CGFloat = 1
    
    // Animations
    let rippleEffectScalingAnimation: Animation = .easeIn(duration: 0.3)
    let rippleEffectFadeOutAnimation: Animation = .easeInOut(duration: 0.2)
    let buttonCaptionOpacityAnimation: Animation = .easeIn(duration: 0.15)
    
    // Button Styling
    let buttonStyle: MDButtonStyle
    let buttonBorderWidth: CGFloat
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    let buttonCornerRadius: CGFloat
    let buttonHorizontalAlignment: HorizontalAlignment
    let buttonRippleEffectColor: Color
    let buttonPendingIndicatorColor: Color
    let buttonElevationShadowColor: Color
    let buttonLeadingIcon: Image?
    
    // Computed Properties
    var buttonColor: Color { isEnabled ? buttonStyle.buttonColor.normal : buttonStyle.buttonColor.disabled }
    var buttonCaptionColor: Color { isEnabled ? buttonStyle.textColor.normal : buttonStyle.textColor.disabled }
    var isAlignedTextButton: Bool { buttonStyle == .text() && (buttonStyle.buttonAlignment == .leading || buttonStyle.buttonAlignment == .trailing)}
    var isButtonShapeRemoved: Bool { isRippleEffectDisabled || isAlignedTextButton}
    
    // Button Content
    let buttonCaption: String
    
    // Button Action
    let buttonAction: () -> Void
    
    /// A Material Design button in SwiftUI
    /// - Parameters:
    ///   - caption: The text appearing on the button
    ///   - style: The button style (see MDButtonStyle for options).
    ///   - customHeight: The height of the button.
    ///   - customWidth: The width of the button.
    ///   - leadingIcon: The image which is displayed as a leading icon.
    ///   - disableRippleEffect: If the RippleEffect should be disabled.
    ///   - action: The action that is executed when the user taps the button.
    ///
    /// ⚠️ If the MDButtonStyle is set to `.text` and it´s property `horizontalAlignment` is set to `.leading` or `.trailing` the RippleEffect will automatically be disabled as well as the button shape. Only a centered text button has the ability to have a RippleEffect. 
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
    public init(displays caption: String = "A button this is", style: MDButtonStyle = .contained(), customHeight: CGFloat = SwiftUIMDButton.buttonHeightDefault, customWidth: CGFloat = SwiftUIMDButton.buttonWidthDefault, leadingIcon: Image? = nil, disableRippleEffect: Bool = false, action: @escaping () -> Void = { } ) {
        tapLocation = CGPoint(x: customHeight/2, y: customWidth/2)
        buttonCaption = caption
        buttonAction = action
        buttonStyle = style
        buttonWidth = customWidth
        buttonHeight = customHeight
        buttonCornerRadius = style.buttonCornerRadius
        buttonHorizontalAlignment = style.buttonAlignment
        buttonBorderWidth = style.buttonBorderWidth
        buttonRippleEffectColor = style.rippleEffectColor.whileActive
        buttonPendingIndicatorColor = style.pendingIndicatorColor
        buttonElevationShadowColor = style.buttonElevationShadow.color
        buttonLeadingIcon = leadingIcon
        isRippleEffectDisabled = disableRippleEffect
    }
    
    
    public var body: some View {
        buttonWrapper
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
    
    private var buttonWrapper: some View {
        HStack {
            Spacer()
                .hidden(buttonHorizontalAlignment == .leading, andRemoved: true)
            
            button
                .contentShape(Rectangle())
                .frame(minWidth: isButtonShapeRemoved ? 0 : buttonWidth)
                .frame(minHeight: 0)
                .frame(height: buttonHeight)
                .cornerRadius(buttonCornerRadius)
                .onChange(of: isPending, perform: pendingStateChanged)
                .onChange(of: isPressed, perform: pressedStateChanged)
                .onChange(of: rippleEffectAnimationFinished, perform: animationStateChanged)
                .onAnimationCompleted(for: buttonCaptionOpacity, onCompletionExecute: resetButtonCaptionAnimation)
                .shadow(color: buttonElevationShadowColor.opacity(buttonElevationShadowOpacity), radius: buttonElevationShadowRadius, x: 0, y: buttonElevationShadowOffset)
                .gesture(tap)
            
            Spacer()
                .hidden(buttonHorizontalAlignment == .trailing, andRemoved: true)
        }
    }
    
    private var button: some View {
        ZStack {
            buttonBackgroundShape
            
            SwiftUIMDRippleEffect(isPressed: $isPressed, tapLocation: $tapLocation, rippleEffectColor: buttonRippleEffectColor, isFinished: $rippleEffectAnimationFinished)
                .hidden(isButtonShapeRemoved, andRemoved: true)
                
            buttonCaptionContent
        }
    }
    
    @ViewBuilder private var buttonBackgroundShape: some View {
        switch buttonStyle {
        case .contained: containedButtonBackground
        case .outlined: outlinedButtonBackground
        case .text: EmptyView()
        }
    }
    
    @ViewBuilder private var buttonCaptionContent: some View {
        if showIndicator {
            SwiftUIMDActivityIndicator()
                .activityIndicatorStrokeWidth(3)
                .activityIndicatorColor(buttonPendingIndicatorColor)
                .padding(.all, 10)
                .scaledToFit()
                
        } else {
            HStack {
                buttonLeadingIcon
                    .foregroundColor(buttonCaptionColor)
               
                Text(buttonCaption)
                    .foregroundColor(buttonCaptionColor)
                    .font(buttonStyle.buttonFont)
                    .fontWeight(.bold)
                    .opacity(buttonCaptionOpacity)
            }
        }
    }
    
    private var containedButtonBackground: some View {
        RoundedRectangle(cornerRadius: buttonCornerRadius)
            .foregroundColor(buttonColor)
    }
    
    private var outlinedButtonBackground: some View {
        RoundedRectangle(cornerRadius: buttonCornerRadius, style: .continuous)
            .stroke(buttonColor, lineWidth: buttonBorderWidth)
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
            startButtonCaptionTapAnimation()
        }
        else {
            buttonAction()
            buttonElevationShadowOffset = 0
            buttonElevationShadowRadius = 0
            buttonElevationShadowOpacity = 0
        }
    }
    
    private func startButtonCaptionTapAnimation() {
        if isButtonShapeRemoved {
            var transaction = Transaction(animation: buttonCaptionOpacityAnimation)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                buttonCaptionOpacity = 0.6
            }
        }
    }
    
    private func animationStateChanged(to finished: Bool) {
        if isPressed {
            var transaction = Transaction(animation: .default)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                buttonElevationShadowOffset = 10
                buttonElevationShadowRadius = 5
                buttonElevationShadowOpacity = 1
            }
        }
    }
    
    private func resetElevationAnimation() {
        buttonElevationShadowRadius = 0
        buttonElevationShadowOffset = 0
    }
    
    private func resetButtonCaptionAnimation() {
        var transaction = Transaction(animation: buttonCaptionOpacityAnimation)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            buttonCaptionOpacity = 1
        }
    }
}

