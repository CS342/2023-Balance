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
    var pointVal: String
    
    var body: some View {
        ActivityLogContainer {
            HStack {
                iconView
                VStack {
                    HStack {
                        Spacer()
                        pointValueView
                    }
                    Spacer()
                    textView
                    Spacer()
                }
            }
            .frame(maxWidth: 311, maxHeight: 120)
            .foregroundColor(darkBlueColor)
            .background(RoundedRectangle(cornerRadius: 20).fill(.white))
            .clipped()
            .frame(height: 120.0)
            .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
        }
    }
    
    var textView: some View {
        Text(text)
            .font(.custom("Nunito-Bold", size: 18))
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 80)
            .padding(.horizontal, 10.0)
            .offset(y: -10)
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
            Image("pointsStarIcon").accessibilityLabel("pointsStarIcon")
        }.offset(y: 10)
    }
    
    var iconView: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .padding(15.0)
            .frame(height: 120.0)
            .accessibilityLabel(Text(text))
            .frame(maxWidth: 120)
            .background(Color.random.opacity(0.4))
            .cornerRadius(15, corners: [.bottomLeft, .topLeft])
    }
}

#if DEBUG
struct DistractionCellView_Previews: PreviewProvider {
    static var previews: some View {
        DistractionCellView(image: "BalanceLogo", text: "Listen to Music", pointVal: "+5")
    }
}
#endif
