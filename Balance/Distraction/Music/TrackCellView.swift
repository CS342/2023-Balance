//
//  TrackCellView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 12/06/2023.
//

import SwiftUI

struct TrackCellView: View {
    var image: String
    var text: String
    var duration: String

    var body: some View {
        ActivityLogContainer {
            HStack {
                iconView
                VStack {
                    Spacer()
                    textView
                    durationView
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
            .font(.custom("Nunito-Bold", size: 12))
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 40)
            .padding(.horizontal, 10.0)
            .offset(y: -10)
    }
    
    var durationView: some View {
        Text(text)
            .font(.custom("Montserrat", size: 12))
            .lineLimit(1)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 30)
            .padding(.horizontal, 10.0)
            .offset(y: -10)
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
struct TrackCellView_Previews: PreviewProvider {
    static var previews: some View {
        TrackCellView(image: "BalanceLogo", text: "Listen to Music", duration: "3:21 segs")
    }
}
#endif