//
//  Constant.swift
//  Balance
//
//  Created by Gonzalo Perisset on 27/03/2023.
//

import Foundation
import SwiftUI

let balWidth = UIScreen.main.bounds.width
let balHeight = UIScreen.main.bounds.height

let primaryColor = Color(#colorLiteral(red: Float(0.30), green: Float(0.79), blue: Float(0.94), alpha: Float(1.00)))
let navigationBarHeight = 120.0
let darkBlueColor = Color(red: 0.25, green: 0.38, blue: 0.50, opacity: 1.00)
let backgroundColor = Color(#colorLiteral(red: 0.9882352941, green: 0.9882352941, blue: 0.9882352941, alpha: 1))
let violetColor = Color(#colorLiteral(red: 0.45, green: 0.04, blue: 0.72, alpha: 1.00))
let lightVioletColor = Color(#colorLiteral(red: 0.8540708423, green: 0.6704638004, blue: 0.9807910323, alpha: 1))
let lightGrayColor = Color(#colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1))
let facesGrayColor = Color(#colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1))
let darkGrayColor = Color(#colorLiteral(red: 0.2352026105, green: 0.2347485423, blue: 0.2638042867, alpha: 1))
let emotionColor = Color(#colorLiteral(red: 0.8635568023, green: 0.9771735072, blue: 0.9613562226, alpha: 1))
let correctOption = Color(#colorLiteral(red: 0.6474730372, green: 1, blue: 0.8112064004, alpha: 1))
let wrongOption = Color(#colorLiteral(red: 0.9673425555, green: 0.1463843882, blue: 0.5197440386, alpha: 1))

enum ChillType {
    case breathing
    case head
    case shoulders
    case hands
    case knee
    case legs
    case feet
}

enum BreathSteps {
    case inhale
    case holdInhale
    case exhale
    case holdExhale
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
