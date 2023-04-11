//
//  BalanceExtentions.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI

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
