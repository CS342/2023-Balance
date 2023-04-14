//
//  AvatarView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 14/04/2023.
//

import SwiftUI

struct AvatarView: View {
    @State var isChecked = false
    var avatar: Avatar
    
    var body: some View {
        Button(action: toggle) {
            ZStack(alignment: .center) {
                Image(avatar.name)
                    .resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    .scaledToFit()
                    .accessibilityLabel(avatar.name)
                Image(systemName: isChecked ? "checkmark.circle" : "circle")
                    .background(Circle().fill(.white))
                    .offset(x: -60, y: -60)
            }
            .padding(5.0)
            .frame(maxWidth: 130, maxHeight: 130)
            .foregroundColor(fcolor)
            .background(RoundedRectangle(cornerRadius: 20).fill(.white))
            .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
        }
    }
    
    func toggle() {
        isChecked.toggle()
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(avatar: Avatar(name: "avatar_5"))
    }
}
