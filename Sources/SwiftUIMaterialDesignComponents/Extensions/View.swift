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
    
    /// Increases the tap area around a SwiftUIMDButton. This is especially helpful on horizontally aligned text only buttons.
    /// - Parameters: 
    ///   - edges: The edges to inset
    ///   - length: The length of the inset
    @discardableResult public func increaseButtonTapArea(_ edges: Edge.Set = .all, by length: CGFloat) -> some View {
        let topInset = (edges == .all || edges == .vertical || edges == .top) ? length : 0
        let leadingInset = (edges == .all || edges == .horizontal || edges == .leading) ? length : 0
        let bottomInset = (edges == .all || edges == .vertical || edges == .bottom) ? length : 0
        let trailingInset = (edges == .all || edges == .horizontal || edges == .trailing) ? length : 0
        return increaseButtonTapArea(top: topInset, leading: leadingInset, bottom: bottomInset, trailing: trailingInset)
    }
    
    /// Increases the tap area around a SwiftUIMDButton. This is especially helpful on horizontally aligned text only buttons.
    /// - Parameters: 
    ///   - top: The top inset
    ///   - leading: The leading inset
    ///   - bottom: The bottom inset
    ///   - trailing: The trailing inset   
    @discardableResult public func increaseButtonTapArea(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) -> some View {
        let tapAreaInsets = EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        return environment(\.buttonTapAreaInsets, tapAreaInsets)
    }
    
    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - onCompletionExecute: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    @discardableResult internal func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, onCompletionExecute: @escaping () -> Void) -> ModifiedContent<Self, AnimationObserverModifier<Value>> {
        modifier(AnimationObserverModifier(observedValue: value, onCompletionExecute: onCompletionExecute))
    }
    
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
    @discardableResult internal func hidden(_ isHidden: Bool, andRemoved remove: Bool = false) -> some View {
        modifier(HiddenModifier(isHidden: isHidden, remove: remove))
    }
    
    /// Sets the frame of the view based on a condition.
    @discardableResult internal func conditionalFrameWidth(_ width: CGFloat, if isActive: Bool) -> some View {
        modifier(ConditionalFrameModifier(isActive: isActive, width: width))
    }
    
    /// Increases the Tap Area of the View by the given insets.
    @discardableResult internal func increaseTapArea(_ tapAreaInsets: EdgeInsets) -> some View {
        self
            .padding(tapAreaInsets)
            .contentShape(Rectangle())
    }
    
}
