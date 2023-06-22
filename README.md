# SwiftUIMaterialDesignComponents

Welcome to SwiftUIMaterialDesignComponents! This package tries to recreate several [Material Design](https://m2.material.io/) (Material Design 2) components in SwiftUI and make their usage more convenient and customizable.

# SwiftUIMDActivity Indicator

The Material Design circular [Activity Indicator](https://m2.material.io/components/progress-indicators#usage) (or progress indicator).

<img alt="MDActivityIndicator" src="Sources/Readme/MDActivityIndicator.gif?raw=1" height="100"/>

Basic usage:
```sh
MDActivityIndicator()
```

# MDButton

The Material Design [Button](https://m2.material.io/components/buttons) with Ripple Effect with the following style and appearance options:

- Contained
- Outlined
- Text

You can customize these style options further with creating your own styles with an extension of `MDButton.Style`.

## Contained Button

<img alt="MDButton Contained" src="Sources/Readme/MDButton_Contained.gif?raw=1" height="75"/>

Basic usage:
```sh
MDButton(title: "My Contained Button", style: .contained)
```

## Outlined Button

<img alt="MDButton Outlined" src="Sources/Readme/MDButton_Outlined.gif?raw=1" height="75"/>

Basic usage:
```sh
MDButton(title: "My Outlined Button", style: .outlined)
```

## Text Button

<img alt="MDButton Text" src="Sources/Readme/MDButton_TextOnly.gif?raw=1" height="75"/>

Basic usage:
```sh
MDButton(title: "My Text Button", style: .textOnly)
```

# MDTextField

The Material Design TextField with the following style and functional options:

- Filled
- FilledSecure
- Outlined
- OutlinedSecure

You can customize these style options further with creating your own styles with an extension of `MDTextField.Style`.

**Note**: The TextField switches to an error state with corresponding style if you attach the modifier `.textFieldErrorMessage` and set the value of the error message after committing the TextField´s value.

## Filled TextField

<img alt="MDTextField Filled" src="Sources/Readme/MDTextField_Filled.gif?raw=1" height="125"/>

Basic usage:
```sh
@State var errorMessage: String = ""
@State var value: String = ""

MDTextField(placeholder: "My Filled TextField", style: .filled, value: $value, onCommit: { print("Do stuff") } )
    .textFieldErrorMessage(errorMessage)
```

## Filled Secured TextField

<img alt="MDTextField Filled Secured" src="Sources/Readme/MDTextField_FilledSecure.gif?raw=1" height="125"/>

Basic usage:
```sh
@State var errorMessage: String = ""
@State var value: String = ""

MDTextField(placeholder: "My Filled Secured TextField", style: .filledSecure, value: $value, onCommit: { print("Do stuff") } )
    .textFieldErrorMessage(errorMessage)
```

## Outlined TextField

<img alt="MDTextField Outlined" src="Sources/Readme/MDTextField_Outlined.gif?raw=1" height="125"/>

Basic usage:
```sh
@State var errorMessage: String = ""
@State var value: String = ""

MDTextField(placeholder: "My Outlined TextField", style: .outlined, value: $value, onCommit: { print("Do stuff") } )
    .textFieldErrorMessage(errorMessage)
```

## Outlined Secured TextField

<img alt="MDTextField Outlined" src="Sources/Readme/MDTextField_OutlinedSecure.gif?raw=1" height="125"/>

Basic usage:
```sh
@State var errorMessage: String = ""
@State var value: String = ""

MDTextField(placeholder: "My Outlined Secured TextField", style: .outlinedSecure, value: $value, onCommit: { print("Do stuff") } )
    .textFieldErrorMessage(errorMessage)
```

# MDRippleEffect

The Material Design Ripple Effect. Please have a look at the initializer documentation for customizing options.

**Note**: The MDButton has the Ripple Effect already built in.

<img alt="MDRippleEffect" src="Sources/Readme/MDRippleEffect.gif?raw=1" height="125"/>

Basic usage:
```sh
@State var isPressed: Bool = false
@State var tapLocation: CGPoint = CGPoint(x: 0, y: 0)

MDRippleEffect(isPressed: $isPressed, tapLocation: $tapLocation, rippleEffectColor: .purple)
```

**Note**: The Ripple Effect´s animation will start from the specified `CGPoint` in the parameter `tapLocation`.

# Installation

```sh
dependencies: [
    .package(url: "https://github.com/tobiasgleiss/SwiftUIMaterialDesignComponents", .upToNextMajor(from: "0.0.0"))
]
```
