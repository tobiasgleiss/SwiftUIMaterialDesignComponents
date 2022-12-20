//
// 📄 View.swift
// 👨‍💻 Author: Tobias Gleiss
//

import SwiftUI

extension View {

    /// Sets the pending state of the SwiftUIMDButton.
    /// - Parameter isPending: The pending state to be used
    /// - Returns: The input with all contained SwiftUIMDButtons in the specifed pending state.
    @discardableResult public func pending(_ isPending: Bool) -> some View {
        environment(\.isButtonPending, isPending)
    }
    
    /// Sets the color of the SwiftUIMDActivityIndicator
    /// - Parameter color: The color to be used
    /// - Returns: The SwiftUIMDActivityIndicator using the specifed color.
    @discardableResult public func activityIndicatorColor(_ color: Color) -> some View {
        environment(\.activityIndicatorColor, color)
    }

    /// Sets the diameter of the SwiftUIMDActivityIndicator
    /// - Parameter diameter: The scaled diameter to be used (will not be scaled for the device later)
    /// - Returns: The SwiftUIMDActivityIndicator using the specifed diameter.
    @discardableResult public func activityIndicatorDiameter(_ diameter: CGFloat) -> some View {
        environment(\.activityIndicatorDiameter, diameter)
    }

    /// Sets the stroke width of the SwiftUIMDActivityIndicator
    /// - Parameter strokeWidth: The scaled stroke width to be used (will not be scaled for the device later)
    /// - Returns: The SwiftUIMDActivityIndicator using the specifed stroke width.
    @discardableResult public func activityIndicatorStrokeWidth(_ strokeWidth: CGFloat) -> some View {
        environment(\.activityIndicatorStrokeWidth, strokeWidth)
    }
    
    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - onCompletionExecute: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    public func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, onCompletionExecute: @escaping () -> Void) -> ModifiedContent<Self, AnimationObserverModifier<Value>> {
        modifier(AnimationObserverModifier(observedValue: value, onCompletionExecute: onCompletionExecute))
    }
    
    /// 👨🏼‍💻 Author: Benno Kress
    /// With kind approval of Benno Kress.
    /// https://github.com/bennokress
    ///
    /// Hide or show the view based on a boolean value.
    /// - Parameters:
    ///   - isHidden: Boolean value indicating whether or not to hide the view
    ///   - remove: Boolean value indicating whether or not to remove the view (view must also be hidden to be removed)
    /// - Returns: The given view shown or hidden/removed.
    ///
    /// Example for visibility:
    /// ```
    /// Text("Label")
    ///     .hidden(true)
    /// ```
    ///
    /// Example for complete removal:
    /// ```
    /// Text("Label")
    ///     .hidden(true, remove: true)
    /// ```
    ///
    @discardableResult internal func hidden(_ isHidden: Bool, andRemoved remove: Bool = false) -> some View {
        modifier(HiddenModifier(isHidden: isHidden, remove: remove))
    }
}
