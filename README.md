# SwiftUIMaterialDesignComponents

Welcome to SwiftUIMaterialDesignComponents! This package tries to recreate several [Material Design](https://m2.material.io/) (Material Design 2) components in SwiftUI and make their usage more convenient and customizable. 

# SwiftUIMDActivity Indicator

The Material Design circular [Activity Indicator](https://m2.material.io/components/progress-indicators#usage) (or progress indicator).

<img alt="SwiftUIMDActivityIndicator" src="Sources/Readme/SwiftUIMDActivityIndicator.gif?raw=1" height="100"/>

Basic usage:
```sh
SwiftUIMDActivityIndicator()
```

# SwiftUIMDButton

The Material Design [Button](https://m2.material.io/components/buttons) with Ripple Effect with the following style and appearance options:

- Contained
- Outlined
- Text

You can customize these style options further with creating your own styles with an extension of `MDButtonStyle`. 

## Contained Button

<img alt="SwiftUIMDButton Contained" src="Sources/Readme/SwiftUIMDButton_Contained.gif?raw=1" height="75"/>

Basic usage:
```sh
SwiftUIMDButton(title: "My Contained Button", style: .contained())
```

## Outlined Button

<img alt="SwiftUIMDButton Outlined" src="Sources/Readme/SwiftUIMDButton_Outlined.gif?raw=1" height="75"/>

Basic usage:
```sh
SwiftUIMDButton(title: "My Outlined Button", style: .outlined())
``` 

## Text Button

<img alt="SwiftUIMDButton Text" src="Sources/Readme/SwiftUIMDButton_Text.gif?raw=1" height="75"/>

Basic usage:
```sh
SwiftUIMDButton(title: "My Text Button", style: .text())
``` 

# SwiftUIMDTextField

The Material Design TextField with the following style and functional options:

- Filled
- FilledSecured
- Outlined
- OutlinedSecured

You can customize these style options further with creating your own styles with an extension of `MDTextFieldStyle`. 

**Note**: The TextField switches to an error state with corresponding style if you attach the modifier `.textFieldErrorMessage` and set the value of the error message after committing the TextField´s value. 

## Filled TextField

<img alt="SwiftUIMDTextField Filled" src="Sources/Readme/SwiftUIMDTextField_Filled.gif?raw=1" height="125"/>

Basic usage:
```sh
@State var errorMessage: String = ""
@State var textFieldValue: String = ""

SwiftUIMDTextField(placeholder: "My Filled TextField", style: .filled(), value: $textFieldValue, onCommit: { print("Do stuff") } )
.textFieldErrorMessage(errorMessage)
``` 

## Filled Secured TextField

<img alt="SwiftUIMDTextField Filled Secured" src="Sources/Readme/SwiftUIMDTextField_FilledSecured.gif?raw=1" height="125"/>

Basic usage:
```sh
@State var errorMessage: String = ""
@State var textFieldValue: String = ""

SwiftUIMDTextField(placeholder: "My Filled Secured TextField", style: .filledSecured(), value: $textFieldValue, onCommit: { print("Do stuff") } )
.textFieldErrorMessage(errorMessage)
``` 

## Outlined TextField

<img alt="SwiftUIMDTextField Outlined" src="Sources/Readme/SwiftUIMDTextField_Outlined.gif?raw=1" height="125"/>

Basic usage:
```sh
@State var errorMessage: String = ""

@State var textFieldValue: String = ""

SwiftUIMDTextField(placeholder: "My Outlined TextField", style: .outlined(), value: $textFieldValue, onCommit: { print("Do stuff") } )
.textFieldErrorMessage(errorMessage)
```

## Outlined Secured TextField

<img alt="SwiftUIMDTextField Outlined" src="Sources/Readme/SwiftUIMDTextField_OutlinedSecured.gif?raw=1" height="125"/>

Basic usage:
```sh
@State var errorMessage: String = ""
@State var textFieldValue: String = ""

SwiftUIMDTextField(placeholder: "My Outlined Secured TextField", style: .outlinedSecured(), value: $textFieldValue, onCommit: { print("Do stuff") } )
.textFieldErrorMessage(errorMessage)
```

# SwiftUIMDRippleEffect

The Material Design Ripple Effect. Please have a look at the initializer documentation for customizing options. 

**Note**: The SwiftUIMDButton has the Ripple Effect already built in. 

<img alt="SwiftUIMDRippleEffect" src="Sources/Readme/SwiftUIMDRippleEffect.gif?raw=1" height="125"/>

Basic usage:
```sh
@State var isPressed: Bool = false
@State var tapLocation: CGPoint = CGPoint(x: 0, y: 0)

SwiftUIMDRippleEffect(isPressed: $isPressed, tapLocation: $tapLocation, rippleEffectColor: .purple)
```

**Note**: The Ripple Effect´s animation will start from the specified `CGPoint` in the parameter `tapLocation`.

# Installation

  

```sh

dependencies: [

.package(url: "https://github.com/tobiasgleiss/SwiftUIMaterialDesignComponents", .upToNextMajor(from: "1.0.0"))

]

```
