//
//  ImageView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 12/04/2023.
//

import SwiftUI

struct ImageView: View {
    @Environment(\.dismiss) var dismiss
    var imagesArray: [Photo]
    @State var currentIndex = 0
    @State var selected = Photo(name: "")

    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Distraction")
                    Spacer()
                    TabView(selection: $selected) {
                        ForEach(self.imagesArray) { img in
                            CardImageView(image: img.name)
                                .tag(img)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onAppear(perform: {
                        self.selected = self.imagesArray[currentIndex]
                    })
                    Spacer()
                    actionsButtons
                    Spacer()
                }
            }
        }
    }
    
    var actionsButtons: some View {
        HStack(spacing: 50) {
            dislikeAction
            likeAction
        }
    }
    
    var dislikeAction: some View {
        Button(action: {
            print("DISLIKE tab = \(selected.name)")
            selected.review = "DISLIKE"
            ImageReviewRepository.shared.createPhoto(photo: selected) { photo, error in
                if let error = error {
                    print("Error while fetching photo: \(error)")
                    return
                } else {
                    print("Saved photo: \(String(describing: photo))")
                    if currentIndex < self.imagesArray.count - 1 {
                        self.currentIndex += 1
                        self.selected = self.imagesArray[currentIndex]
                    } else {
                        self.currentIndex = 0
                        self.selected = self.imagesArray[currentIndex]
                    }                }
            }
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
    }
    
    var likeAction: some View {
        Button(action: {
            print("LIKE tab = \(selected.name)")
            selected.review = "LIKE"
            ImageReviewRepository.shared.createPhoto(photo: selected) { photo, error in
                if let error = error {
                    print("Error while fetching photo: \(error)")
                    return
                } else {
                    print("Saved photo: \(String(describing: photo))")
                    if currentIndex < self.imagesArray.count - 1 {
                        self.currentIndex += 1
                        self.selected = self.imagesArray[currentIndex]
                    } else {
                        self.currentIndex = 0
                        self.selected = self.imagesArray[currentIndex]
                    }
                }
            }
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

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imagesArray: [Photo(id: UUID(), name: "img1")])
    }
}
