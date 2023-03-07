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
    
    let fcolor = Color(UIColor(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00))
    let bcolor = Color(UIColor(red: 0.30, green: 0.79, blue: 0.94, alpha: 0.05))
    
    var body: some View {
        HStack {
            Image(image) // TO BE REPLACED LATER
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 20)
            Text(text)
        }
        .frame(width: 360, height: 200)
        .foregroundColor(fcolor)
        .background(bcolor)
        .cornerRadius(40)
        .padding()
    }
}

struct NavViewPreview: PreviewProvider {
    static var previews: some View {
        NavView(image: "BalanceLogo", text: "diary")
    }
}
