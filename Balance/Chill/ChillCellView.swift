//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct ChillCellView: View {
    var image: String
    var text: String
    var pointVal: String

    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .accessibility(hidden: true)
                .frame(width: 80, height: 80)
            Spacer()
            Text(text)
                .padding(.leading, 20.0)
                .minimumScaleFactor(0.5)
                .font(.custom("Nunito-Bold", size: 25))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 80)
            Spacer()
            VStack {
                pointValueView
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 0))
        .frame(maxWidth: 311, maxHeight: 114)
        .foregroundColor(darkBlueColor)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .clipped()
        .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
    }
    
    var pointValueView: some View {
        ZStack {
            Text(pointVal)
                .font(.custom("Nunito-Bold", size: 14))
                .frame(width: 30, height: 20)
                .padding(.trailing, 25.0)
                .padding(.vertical, 3.0)
                .background(primaryColor .opacity(0.4))
                .cornerRadius(5)
                .offset(x: -10)
            Image("pointsStarIcon")
                .accessibility(hidden: true)
        }.offset(y: -15)
    }
}

struct ChillCellViewPreview: PreviewProvider {
    static var previews: some View {
        ChillCellView(image: "BalanceLogo", text: "diary", pointVal: "5")
    }
}
