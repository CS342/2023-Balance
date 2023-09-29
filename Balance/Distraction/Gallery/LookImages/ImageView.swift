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

struct ImageView: View {
    @Environment(\.dismiss)
    var dismiss
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
    @State var tapRemove = false
    @State var tapUnLike = false
    @State var tapReturn = false
    @State var tapLike = false
    @State var tapDislike = false
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Look at Images")
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
                if !selected.imageData.isEmpty {
                    deleteAction
                } else {
                    dislikeAction
                }
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
            
            removeFrom(type: "FavoritesArray", name: selected.name)
            removeFrom(type: "RemovedArray", name: selected.name)
            removeFrom(type: "UploadedArray", name: selected.name)
            
            tapRemove = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tapRemove = false
            }
        }) {
            Image(systemName: "trash.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(primaryColor)
                .padding(10)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.50), radius: 3, x: 0, y: 2)
                .accessibility(hidden: true)
                .scaleEffect(scaleValue)
                .tint(primaryColor)
                .scaleEffect(tapRemove ? 1.2 : 1)
                .animation(.spring(), value: tapRemove)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.name + " status: DELETE"))
    }
    
    var dislikeAction: some View {
        Button(action: {
            print("DISLIKE tab = \(selected.name)")
            showingHUD.toggle()
            self.strMsg = "Removed!"
            self.imgMsg = "xmark.circle.fill"
            removeFrom(type: "FavoritesArray", name: selected.name)
            appendFrom(type: "RemovedArray", photo: selected)
            tapDislike = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tapDislike = false
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
                .accessibility(hidden: true)
                .scaleEffect(tapDislike ? 1.2 : 1)
                .animation(.spring(), value: tapDislike)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.name + " status: REMOVED"))
    }
    
    var likeAction: some View {
        Button(action: {
            print("LIKE tab = \(selected.name)")
            showingHUD.toggle()
            self.strMsg = "Added!"
            self.imgMsg = "heart.fill"
            appendFrom(type: "FavoritesArray", photo: selected)
            tapLike = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tapLike = false
            }
        }) {
            Image("heart3")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.50), radius: 3, x: 0, y: 2)
                .accessibility(hidden: true)
                .scaleEffect(tapLike ? 1.2 : 1)
                .animation(.spring(), value: tapLike)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.name + " status: FAVORITE"))
    }
    
    var unLikeAction: some View {
        Button(action: {
            print("UNLIKE tab = \(selected.name)")
            showingHUD.toggle()
            self.strMsg = "Removed from favorites!"
            self.imgMsg = "heart.slash.fill"
            removeFrom(type: "FavoritesArray", name: selected.name)
            tapUnLike = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tapUnLike = false
            }
        }) {
            Image(systemName: "heart.slash.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(primaryColor)
                .padding(10)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.50), radius: 3, x: 0, y: 2)
                .accessibility(hidden: true)
                .scaleEffect(scaleValue)
                .tint(primaryColor)
                .scaleEffect(tapUnLike ? 1.2 : 1)
                .animation(.spring(), value: tapUnLike)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "IMAGE REVIEW: " + selected.name + " status: UNLIKE"))
    }
    
    var returnAction: some View {
        Button(action: {
            print("RETURN tab = \(selected.name)")
            showingHUD.toggle()
            self.strMsg = "Return to list!"
            self.imgMsg = "arrowshape.turn.up.backward.circle.fill"
            removeFrom(type: "RemovedArray", name: selected.name)
            tapReturn = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tapReturn = false
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
                .accessibility(hidden: true)
                .scaleEffect(scaleValue)
                .tint(primaryColor)
                .scaleEffect(tapReturn ? 1.2 : 1)
                .animation(.spring(), value: tapReturn)
        }
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
    
    func removeFrom(type: String, name: String) {
        savedArray = UserImageCache.load(key: self.profile.id.appending(type))
        let result = savedArray.filter { $0.name != name }
        UserImageCache.save(result, key: self.profile.id.appending(type))
    }
    
    func appendFrom(type: String, photo: Photo) {
        savedArray = UserImageCache.load(key: self.profile.id.appending(type))
        var result = savedArray.filter { $0.name != photo.name }
        result.append(photo)
        UserImageCache.save(result, key: self.profile.id.appending(type))
    }
}
