//
// 📄 SwiftUIMDTextField.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct SwiftUIMDTextField: View {
    
    // View States
    @State var isSlashed: Bool
    
    @Binding var value: String
    @Environment(\.textFieldErrorMessage) private var errorMessage: String
    @Environment(\.isEnabled) private var isEnabled
    
    //Animation States
    @State var placeholderFontSize = CGFloat(16)
    @State var placeholderOffset = CGSize(width: 0, height: 0)
    @State var placeholderColor: Color
    @State var borderWidth = CGFloat(1)
    @State var borderColor: Color
    
    // Constant Properties
    private let placeholderText: String
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void
    
    // Computed Properties
    private var isErrorStateSet: Bool { errorMessage != "" ? true : false}
    
    // TextField General Styling
    private var style: MDTextFieldStyle
    private let textFieldHeight: CGFloat
    private let errorFieldHeight: CGFloat
    private let cornerRadius: CGFloat
    private let secureIcon: (slashed: Image, unslashed: Image)?
    private let icon: Image?
    private let iconSize: CGSize
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    private let errorMessageFontSize: CGFloat
    
    // TextField Colors
    
    private let textColor: Color
    private let textColorDisabled: Color
    private let backgroundColor: Color
    private let backgroundColorDisabled: Color
    private let borderColorDisabled: Color
    private let focusedColor: Color
    private let errorMessageColor: Color
    private let errorMessageBackgroundColor: Color
    
    /// A Material Design Text Field in SwiftUI
    /// - Parameters:
    ///   - placeholder: The placeholder text appearing on the text field.
    ///   - style: The text field style (see MDTextFieldStyle for options). Choose only cases without `Secured`.
    ///   - value: The text field´s value as a Binding.
    ///   - onEditingChanged: The action to be performed when the text field gets focused or comes out of focus.
    ///   - onCommit: The action to be performed when the text field input has been submitted.
    ///
    /// If the text field is followed by a `textFieldErrorMessage` modifier, the text field will change into an error state when the modifiers value has been set to a non-empty string. You can control the error state of the text field by setting the value of `textFieldErrorMessage`.
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
    public init(placeholder: String, style: MDTextFieldStyle = .filled(), value: Binding<String>, icon: Image? = nil, securedIcon: (slashed: Image, unslashed: Image)? = (Image(systemName: "eye.slash.fill"), Image(systemName: "eye.fill")), onEditingChanged: @escaping (Bool) -> Void = { _ in }, onCommit: @escaping () -> Void = {} ) {
        self.placeholderText = placeholder
        self.style = style
        self._value = value
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self.focusedColor = style.focusedColor
        self.textColor = style.textColor
        self.textColorDisabled = style.textColorDisabled
        self.backgroundColor = style.backgroundColor
        self.backgroundColorDisabled = style.backgroundColorDisabled
        self.borderColor = style.borderColor
        self.borderColorDisabled = style.borderColorDisabled
        self.placeholderColor = style.textColor
        self.errorMessageColor = style.errorMessageColor
        self.errorMessageBackgroundColor = style.errorMessageBackgroundColor
        self.textFieldHeight = style.textFieldHeight
        self.errorFieldHeight = style.errorFieldHeight
        self.cornerRadius = style.cornerRadius
        self.horizontalPadding = style.padding.horizontal
        self.verticalPadding = style.padding.vertical
        self.iconSize = style.iconSize
        self.secureIcon = securedIcon
        self.icon = icon
        self.errorMessageFontSize = style.errorMessageFontSize
        self.isSlashed = style.isSecured
    }
    
    public var body: some View {
        container
    }
    
    @ViewBuilder var container: some View {
        VStack(alignment: .leading) {
            
            content
                .padding(.horizontal, horizontalPadding)
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
        guard isEnabled else { return backgroundColorDisabled }
        return isErrorStateSet ? errorMessageBackgroundColor : backgroundColor
    }
    
    private var outlinedBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(borderColor, lineWidth: borderWidth)
    }
    
    private var bottomBorder: some View {
        Rectangle()
            .frame(height: borderWidth)
            .foregroundColor(isEnabled ? borderColor : borderColorDisabled)
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
                .foregroundColor(isEnabled ? placeholderColor : textColorDisabled)
                .font(.system(size: placeholderFontSize))
                .background(placeholderBackground)
                .offset(placeholderOffset)
            
            textFieldView
                .foregroundColor(textColor)
        }
    }
    
    @ViewBuilder private var textFieldView: some View {
        if #available(iOS 15.0, *) {
            TextFieldiOS15(isSlashed: $isSlashed, textFieldValue: $value, onFocusChange: focusStateChanged, onCommit: onCommit)
        } else {
            TextFieldiOS14(isSlashed: $isSlashed, textFieldValue: $value, onFocusChange: focusStateChanged, onCommit: onCommit)
        }
    }
    
    @available(iOS 15.0, *)
    private struct TextFieldiOS15: View {
        
        @Binding var isSlashed: Bool
        @Binding var textFieldValue: String
        var onFocusChange: (Bool) -> Void
        var onCommit: () -> Void
        @FocusState var isFocused: Bool
        
        public var body: some View {
            textField
                .onChange(of: isFocused, perform: onFocusChange)
                .focused($isFocused)
                .onSubmit(onCommit)
        }
        
        @ViewBuilder private var textField: some View {
            if isSlashed {
                SecureField("", text: $textFieldValue)
            }
            else {
                TextField("", text: $textFieldValue)
            }
        }
        
        private func submitValue() {
            onCommit()
        }
    }
    
    private struct TextFieldiOS14: View {
        
        @Binding var isSlashed: Bool
        @Binding var textFieldValue: String
        var onFocusChange: (Bool) -> Void
        var onCommit: () -> Void
        
        @State var isFocused: Bool = false
        
        public var body: some View {
            textField
                .onChange(of: isFocused, perform: onFocusChange)
                .onTapGesture(perform: setFocus)
        }
        
        @ViewBuilder private var textField: some View {
            if isSlashed {
                SecureField("", text: $textFieldValue, onCommit: submitValue)
            }
            else {
                TextField("", text: $textFieldValue, onCommit: submitValue)
            }
        }
        
        private func setFocus() {
            isFocused = true
            print("true")
        }
        
        private func submitValue() {
            onCommit()
            hideKeyboard()
            
            isFocused = false
            print("false")
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
        if style == .filledSecured() || style == .outlinedSecured() {
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
    
    private func focusStateChanged(to isFocused: Bool) {
        if isErrorStateSet {
            placeholderColor = style.textColor
            borderColor = errorMessageColor
            borderWidth = 1
        }
        else if isFocused {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                switch style {
                case .filled, .filledSecured: startFocusedAnimationForFilled()
                case .outlined, .outlinedSecured: startFocusedAnimationForOutlined()
                }
            }
        }
        else if value == "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                resetFocusedAnimation()
            }
        }
        onEditingChanged(isFocused)
    }
    
    private func startFocusedAnimationForFilled() {
        var transaction = Transaction(animation: .easeIn(duration: 0.2))
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            placeholderFontSize = 10
            placeholderOffset = CGSize(width: 0, height: -((textFieldHeight / 2) - 8))
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
            placeholderOffset = CGSize(width: 0, height: -(textFieldHeight / 2))
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
