//
//  Constant.swift
//  Balance
//
//  Created by Gonzalo Perisset on 27/03/2023.
//

import Foundation
import SwiftUI

let primaryColor = Color(#colorLiteral(red: Float(0.30), green: Float(0.79), blue: Float(0.94), alpha: Float(1.00)))
let navigationBarHeight = 120.0
let fcolor = Color(red: 0.25, green: 0.38, blue: 0.50, opacity: 1.00)
let bcolor = Color(red: 0.30, green: 0.79, blue: 0.94, opacity: 0.05)

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension Color {
    static var random: Color {
        let colorRND = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
        return colorRND
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
