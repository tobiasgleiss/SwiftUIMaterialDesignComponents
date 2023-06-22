//
// 📄 MDTextField.Sequence.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation
import SwiftUI

public extension MDTextField {

    struct Sequence {

        @Binding public var currentlyFocusedID: Int

        public let id: Int
        public let submitLabel: UIReturnKeyType

        public init(id: Int, submitLabel: UIReturnKeyType, currentlyFocusedID: Binding<Int>) {
            self.id = id
            self.submitLabel = submitLabel
            self._currentlyFocusedID = currentlyFocusedID
        }

        func proceedToNextTextField() {
            currentlyFocusedID = id + 1
        }

    }

}

// TODO: Remove this extension and change UIReturnKeyType to SubmitLabel in MDTextField.Sequence when stopping support for iOS 14

@available(iOS 15.0, *)
extension SubmitLabel {

    init(from returnKeyType: UIReturnKeyType) {
        switch returnKeyType {
        case .default: self = .done
        case .go: self = .go
        case .google: self = .search
        case .join: self = .join
        case .next: self = .next
        case .route: self = .route
        case .search: self = .search
        case .send: self = .send
        case .yahoo: self = .search
        case .done: self = .done
        case .emergencyCall: self = .next
        case .continue: self = .continue
        @unknown default:
            self = .done
        }
    }

}
