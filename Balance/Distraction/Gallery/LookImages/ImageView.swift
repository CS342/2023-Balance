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
    @State var selected: Photo
    @State var profile = ProfileUser()
    @State var savedArray = [Photo]()

    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Distraction")
                    Spacer()
                    TabView(selection: $selected) {
                        ForEach(self.imagesArray) { img in
                            CardImageView(image: img.name, imageData: img.imageData)
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
            }.onAppear {
                loadUser()
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
            savedArray = UserImageCache.load(key: self.profile.id.appending("RemovedArray"))
            let result = savedArray.filter { $0.id == selected.id }
            if result.isEmpty {
                savedArray.append(selected)
                UserImageCache.save(savedArray, key: self.profile.id.appending("RemovedArray"))
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
        }.buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.id + "status: REMOVED"))
    }
    
    var likeAction: some View {
        Button(action: {
            print("LIKE tab = \(selected.name)")
            savedArray = UserImageCache.load(key: self.profile.id.appending("FavoritesArray"))
            let result = savedArray.filter { $0.id == selected.id }
            if result.isEmpty {
                savedArray.append(selected)
                UserImageCache.save(savedArray, key: self.profile.id.appending("FavoritesArray"))
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
        }.buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.name + " status: FAVORITE"))
    }
    
    func loadUser() {
        UserProfileRepositoryToLocal.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profileUser?.description() ?? "-"))
                self.profile = profileUser ?? ProfileUser()
            }
        }
    }
}
