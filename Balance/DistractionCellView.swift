//
//  DistractionCellView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/03/2023.
//

import SwiftUI

struct DistractionCellView: View {
    var image: String
    var text: String
    var textDescription: String

    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .accessibilityLabel(Text(text))
                .frame(maxWidth: 120)
                .background(Constant.primaryColor .opacity(0.4))
                .cornerRadius(15, corners: [.bottomLeft, .topLeft])
            VStack {
                Text(text)
                    .font(.custom("Nunito-Bold", size: 18))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 30)
                Text(textDescription)
                    .font(.custom("Nunito", size: 14))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 40)
            }
        }
//        .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 0))
        .frame(maxWidth: 311, maxHeight: 120)
        .foregroundColor(Constant.fcolor)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .clipped()
        .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
    }
}
// swiftlint:disable line_length
struct DistractionCellView_Previews: PreviewProvider {
    static var previews: some View {
        DistractionCellView(image: "BalanceLogo", text: "Listen to Music", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
    }
}
