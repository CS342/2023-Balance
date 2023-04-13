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
let violetColor = Color(#colorLiteral(red: 0.45, green: 0.04, blue: 0.72, alpha: 1.00))
let lightVioletColor = Color(#colorLiteral(red: 0.8540708423, green: 0.6704638004, blue: 0.9807910323, alpha: 1))
let lightGrayColor = Color(#colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1))

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
