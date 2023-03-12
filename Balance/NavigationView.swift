//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct NavView: View {
    var image: String
    var text: String
    
    let fcolor = Color(red: 0.25, green: 0.38, blue: 0.50, opacity: 1.00)
    let bcolor = Color(red: 0.30, green: 0.79, blue: 0.94, opacity: 0.05)
    
    var body: some View {
        HStack(spacing: 130) {
            Text(text)
                .font(.custom("Nunito-Bold", size: 25))
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 20)
                .accessibilityLabel(Text(text))
        }
        .frame(width: 321, height: 114)
        .foregroundColor(fcolor)
        .background(bcolor)
        .cornerRadius(20)
        .padding()
    }
}

struct NavViewPreview: PreviewProvider {
    static var previews: some View {
        NavView(image: "BalanceLogo", text: "diary")
    }
}
