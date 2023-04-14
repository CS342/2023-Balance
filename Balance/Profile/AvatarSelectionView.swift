//
//  AvatarView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 14/04/2023.
//

import SwiftUI

struct AvatarSelectionView: View {
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    private let avatars = (1...6).map { Avatar(name: "avatar_\($0)") }
    private let accesories = (1...4).map { Avatar(name: "acc_\($0)") }
    
    var body: some View {
        VStack {
            ScrollView{
                Spacer().frame(height: 50)
                Text("Choose your avatar")
                    .foregroundColor(violetColor)
                    .font(.custom("Nunito-Bold", size: 34))
                Spacer().frame(height: 50)
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(avatars.indices, id: \.self) { index in
                        AvatarView(avatar: avatars[index])
                    }
                }
                .padding(10.0)
                Spacer().frame(height: 50)
                Text("Choose your accesory")
                    .foregroundColor(violetColor)
                    .font(.custom("Nunito-Bold", size: 24))
                Spacer().frame(height: 50)
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(accesories.indices, id: \.self) { index in
                        AvatarView(avatar: accesories[index])
                    }
                }
            }
        }
    }
}

struct AvatarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarSelectionView()
    }
}
