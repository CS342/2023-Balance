//
//  AvatarView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 14/04/2023.
//

import SwiftUI

struct AvatarView: View {
    @Binding var item: Avatar
    @Binding var selectedItem: Avatar.ID?
    @Binding var selectedNameItem: String?

    var body: some View {
        ZStack(alignment: .center) {
            Image(item.name)
                .resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                .scaledToFit()
                .accessibilityLabel(item.name)
//            Image((item.id == selectedItem) ? "checkFill" : "check")
//                .resizable()
//                .frame(width: 40, height: 40)
//                .clipped()
//                .offset(x: -50, y: -50)
//                .accessibilityLabel("avatarCheck")
            Image((item.name == selectedNameItem) ? "checkFill" : "check")
                .resizable()
                .frame(width: 40, height: 40)
                .clipped()
                .offset(x: -50, y: -50)
                .accessibilityLabel("avatarCheck")
        }
        .padding(15.0)
        .frame(maxWidth: 100, maxHeight: 100)
        .foregroundColor(darkBlueColor)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
    }
}
