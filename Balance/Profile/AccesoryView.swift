//
//  AccesoryView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 17/04/2023.
//

import SwiftUI

struct AccesoryView: View {
    @Binding var item: Accesory
    @Binding var selectedItem: Accesory.ID?
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(item.name)
                .resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                .scaledToFit()
                .accessibilityLabel(item.name)
            Image((item.id == selectedItem) ? "checkFill" : "check")
                .resizable()
                .frame(width: 40, height: 40)
                .clipped()
                .offset(x: -50, y: -50)
                .accessibilityLabel("avatarCheck")
        }
        .padding(15.0)
        .frame(maxWidth: 100, maxHeight: 100)
        .foregroundColor(fcolor)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
    }
}
