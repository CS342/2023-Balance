//
//  ImageView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 12/04/2023.
//

import SwiftUI

struct ImageView: View {
    @Environment(\.presentationMode) var presentationMode
    var image: String
    
    var body: some View {
        ActivityLogContainer {
            HeaderMenu(title: "Distraction")
            Spacer()
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
                Spacer().frame(height: 50)
                actionsButtons
            }
            Spacer()
        }.background(backgroudColor)
    }
    
    var actionsButtons: some View {
        HStack(spacing: 50) {
            Button(action: {
                print("Dislike!")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image("crossImage")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.50), radius: 3, x: 0, y: 2)
                    .accessibilityLabel("crossImage")
            }
            Button(action: {
                print("Like!")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image("heartImage")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.50), radius: 3, x: 0, y: 2)
                    .accessibilityLabel("heartImage")
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(image: "img1")
    }
}
