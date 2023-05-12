//
//  CardView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 12/05/2023.
//

import SwiftUI

struct CardImageView: View {
    var image: String
    
    var body: some View {
        VStack {
            ZStack {
                Group {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .accessibilityLabel(image)
                }
                .frame(maxWidth: 300, maxHeight: 300)
                .foregroundColor(violetColor)
                .clipped()
                .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24))
                .background(RoundedRectangle(cornerRadius: 5).fill(.white))
                .shadow(color: Color.black.opacity(0.50), radius: 3, x: 2, y: 2)
                Image("stiky")
                    .offset(y: -190)
                    .accessibilityLabel("stiky")
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardImageView(image: "")
    }
}
