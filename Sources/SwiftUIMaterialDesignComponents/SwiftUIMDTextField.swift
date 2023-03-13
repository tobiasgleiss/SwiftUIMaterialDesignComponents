//
// 📄 SwiftUIMDTextField.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

@available(iOS 15.0, *)
public struct SwiftUIMDTextField: View {
    
    // View States
    @FocusState var isFocused: Bool
    @State var isSlashed: Bool
    @Binding var input: String
    @Environment(\.textFieldErrorMessage) private var errorMessage: String
    
    //Animation States
    @State var placeholderFontSize = CGFloat(16)
    @State var placeholderOffset = CGSize(width: 0, height: 0)
    @State var placeholderColor: Color
    @State var borderWidth = CGFloat(1)
    @State var borderColor: Color
    
    // Constant Properties
    private let placeholderText: String
    private let onEditingChanged: () -> Void
    private let onCommit: () -> Void
    
    // Computed Properties
    private var isErrorMessageSet: Bool { errorMessage != "" ? true : false}
//    private var showPlaceholderBackground: Bool { isFocused && (style == .outlined() || style == .outlinedSecured()) }
    
    // TextField Styling
    private var style: MDTextFieldStyle
    private let textColor: Color
    private let backgroundColor: Color
    private let focusedColor: Color
    private let errorMessageColor: Color
    private let errorMessageBackgroundColor: Color
    private let textFieldHeight: CGFloat
    private let errorFieldHeight: CGFloat
    private let cornerRadius: CGFloat
    private let secureIcon: (slashed: Image, unslashed: Image)?
    private let icon: Image?
    private let iconSize: CGSize
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    private let errorMessageFontSize: CGFloat
    
    /// A Material Design button in SwiftUI
    /// - Parameters:
    ///   - placeholder: The placeholder text appearing on the text field.
    ///   - style: The text field style (see MDTextFieldStyle for options).
    ///   - value: The text field´s value as a Binding.
    ///   - onEditingChanged: The action to be performed when the text field gets focused.
    ///   - onCommit: The action to be performed when the text field input has been submitted.
    ///
    /// If the button is followed by a `textFieldErrorMessage` modifier, the text field will change into an error state when the modifiers value has been set to a non-empty string. You can control the error state of the text field by setting the value of `textFieldErrorMessage`.
    ///
    ///     struct ExampleView: View {
    ///
    ///         @State private var textFieldValue: String = ""
    ///         @State private var errorMessage: String = ""
    ///
    ///         var body: some View {
    ///             SwiftUIMDTextField(placeholder: "My TextField", style: .outlined(), value: $textFieldValue, onEditingChanged: {}, onCommit: onCommit)
    ///                 .textFieldErrorMessage(errorMessage)
    ///         }
    ///
    ///         private func onCommit() {
    ///             if textFieldValue.count < 8 {
    ///                 errorMessage = "Too short"
    ///             }
    ///         }
    ///
    ///     }
    ///
    public init(placeholder: String, style: MDTextFieldStyle = .filled(), value: Binding<String>, onEditingChanged: @escaping () -> Void, onCommit: @escaping () -> Void) {
        
        self.placeholderText = placeholder
        self.style = style
        self._input = value
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        
        self.focusedColor = style.focusedColor
        self.textColor = style.textColor
        self.backgroundColor = style.backgroundColor
        self.borderColor = style.borderColor
        self.placeholderColor = style.textColor
        self.errorMessageColor = style.errorMessageColor
        self.errorMessageBackgroundColor = style.errorMessageBackgroundColor
        
        self.textFieldHeight = style.textFieldHeight
        self.errorFieldHeight = style.errorFieldHeight
        self.cornerRadius = style.cornerRadius
        self.horizontalPadding = style.padding.horizontal
        self.verticalPadding = style.padding.vertical
        self.iconSize = style.iconSize
        self.secureIcon = style.secureIcon
        self.icon = style.icon
        self.errorMessageFontSize = style.errorMessageFontSize
        
        self.isSlashed = style.isSecured
    }
    
    
    
    public var body: some View {
        container
    }
    
    private var container: some View {
        VStack(alignment: .leading) {
            
            content
                .padding(.horizontal, horizontalPadding)
                .onChange(of: isFocused, perform: focusStateChanged)
                .background(
                    backgroundLayer
                        
                )
            
            errorMessageView
                .padding(.horizontal, horizontalPadding)
        }
    }
    
    @ViewBuilder private var backgroundLayer: some View {
        switch style {
        case .filled, .filledSecured: filledBackground
        case .outlined, .outlinedSecured: outlinedBackground
        }
    }
    
    private var filledBackground: some View {
        currentBackgroundColor
            .cornerRadius(cornerRadius, corners: .topLeft)
            .cornerRadius(cornerRadius, corners: .topRight)
            .overlay(bottomBorder, alignment: .bottom)
    }
    
    private var currentBackgroundColor: some View {
        isErrorMessageSet ? errorMessageBackgroundColor : backgroundColor
    }
    
    private var outlinedBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(borderColor, lineWidth: borderWidth)
    }
    
    private var bottomBorder: some View {
        Rectangle()
            .frame(height: borderWidth)
            .foregroundColor(borderColor)
    }
    
    private var content: some View {
        HStack {
            
            textFieldContainer
                .frame(height: textFieldHeight)
            
            Spacer()

            
            iconView
                .scaledToFit()
                .frame(width: iconSize.width, height: iconSize.height)
                .foregroundColor(textColor)
                
                .animation(.default, value: isSlashed)
                
                
        }
    }
    
    private var errorMessageView: some View {
        Text(errorMessage)
            .foregroundColor(errorMessageColor)
            .font(.system(size: errorMessageFontSize))
    }
    
    private var textFieldContainer: some View {
        ZStack(alignment: .leading) {
            Text(placeholderText)
                .foregroundColor(placeholderColor)
                .font(.system(size: placeholderFontSize))
                .background(placeholderBackground)
                .offset(placeholderOffset)
            
            textFieldView
                .foregroundColor(textColor)
                .focused($isFocused)
                .onSubmit(onCommit)
        }
    }
    
    @ViewBuilder private var placeholder: some View {
        Text(placeholderText)
            .foregroundColor(placeholderColor)
            .font(.system(size: placeholderFontSize))
            .background(placeholderBackground)
    }
    
    @ViewBuilder private var placeholderBackground: some View {
        switch style {
        case .filled, .filledSecured: Color.clear
        case .outlined, .outlinedSecured: Color.white
        }
    }
    
    @ViewBuilder private var iconView: some View {
        if style == .filledSecured() {
            secureIconView?
                .resizable()
                .onTapGesture(perform: toggleSlashedInput)
        } else {
            icon?
                .resizable()
        }
        
    }
    
    @ViewBuilder private var secureIconView: Image? {
        isSlashed ? secureIcon?.slashed : secureIcon?.unslashed
    }
    
    @ViewBuilder private var textFieldView: some View {
        if isSlashed {
            SecureField("", text: $input)
        }
        else {
            TextField("", text: $input)
        }
    }
    
    private func focusStateChanged(to isFocused: Bool) {
        if isFocused {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                switch style {
                case .filled, .filledSecured: startFocusedAnimationForFilled()
                case .outlined, .outlinedSecured: startFocusedAnimationForOutlined()
                }
            }
        }
        else if input == "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                resetFocusedAnimation()
            }
        }
        else if isErrorMessageSet {
            placeholderColor = style.textColor
            borderColor = errorMessageColor
            borderWidth = 1
        }
        onEditingChanged()
    }
    
    private func startFocusedAnimationForFilled() {
        var transaction = Transaction(animation: .easeIn(duration: 0.2))
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            placeholderFontSize = 10
            placeholderOffset = CGSize(width: 0, height: -18)
            placeholderColor = style.focusedColor
            borderWidth = 2
            borderColor = style.focusedColor
        }
    }
    
    private func startFocusedAnimationForOutlined() {
        var transaction = Transaction(animation: .easeIn(duration: 0.2))
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            placeholderFontSize = 10
            placeholderOffset = CGSize(width: 0, height: -28)
            placeholderColor = style.focusedColor
            borderWidth = 2
            borderColor = style.focusedColor
        }
    }
    
    private func resetFocusedAnimation() {
        var transaction = Transaction(animation: .easeIn(duration: 0.2))
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            placeholderFontSize = 16
            placeholderOffset = CGSize(width: 0, height: 0)
            placeholderColor = style.textColor
            borderWidth = 1
            borderColor = style.borderColor
        }
    }
    
    private func toggleSlashedInput() {
        isSlashed.toggle()
    }
}
