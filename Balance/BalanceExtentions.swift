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

extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        guard let windowScene = connectedScenes.first(where: { $0.windows.contains(where: { $0.isKeyWindow }) }) else {
            return nil
        }
        return windowScene.windows.first(where: { $0.isKeyWindow })
    }
}
