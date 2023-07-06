//
//  ImageView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 12/04/2023.
//

import SwiftUI

struct HUD<Content: View>: View {
  @ViewBuilder let content: Content

  var body: some View {
    content
      .padding(.horizontal, 12)
      .padding(16)
      .background(
        Capsule()
          .foregroundColor(Color.white)
          .shadow(color: Color(.black).opacity(0.16), radius: 12, x: 0, y: 5)
      )
  }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.4 : 1)
    }
}

// swiftlint:disable attributes
struct ImageView: View {
    @Environment(\.dismiss) var dismiss
    var imagesArray: [Photo]
    @State var currentIndex = 0
    @State var selected: Photo
    @State var profile = ProfileUser()
    @State var savedArray = [Photo]()
    @State private var scaleValue = CGFloat(1)
    @State private var showingHUD = false
    @State private var strMsg = ""
    @State private var imgMsg = ""
    @State var selectedCategory: Category
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Distraction")
                    Spacer()
                    tabImages
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .onAppear(perform: {
                            self.selected = self.imagesArray[currentIndex]
                        })
                    Spacer()
                    actionsButtons
                    Spacer()
                }
                if showingHUD {
                    HUD {
                        Label(strMsg, systemImage: imgMsg)
                    }
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showingHUD = false
                            }
                        }
                    }
                    .zIndex(1)
                }
            }.onAppear {
                loadUser()
            }
        }
    }
    
    var tabImages: some View {
        TabView(selection: $selected) {
            ForEach(self.imagesArray) { img in
                CardImageView(image: img.name, imageData: img.imageData)
                    .tag(img)
            }
        }
    }
    
    var actionsButtons: some View {
        HStack(spacing: 50) {
            if selectedCategory.name == "Removed" {
                returnAction
            } else if selectedCategory.name == "Favorites" {
                unLikeAction
            } else if selectedCategory.name == "Uploaded" {
                deleteAction
                likeAction
            } else {
                dislikeAction
                likeAction
            }
        }
    }
    
    var deleteAction: some View {
        Button(action: {
            print("DELETE tab = \(selected.name)")
            showingHUD.toggle()
            self.strMsg = "Deleted!"
            self.imgMsg = "trash.fill"
            savedArray = UserImageCache.load(key: self.profile.id.appending("UploadedArray"))
            let result = savedArray.filter { $0.name != selected.name }
            UserImageCache.save(result, key: self.profile.id.appending("UploadedArray"))
        }) {
            Image(systemName: "trash.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(primaryColor)
                .padding(10)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.50), radius: 3, x: 0, y: 2)
                .accessibilityLabel("trash.fill")
                .scaleEffect(scaleValue)
                .tint(primaryColor)
        }
        .buttonStyle(ScaleButtonStyle())
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.name + " status: DELETE"))
    }
    
    var dislikeAction: some View {
        Button(action: {
            print("DISLIKE tab = \(selected.name)")
            showingHUD.toggle()
            self.strMsg = "Removed!"
            self.imgMsg = "xmark.circle.fill"
            savedArray = UserImageCache.load(key: self.profile.id.appending("RemovedArray"))
            let result = savedArray.filter { $0.name == selected.name }
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
                .scaleEffect(scaleValue)
        }
        .buttonStyle(ScaleButtonStyle())
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.id + "status: REMOVED"))
    }
    
    var likeAction: some View {
        Button(action: {
            print("LIKE tab = \(selected.name)")
            showingHUD.toggle()
            self.strMsg = "Added!"
            self.imgMsg = "heart.fill"
            savedArray = UserImageCache.load(key: self.profile.id.appending("FavoritesArray"))
            let result = savedArray.filter { $0.name == selected.name }
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
                .scaleEffect(scaleValue)
        }
        .buttonStyle(ScaleButtonStyle())
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.name + " status: FAVORITE"))
    }
    
    var unLikeAction: some View {
        Button(action: {
            print("UNLIKE tab = \(selected.name)")
            showingHUD.toggle()
            self.strMsg = "Removed from favorites!"
            self.imgMsg = "heart.slash.fill"
            savedArray = UserImageCache.load(key: self.profile.id.appending("FavoritesArray"))
            let result = savedArray.filter { $0.name != selected.name }
            UserImageCache.save(result, key: self.profile.id.appending("FavoritesArray"))
        }) {
            Image(systemName: "heart.slash.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(primaryColor)
                .padding(10)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.50), radius: 3, x: 0, y: 2)
                .accessibilityLabel("heart.slash.fill")
                .scaleEffect(scaleValue)
                .tint(primaryColor)
        }
        .buttonStyle(ScaleButtonStyle())
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.name + " status: UNLIKE"))
    }
    
    var returnAction: some View {
        Button(action: {
            print("RETURN tab = \(selected.name)")
            showingHUD.toggle()
            self.strMsg = "Return to list!"
            self.imgMsg = "arrowshape.turn.up.backward.circle.fill"
            let removedArray = UserImageCache.load(key: self.profile.id.appending("RemovedArray"))
            let result = removedArray.filter { $0.name != selected.name }
            if !result.isEmpty {
                UserImageCache.save(result, key: self.profile.id.appending("RemovedArray"))
            }
        }) {
            Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(primaryColor)
                .padding(10)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.50), radius: 3, x: 0, y: 2)
                .accessibilityLabel("backImage")
                .scaleEffect(scaleValue)
                .tint(primaryColor)
        }
        .buttonStyle(ScaleButtonStyle())
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.name + " status: RETURN"))
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
