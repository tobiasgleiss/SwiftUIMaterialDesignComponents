//
// 📄 MDButton.TapArea.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public extension View {

    /// Increases the tap area around a MDButton. This is especially helpful on horizontally aligned text only buttons.
    /// - Parameters:
    ///   - edges: The edges to inset
    ///   - length: The length of the inset
    @discardableResult func increaseButtonTapArea(_ edges: Edge.Set = .all, by length: CGFloat) -> some View {
        let topInset = (edges == .all || edges == .vertical || edges == .top) ? length : 0
        let leadingInset = (edges == .all || edges == .horizontal || edges == .leading) ? length : 0
        let bottomInset = (edges == .all || edges == .vertical || edges == .bottom) ? length : 0
        let trailingInset = (edges == .all || edges == .horizontal || edges == .trailing) ? length : 0
        return increaseButtonTapArea(top: topInset, leading: leadingInset, bottom: bottomInset, trailing: trailingInset)
    }

    /// Increases the tap area around a MDButton. This is especially helpful on horizontally aligned text only buttons.
    /// - Parameters:
    ///   - top: The top inset
    ///   - leading: The leading inset
    ///   - bottom: The bottom inset
    ///   - trailing: The trailing inset
    @discardableResult func increaseButtonTapArea(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) -> some View {
        let tapAreaInsets = EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        return environment(\.buttonTapAreaInsets, tapAreaInsets)
    }

    /// Increases the Tap Area of the View by the given insets.
    @discardableResult internal func increaseTapArea(_ tapAreaInsets: EdgeInsets) -> some View {
        padding(tapAreaInsets)
            .contentShape(Rectangle())
    }

}

private struct ButtonTapAreaInsets: EnvironmentKey {

    static let defaultValue = EdgeInsets.zero

}

extension EnvironmentValues {

    var buttonTapAreaInsets: EdgeInsets {
        get { self[ButtonTapAreaInsets.self] }
        set { self[ButtonTapAreaInsets.self] = newValue }
    }

}

// MARK: Private Helper

private extension EdgeInsets {

    static let zero = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

}
