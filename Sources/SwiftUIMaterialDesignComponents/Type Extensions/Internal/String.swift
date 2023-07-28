//
// 📄 String.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import Foundation

extension String {

    var speakEachCharacterInVoiceOver: String {
        grouped(in: 1, seperatedBy: " ")
    }

    /// Adds a space after every n-th character.
    /// - Parameters:
    ///   - stride: the number of characters in the group, before a separator is inserted
    ///   - separator: the separator to insert after each stride
    func grouped(in stride: Int, seperatedBy separator: String = " ") -> String {
        enumerated().map { $0.isMultiple(of: stride) && ($0 != 0) ? "\(separator)\($1)" : String($1) }.joined()
    }

}
