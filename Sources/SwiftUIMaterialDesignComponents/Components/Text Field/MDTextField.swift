//
// 📄 MDTextField.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct MDTextField: View {

    @Environment(\.textFieldErrorMessage) private var errorMessage: String
    @Environment(\.isEnabled) private var isEnabled

    // View States
    @State private var state: TextFieldState
    @State private var isFocused = false
    @State private var canChangeFocus = true
    @State private var isContentSecured: Bool
    @Binding private var text: String

    // Animation States
    @State private var backgroundColor: Color
    @State private var placeholderFontSize: CGFloat
    @State private var placeholderOffset: CGSize
    @State private var inputFieldOffset: CGSize
    @State private var placeholderColor: Color
    @State private var borderWidth: CGFloat
    @State private var borderColor: Color
    @State private var iconColor: Color?

    // Constant Properties
    private let emptyString = ""
    private let zeroOffset = CGSize()
    private let placeholderText: String
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void
    private let defaultOffset: CGFloat
    private let placeholderOffsetUnfocusedState = CGSize()
    private let sequence: Sequence?

    // Computed Properties
    private var isErrorMessageSet: Bool { !errorMessage.isEmpty }
    private var isInErrorState: Bool { state == .focusedError || state == .unfocusedError }
    private var isDisabled: Bool { !isEnabled }
    private var hasFilledAppearance: Bool { style.appearance == .filled }
    private var isContentEmpty: Bool { text.isEmpty }
    private var placeholderOffsetForFilledStyle: CGSize { CGSize(width: .zero, height: -defaultOffset) }
    private var placeholderOffsetForOutlinedStyle: CGSize { CGSize(width: 0, height: -(textFieldHeight / 2)) }
    private var placeholderOffsetFocusedState: CGSize { hasFilledAppearance ? placeholderOffsetForFilledStyle : placeholderOffsetForOutlinedStyle }
    private var inputFieldOffsetFocusedState: CGSize { hasFilledAppearance ? inputFieldOffsetForFilledStyle : zeroOffset }
    private var inputFieldOffsetForFilledStyle: CGSize { CGSize(width: 0, height: defaultOffset) }
    private var currentlyFocusedTextFieldID: Binding<Int> { sequence?.$currentlyFocusedID ?? .constant(0) }

    // TextField Styling
    private var style: Style
    private let textFieldHeight: CGFloat
    private let textFontSize: CGFloat
    private let errorFieldHeight: CGFloat
    private let cornerRadius: CGFloat
    private let secureIcon: (securedContent: Image, unsecuredContent: Image)?
    private let icon: Image?
    private let iconSize: CGSize
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    private let errorMessageFontSize: CGFloat

    // TextField Colors
    private let textColor: Color
    private let textColorDisabled: Color
    private let backgroundColorDisabled: Color
    private let borderColorDisabled: Color
    private let focusedColor: Color
    private let errorMessageColor: Color
    private let errorMessageBackgroundColor: Color

    /// A Material Design Text Field in SwiftUI
    /// - Parameters:
    ///   - placeholder: The placeholder text appearing on the text field.
    ///   - style: The text field style (see Style for options). Choose only cases without `Secured`.
    ///   - value: The text field´s value as a Binding.
    ///   - icon: The trailing icon of the text field.
    ///   - secureIcon: The secure icon of the secured text field. Onyl specify this, when using `Secured` styles.
    ///   - iconColor: The icon´s color.
    ///   - onEditingChanged: The action to be performed when the text field gets focused or comes out of focus.
    ///   - onCommit: The action to be performed when the text field input has been submitted.
    ///
    /// If the text field is followed by a `textFieldErrorMessage` modifier, the text field will change into an error state when the modifiers value has been set to a non-empty string. You can control the error state of the text field by setting the value of `textFieldErrorMessage`.
    ///
    ///     struct ExampleView: View {
    ///
    ///         @State private var text: String = ""
    ///         @State private var errorMessage: String = ""
    ///
    ///         var body: some View {
    ///             MDTextField(placeholder: "My TextField", style: .outlined(), value: $text, onEditingChanged: {}, onCommit: onCommit)
    ///                 .textFieldErrorMessage(errorMessage)
    ///         }
    ///
    ///         private func onCommit() {
    ///             if text.count < 8 {
    ///                 errorMessage = "Too short"
    ///             }
    ///         }
    ///
    ///     }
    ///
    public init(placeholder: String, style: Style = .filled, value: Binding<String>, icon: Image? = nil, securedIcon: (securedContent: Image, unsecuredContent: Image)? = (Image(systemName: "eye.slash.fill"), Image(systemName: "eye.fill")), iconColor: Color? = nil, onEditingChanged: @escaping (Bool) -> Void = { _ in }, onCommit: @escaping () -> Void = { }, sequence: Sequence? = nil) {
        self.placeholderText = placeholder
        self.style = style
        self._text = value
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self.sequence = sequence
        self.focusedColor = style.focusedColor
        self.textColor = style.textColor
        self.textColorDisabled = style.textColorDisabled
        self.backgroundColor = style.backgroundColor
        self.backgroundColorDisabled = style.backgroundColorDisabled
        self.borderColorDisabled = style.borderColorDisabled
        self.errorMessageColor = style.errorMessageColor
        self.errorMessageBackgroundColor = style.errorMessageBackgroundColor
        self.textFieldHeight = style.textFieldHeight
        self.textFontSize = style.textFontSize
        self.errorFieldHeight = style.errorFieldHeight
        self.cornerRadius = style.cornerRadius
        self.horizontalPadding = style.padding.horizontal
        self.verticalPadding = style.padding.vertical
        self.iconSize = style.iconSize
        self.secureIcon = securedIcon
        self.icon = icon
        self.iconColor = iconColor ?? style.textColor
        self.errorMessageFontSize = style.errorMessageFontSize
        self.isContentSecured = style.isSecured

        self.defaultOffset = (style.textFieldHeight - style.textFontSize - style.placeholderFontSize) / 2
        let hasFilledAppearance: Bool = style.appearance == .filled
        let isValueAlreadySet: Bool = !value.wrappedValue.isEmpty
        let placeholderOffsetForFilledStyleWithValueAlreadySet = CGSize(width: 0, height: -defaultOffset)
        let placeholderOffsetForOutlinedStyleWithValueAlreadySet = CGSize(width: 0, height: -(textFieldHeight / 2))

        self.placeholderFontSize = isValueAlreadySet ? CGFloat(10) : style.placeholderFontSize
        self.placeholderColor = style.textColor
        self.placeholderOffset = isValueAlreadySet ? (hasFilledAppearance ? placeholderOffsetForFilledStyleWithValueAlreadySet : placeholderOffsetForOutlinedStyleWithValueAlreadySet) : zeroOffset
        let inputFieldOffsetForFilledStyle = CGSize(width: 0, height: defaultOffset)
        let inputFieldOffsetFocusedState: CGSize = hasFilledAppearance ? inputFieldOffsetForFilledStyle : zeroOffset

        self.inputFieldOffset = isValueAlreadySet ? inputFieldOffsetFocusedState : zeroOffset
        self.borderWidth = 1
        self.borderColor = style.borderColor
        self.state = isValueAlreadySet ? .unfocusedPopulated : .unfocused
    }

    public var body: some View {
        container
            .onChange(of: isEnabled, perform: onEnabelingChange)
            .onChange(of: errorMessage, perform: onErrorMessageChange)
            .onChange(of: text, perform: onValueChange)
            .onChange(of: isFocused, perform: onFocusChange)
            .onChange(of: state, perform: onStateChange)
    }

    @ViewBuilder var container: some View {
        VStack(alignment: .leading) {
            content
                .padding(.horizontal, horizontalPadding)
                .background(backgroundLayer)
                .onTapGesture(perform: focusTextField)

            errorMessageView
                .conditionalPadding(.horizontal, horizontalPadding, if: isErrorMessageSet, otherwiseHidden: true)
        }
    }

    @ViewBuilder private var backgroundLayer: some View {
        switch style.appearance {
        case .filled: filledBackground
        case .outlined: outlinedBackground
        }
    }

    private var filledBackground: some View {
        backgroundColor
            .cornerRadius(cornerRadius, corners: .topLeft)
            .cornerRadius(cornerRadius, corners: .topRight)
            .overlay(bottomBorder, alignment: .bottom)
    }

    private var currentBackgroundColor: some View {
        guard isEnabled else { return backgroundColorDisabled }
        return isErrorMessageSet ? errorMessageBackgroundColor : backgroundColor
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
                .foregroundColor(iconColor)
                .animation(.default, value: isContentSecured)
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
                .frame(height: placeholderFontSize)
                .offset(placeholderOffset)

            textFieldView
                .font(.system(size: textFontSize))
                .foregroundColor(textColor)
                .offset(inputFieldOffset)
        }
    }

    @ViewBuilder private var textFieldView: some View {
        if #available(iOS 15.0, *) {
            TextFieldiOS15(isFocused: $isFocused, isContentSecured: $isContentSecured, text: $text, canChangeFocus: $canChangeFocus, currentlyFocusedTextFieldID: currentlyFocusedTextFieldID, sequence: sequence, onCommit: onCommit)
        } else {
            TextFieldiOS14(isFocused: $isFocused, isContentSecured: $isContentSecured, text: $text, onCommit: onCommit)
        }
    }

    @ViewBuilder private var placeholder: some View {
        Text(placeholderText)
            .foregroundColor(placeholderColor)
            .font(.system(size: placeholderFontSize))
            .background(placeholderBackground)
    }

    @ViewBuilder private var placeholderBackground: some View {
        switch style.appearance {
        case .filled: Color.clear
        case .outlined: Color.white
        }
    }

    @ViewBuilder private var iconView: some View {
        if style.isSecured {
            secureIconView?
                .resizable()
                .onTapGesture(perform: toggleContentSecurity)
        } else {
            icon?
                .resizable()
        }
    }

    @ViewBuilder private var secureIconView: Image? {
        isContentSecured ? secureIcon?.securedContent : secureIcon?.unsecuredContent
    }

    private func onEnabelingChange(to enabled: Bool) {
        determineTextFieldState()
    }

    private func onErrorMessageChange(to message: String) {
        determineTextFieldState()
    }

    private func onValueChange(to value: String) {
        determineTextFieldState()
    }

    private func onFocusChange(to focus: Bool) {
        determineTextFieldState()
        onEditingChanged(isFocused)
    }

    private func determineTextFieldState() {
        guard isEnabled else { state = .disabled; return }
        switch (isErrorMessageSet, isFocused) {
        case (true, true): state = .focusedError
        case (true, false): state = .unfocusedError
        case (false, true): state = .focused
        case (false, false) where !isContentEmpty: state = .unfocusedPopulated
        default:
            state = .unfocused
        }
    }

    private func onStateChange(to state: TextFieldState) {
        switch state {
        case .unfocused: configureUnfocusedState()
        case .focused: configureFocusedState()
        case .unfocusedError: configureUnfocusedErrorState()
        case .focusedError: configureFocusedErrorState()
        case .unfocusedPopulated: configureUnfocusedPopulatedState()
        case .disabled: configureDisabledState()
        }
    }

    private func configureFocusedState() {
        let backgroundColor: Color = style.backgroundColor
        let placeholderFontSize: CGFloat = 10
        let placeholderColor = style.focusedColor
        let placeholderOffset = placeholderOffsetFocusedState
        let inputFieldOffset = inputFieldOffsetFocusedState
        let borderWidth: CGFloat = 2
        let borderColor = style.focusedColor
        let animationDelay = 0.1

        configureState(placeholderFontSize: placeholderFontSize, placeholderOffset: placeholderOffset, placeholderColor: placeholderColor, inputFieldOffset: inputFieldOffset, borderWidth: borderWidth, borderColor: borderColor, backgroundColor: backgroundColor, animationDelay: animationDelay)
    }

    private func configureUnfocusedState() {
        let backgroundColor: Color = style.backgroundColor
        let placeholderFontSize: CGFloat = 16
        let placeholderColor = style.textColor
        let placeholderOffset = placeholderOffsetUnfocusedState
        let inputFieldOffset = zeroOffset
        let borderWidth: CGFloat = 1
        let borderColor = style.borderColor
        let animationDelay = 0.01

        configureState(placeholderFontSize: placeholderFontSize, placeholderOffset: placeholderOffset, placeholderColor: placeholderColor, inputFieldOffset: inputFieldOffset, borderWidth: borderWidth, borderColor: borderColor, backgroundColor: backgroundColor, animationDelay: animationDelay)
    }

    private func configureFocusedErrorState() {
        let backgroundColor: Color = style.errorMessageBackgroundColor
        let placeholderFontSize: CGFloat = 10
        let placeholderColor = style.textColor
        let placeholderOffset = placeholderOffsetFocusedState
        let inputFieldOffset = inputFieldOffsetFocusedState
        let borderWidth: CGFloat = 2
        let borderColor = style.errorMessageColor
        let animationDelay = 0.0

        configureState(placeholderFontSize: placeholderFontSize, placeholderOffset: placeholderOffset, placeholderColor: placeholderColor, inputFieldOffset: inputFieldOffset, borderWidth: borderWidth, borderColor: borderColor, backgroundColor: backgroundColor, animationDelay: animationDelay)
    }

    private func configureUnfocusedErrorState() {
        let backgroundColor: Color = style.errorMessageBackgroundColor
        let placeholderFontSize: CGFloat = 10
        let placeholderColor = style.textColor
        let placeholderOffset = placeholderOffsetFocusedState
        let inputFieldOffset = zeroOffset
        let borderWidth: CGFloat = 2
        let borderColor = style.errorMessageColor
        let animationDelay = 0.0

        configureState(placeholderFontSize: placeholderFontSize, placeholderOffset: placeholderOffset, placeholderColor: placeholderColor, inputFieldOffset: inputFieldOffset, borderWidth: borderWidth, borderColor: borderColor, backgroundColor: backgroundColor, animationDelay: animationDelay)
    }

    private func configureUnfocusedPopulatedState() {
        let backgroundColor: Color = style.backgroundColor
        let placeholderFontSize: CGFloat = 10
        let placeholderColor = style.textColor
        let placeholderOffset = placeholderOffsetFocusedState
        let inputFieldOffset = inputFieldOffsetFocusedState
        let borderWidth: CGFloat = 1
        let borderColor = style.borderColor
        let animationDelay = 0.01

        configureState(placeholderFontSize: placeholderFontSize, placeholderOffset: placeholderOffset, placeholderColor: placeholderColor, inputFieldOffset: inputFieldOffset, borderWidth: borderWidth, borderColor: borderColor, backgroundColor: backgroundColor, animationDelay: animationDelay)
    }

    private func configureDisabledState() {
        backgroundColor = style.backgroundColorDisabled
        placeholderFontSize = 10
        placeholderColor = style.textColorDisabled
        placeholderOffset = placeholderOffsetUnfocusedState
        borderWidth = 2
        borderColor = style.borderColorDisabled
        iconColor = style.textColorDisabled
    }

    private func configureState(placeholderFontSize: CGFloat, placeholderOffset: CGSize, placeholderColor: Color, inputFieldOffset: CGSize, borderWidth: CGFloat, borderColor: Color, backgroundColor: Color, animationDelay: Double) {
        var transaction = Transaction(animation: .easeIn(duration: 0.2))
        transaction.disablesAnimations = true
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            withTransaction(transaction) {
                self.backgroundColor = backgroundColor
                self.placeholderFontSize = placeholderFontSize
                self.placeholderOffset = placeholderOffset
                self.inputFieldOffset = inputFieldOffset
                self.placeholderColor = placeholderColor
                self.borderWidth = borderWidth
                self.borderColor = borderColor
            }
        }
    }

    private func focusTextField() {
        isFocused = true
    }

    private func toggleContentSecurity() {
        if isFocused { canChangeFocus = false }
        isContentSecured.toggle()
    }

}

private extension MDTextField {

    @available(iOS 15.0, *)
    struct TextFieldiOS15: View {

        @FocusState private var isFocused: Bool

        @Binding private var isFocusTriggered: Bool
        @Binding private var isContentSecured: Bool
        @Binding private var canChangeFocus: Bool
        @Binding private var text: String
        @Binding private var currentlyFocusedTextFieldID: Int

        let sequence: Sequence?
        let onCommit: () -> Void

        init(isFocused: Binding<Bool>, isContentSecured: Binding<Bool>, text: Binding<String>, canChangeFocus: Binding<Bool>, currentlyFocusedTextFieldID: Binding<Int>, sequence: Sequence?, onCommit: @escaping () -> Void) {
            self._isFocusTriggered = isFocused
            self._isContentSecured = isContentSecured
            self._text = text
            self._canChangeFocus = canChangeFocus
            self._currentlyFocusedTextFieldID = currentlyFocusedTextFieldID
            self.sequence = sequence
            self.onCommit = onCommit
        }

        public var body: some View {
            textField
                .onChange(of: isFocused, perform: onFocusChange)
                .onChange(of: isFocusTriggered, perform: changeFocusIfNeeded)
                .onChange(of: currentlyFocusedTextFieldID, perform: onFocusChangeSequencedTextField)
                .focused($isFocused)
                .onSubmit(submit)
        }

        @ViewBuilder private var textField: some View {
            if isContentSecured {
                SecureField("", text: $text)
                    .submitLabel(submitLabel)
            } else {
                TextField("", text: $text)
                    .submitLabel(submitLabel)
            }
        }

        private var submitLabel: SubmitLabel {
            guard let sequence else { return .done }
            return SubmitLabel(from: sequence.submitLabel)
        }

        private func submit() {
            sequence?.proceedToNextTextField()
            onCommit()
        }

        private func onFocusChange(to focused: Bool) {
            guard canChangeFocus else {
                isFocused = true
                canChangeFocus = true
                return
            }
            isFocusTriggered = isFocused
        }

        private func changeFocusIfNeeded(to focused: Bool) {
            guard isFocused != isFocusTriggered else { return }
            isFocused = isFocusTriggered
        }

        private func onFocusChangeSequencedTextField(to currentID: Int) {
            guard let sequence else { return }
            if sequence.id == currentID { isFocused = true }
        }

    }

    struct TextFieldiOS14: View {

        @Binding var isFocused: Bool
        @Binding var isContentSecured: Bool
        @Binding var text: String

        var onCommit: () -> Void

        public var body: some View {
            textField
                .onTapGesture(perform: setFocus)
        }

        @ViewBuilder private var textField: some View {
            if isContentSecured {
                SecureField("", text: $text, onCommit: submitValue)
            } else {
                TextField("", text: $text, onCommit: submitValue)
            }
        }

        private func setFocus() {
            isFocused = true
        }

        private func submitValue() {
            onCommit()
            hideKeyboard()
            isFocused = false
        }

    }

}
