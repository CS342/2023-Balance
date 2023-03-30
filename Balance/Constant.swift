//
//  Constant.swift
//  Balance
//
//  Created by Gonzalo Perisset on 27/03/2023.
//

import Foundation
import SwiftUI

struct Constant {
    static let primaryColor = Color(#colorLiteral(red: Float(0.30), green: Float(0.79), blue: Float(0.94), alpha: Float(1.00)))
    static let navigationBarHeight = 120.0
    static let fcolor = Color(red: 0.25, green: 0.38, blue: 0.50, opacity: 1.00)
    static let bcolor = Color(red: 0.30, green: 0.79, blue: 0.94, opacity: 0.05)
    
    
}

extension Color {
    static func random() -> Color {
        return Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
}

