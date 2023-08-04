//
//  CellView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 14/06/2023.
//

import SwiftUI

struct CellView: View {
    var image: String
    var text: String
    
    var body: some View {
        HStack {
            iconView
            textView
        }
        .frame(maxWidth: 311, maxHeight: 120)
        .foregroundColor(darkBlueColor)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .clipped()
        .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
    }
    
    var textView: some View {
        Text(text)
            .font(.custom("Nunito-Bold", size: 18))
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 100)
            .padding(.horizontal, 10.0)
            .offset(y: -5)
    }
    
    var iconView: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .padding(15.0)
            .accessibilityLabel(Text(text))
            .frame(maxWidth: 120)
            .background(Color.random.opacity(0.4))
            .cornerRadius(15, corners: [.bottomLeft, .topLeft])
    }
}
