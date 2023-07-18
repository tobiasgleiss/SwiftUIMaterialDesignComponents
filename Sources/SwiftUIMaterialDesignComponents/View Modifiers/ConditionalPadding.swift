//
// 📄 ConditionalPadding.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

extension View {

    /// Adds padding if the specified condition is met.
    /// - Parameters:
    ///   - edges: The edges to apply padding to
    ///   - length: The (scaled) length of the padding
    ///   - condition: The condition under which the padding is applied
    /// - Returns: The view with the applied conditional padding
    @discardableResult func conditionalPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil, if condition: Bool, otherwiseHidden isHiddenIfConditionFails: Bool = false) -> some View {
        modifier(ConditionalPadding(edges, length, if: condition, otherwiseHidden: isHiddenIfConditionFails))
    }

}

private struct ConditionalPadding: ViewModifier {

    private let edges: Edge.Set
    private let length: CGFloat?
    private let condition: Bool
    private let isHiddenIfConditionFails: Bool

    init(_ edges: Edge.Set = .all, _ length: CGFloat? = nil, if condition: Bool, otherwiseHidden isHiddenIfConditionFails: Bool) {
        self.edges = edges
        self.length = length
        self.condition = condition
        self.isHiddenIfConditionFails = isHiddenIfConditionFails
    }

    func body(content: Content) -> some View {
        content
            .padding(edges, condition ? length : 0)
            .hidden(isHiddenIfConditionFails && !condition, andRemoved: true)
    }

}
