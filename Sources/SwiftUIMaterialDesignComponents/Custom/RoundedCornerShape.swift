//
// 📄 TouchLocationModifier.swift
// 👨‍💻 Author: Tobias Gleiss
//

import SwiftUI

internal struct RoundedCornerShape: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
