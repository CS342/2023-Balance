//
//  AvatarView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 14/04/2023.
//

import SwiftUI

struct AvatarSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingAvatarPreviewSheet = false
    private let avatars = (1...6).map { Avatar(name: "avatar_\($0)") }
    private let accesories = (1...4).map { Avatar(name: "acc_\($0)") }
    private var gridItemLayout = [GridItem(.fixed(150)), GridItem(.fixed(150))]

    var body: some View {
        VStack {
            ScrollView {
                Spacer().frame(height: 50)
                Text("Choose your avatar")
                    .foregroundColor(violetColor)
                    .font(.custom("Nunito-Bold", size: 34))
                Spacer().frame(height: 50)
                LazyVGrid(columns: gridItemLayout, spacing: 40) {
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
                LazyVGrid(columns: gridItemLayout, spacing: 40) {
                    ForEach(accesories.indices, id: \.self) { index in
                        AvatarView(avatar: accesories[index])
                    }
                }
            }
            selectButton.background(.clear)
        }
    }
    
    var selectButton: some View {
        Button(action: {
            showingAvatarPreviewSheet.toggle()
        }) {
            Text("Select")
                .font(.system(.title2))
                .padding(.horizontal, 10.0)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
        }.sheet(isPresented: $showingAvatarPreviewSheet) {
            AvatarPreviewView()
        }
        .buttonBorderShape(.roundedRectangle(radius: 10))
        .background(primaryColor)
        .cornerRadius(10)
        .padding(.horizontal, 20.0)
    }
}

struct AvatarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarSelectionView()
    }
}
