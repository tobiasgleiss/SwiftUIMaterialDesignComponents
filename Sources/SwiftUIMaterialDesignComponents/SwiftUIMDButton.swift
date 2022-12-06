//
// 📄 SwiftUIMDButton.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct SwiftUIMDButton: View {
    
    @Environment(\.isButtonPending) private var isPending: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    // Default values
    let rippleEffectScalingDefault: CGFloat = 0
    let rippleEffectOpacityDefault: CGFloat = 0.2
    public static let buttonWidthDefault: CGFloat = 360
    public static let buttonHeightDefault: CGFloat = 45
    
    // View States
    @State var isPressed: Bool = false
    @State var showIndicator: Bool = false
    @State var tapLocation: CGPoint
    @State var rippleEffectAnimationFinished: Bool = false
    @State var buttonElevationShadowRadius: CGFloat = 0
    @State var buttonElevationShadowOffset: CGFloat = 0
    
    // Animations
    let rippleEffectScalingAnimation: Animation = .easeIn(duration: 0.3)
    let rippleEffectFadeOutAnimation: Animation = .easeInOut(duration: 0.2)
    
    // Button Styling
    let buttonStyle: mdButtonStyle
    let buttonBorderWidth: CGFloat
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    let buttonCornerRadius: CGFloat
    let buttonRippleEffectColor: Color
    let buttonPendingIndicatorColor: Color
    let buttonElevationShadowColor: Color
    let buttonLeadingIcon: Image?
    
    // Computed Properties
    var buttonColor: Color { isEnabled ? buttonStyle.buttonColor.normal : buttonStyle.buttonColor.disabled }
    var buttonCaptionColor: Color { isEnabled ? buttonStyle.textColor.normal : buttonStyle.textColor.disabled }
    
    // Button Content
    let buttonCaption: String
    
    // Button Action
    let buttonAction: () -> Void
    
    /// A Material Design button in SwiftUI
    /// - Parameters:
    ///   - caption: The text appearing on the button
    ///   - style: The button style (see mdButtonStyle for options).
    ///   - customHeight: The height of the button.
    ///   - customWidth: The width of the button.
    ///   - leadingIcon: The image which is displayed as a leading icon.
    ///   - action: The action that is executed when the user taps the button
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
    public init(displays caption: String = "A button this is", style: mdButtonStyle = .contained(), customHeight: CGFloat = SwiftUIMDButton.buttonHeightDefault, customWidth: CGFloat = SwiftUIMDButton.buttonWidthDefault, leadingIcon: Image? = nil, action: @escaping () -> Void = { } ) {
        tapLocation = CGPoint(x: customHeight/2, y: customWidth/2)
        buttonCaption = caption
        buttonAction = action
        buttonStyle = style
        buttonWidth = customWidth
        buttonHeight = customHeight
        buttonCornerRadius = style.buttonCornerRadius
        buttonBorderWidth = style.buttonBorderWidth
        buttonRippleEffectColor = style.rippleEffectColor.whileActive
        buttonPendingIndicatorColor = style.pendingIndicatorColor
        buttonElevationShadowColor = style.buttonElevationShadow.color
        buttonLeadingIcon = leadingIcon
    }
    
    
    public var body: some View {
        if #available(iOS 16.0, *) {
            button
                .gesture(tap)
        } else {
            button
                .onTapGesture(perform: buttonWasTapped)
        }
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
    
    private var button: some View {
        buttonLayers
            .contentShape(Rectangle())
            .frame(width: buttonWidth)
            .frame(height: buttonHeight)
            .cornerRadius(buttonCornerRadius)
            .onChange(of: isPending, perform: pendingStateChanged)
            .onChange(of: isPressed, perform: pressedStateChanged)
            .onChange(of: rippleEffectAnimationFinished, perform: animationStateChanged)
            .shadow(color: buttonElevationShadowColor, radius: buttonElevationShadowRadius, x: 0, y: buttonElevationShadowOffset)
    }
    
    private var buttonLayers: some View {
        ZStack {
            buttonBackgroundShape
            
            SwiftUIMDRippleEffect(isPressed: $isPressed, tapLocation: $tapLocation, rippleEffectColor: buttonRippleEffectColor, isFinished: $rippleEffectAnimationFinished)
                
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
                .padding(.all, 12)
                .activityIndicatorStrokeWidth(3)
                .activityIndicatorColor(buttonPendingIndicatorColor)
        } else {
            HStack {
                buttonLeadingIcon
                    .foregroundColor(buttonCaptionColor)
               
                Text(buttonCaption)
                    .foregroundColor(buttonCaptionColor)
                    .font(buttonStyle.buttonFont)
                    .fontWeight(.bold)
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
    
    private func buttonWasTapped() {
        buttonAction()
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
        if !pressed {
            buttonElevationShadowOffset = 0
            buttonElevationShadowRadius = 0
        }
    }
    
    private func animationStateChanged(to finished: Bool) {
        if finished && isPressed {
            var transaction = Transaction(animation: .default)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                buttonElevationShadowOffset = 10
                buttonElevationShadowRadius = 5
            }
        }
        else if finished && !isPressed {
            buttonWasTapped()
        }
    }
    
    private func resetElevationAnimation() {
        buttonElevationShadowRadius = 0
        buttonElevationShadowOffset = 0
    }
}

