//
//  ProfileCellView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 25/04/2023.
//

import SwiftUI

struct ProfileCellView: View {
    var image: String
    var text: String
    
    var body: some View {
        ActivityLogContainer {
            HStack {
                iconView
                textView
            }
            .frame(maxWidth: 300)
            .frame(height: 60)
            .foregroundColor(darkBlueColor)
            .background(RoundedRectangle(cornerRadius: 20).fill(.white))
            .clipped()
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
            .frame(height: 60)
            .padding(.horizontal, 10.0)
    }
    
    var iconView: some View {
        Image(systemName: image)
            .resizable()
            .scaledToFit()
            .padding(15.0)
            .accessibilityLabel(Text(text))
            .frame(width: 60, height: 60)
            .background(Color.random.opacity(0.4))
            .cornerRadius(15, corners: [.bottomLeft, .topLeft])
    }
}
