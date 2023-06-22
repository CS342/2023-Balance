//
//  GalleryView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI

struct ImageTagView: View {
    var selectedCategory: Category
    @Binding var selectedBtn: Int
    @Binding var filteredCat: [Photo]
    @State var profile = ProfileUser()
    
    var body: some View {
        Button(action: {
            self.selectedBtn = self.selectedCategory.id
            filteredCat.removeAll()
            if self.selectedCategory.name == "Favorites" {
                filteredCat = UserImageCache.load(key: self.profile.id.appending("FavoritesArray"))
            } else if self.selectedCategory.name == "Removed" {
                filteredCat = UserImageCache.load(key: self.profile.id.appending("RemovedArray"))
            } else {
                for photo in photoArray {
                    for category in photo.category where category.name == self.selectedCategory.name {
                        filteredCat.append(photo)
                    }
                }
            }
        }) {
            Text(selectedCategory.name)
                .font(.custom("Nunito", size: 18))
                .foregroundColor(.white)
                .padding(20)
        }
        .frame(height: 30)
        .background(self.selectedBtn == self.selectedCategory.id ? violetColor : lightVioletColor)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(5)
        .onAppear {
            loadUser()
        }
    }
    
    func loadUser() {
        UserProfileRepositoryToLocal.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                self.profile = profileUser ?? ProfileUser()
            }
        }
    }
}

struct GalleryView: View {
    @State var index = 0
    @State var selectedCategory = imageCategoryArray[0]
    @State var filtered = photoArray
    @State var selected = 0
    
    let highlightArray = photoArray.filter { $0.highlight == true }
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Look at Pictures")
                    VStack(alignment: .center, spacing: 10) {
                        highlightsTitle
                        imagePaging
                        categoriesTitle
                        tagsView
                        Spacer()
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
    
    var imagePaging: some View {
        TabView {
            ForEach(Array(highlightArray.enumerated()), id: \.element) { index, img in
                NavigationLink(
                    destination: ActivityLogBaseView(
                        viewName: "Image Highlight Selected: " + img.name,
                        isDirectChildToContainer: true,
                        content: {
                            ImageView(imagesArray: highlightArray, currentIndex: index, selected: highlightArray[index])
                        }
                    )
                ) {
                    Image(img.name)
                        .resizable()
                        .cornerRadius(20)
                        .aspectRatio(contentMode: .fit)
                        .padding(5)
                        .accessibilityLabel(img.name)
                        .tag(img)
                }
            }
        }.tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    var highlightsTitle: some View {
        Text("Highlights").font(.custom("Nunito-Bold", size: 25))
            .foregroundColor(violetColor)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
    }
    
    var categoriesTitle: some View {
        Text("Categories").font(.custom("Nunito-Bold", size: 20))
            .foregroundColor(violetColor)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
    }
    
    var tagsView: some View {
        Group {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer(minLength: 10)
                    ForEach(imageCategoryArray, id: \.self) { cat in
                        ImageTagView(selectedCategory: cat, selectedBtn: self.$selected, filteredCat: self.$filtered)
                    }
                }
            }
            ImageCollectionView(imageArray: filtered).padding(.horizontal, 10.0)
        }
    }
}

#if DEBUG
struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
#endif
