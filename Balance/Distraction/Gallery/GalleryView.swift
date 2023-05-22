//
//  GalleryView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI

struct Photo: Codable, Equatable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var review = ""
}

struct GalleryView: View {
    @State private var animalsTag = true
    @State private var landscapeTag = false
    @State private var funnyTag = false
    @State var index = 0
    
    let imageIDArray = ["118299", "100489", "130869", "115905", "115512", "131807", "102595"]
    let imgArray2 = (1...20).map { Photo(name: "coffee-\($0)") }
    let imgArray1 = (1...8).map { Photo(name: "img\($0)") }
    
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
            ForEach(Array(imgArray1.enumerated()), id: \.element) { index, img in
                NavigationLink(
                    destination: ActivityLogBaseView(
                        viewName: "Image Selected: " + img.name,
                        isDirectChildToContainer: true,
                        content: {
                            ImageView(imagesArray: imgArray1, currentIndex: index)
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
    
    var imagesArrayView: some View {
        ForEach(imageIDArray, id: \.self) { imgID in
            ImgHighlightView(imgID: imgID)
                .frame(width: UIScreen.main.bounds.width, height: 200)
                .cornerRadius(20)
        }
    }
    
    var tagsView: some View {
        Group {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer(minLength: 10)
                    animalsButton
                    landscapeButton
                    funnyButton
                }
            }
            if animalsTag {
                ImageCollectionView(imageArray: imgArray1)
                    .padding(.horizontal, 10.0)
            } else if landscapeTag {
                ImageCollectionView(imageArray: imgArray2)
                    .padding(.horizontal, 10.0)
            } else if funnyTag {
                ImageCollectionView(imageArray: imgArray1)
                    .padding(.horizontal, 10.0)
            }
        }
    }
    
    var animalsButton: some View {
        Button(action: {
            animalsTag = true
            landscapeTag = false
            funnyTag = false
        }) {
            Text("Animals")
                .font(.custom("Nunito", size: 18))
                .frame(width: 120, height: 30)
                .foregroundColor(.white)
                .background(self.animalsTag ? violetColor : lightVioletColor)
                .cornerRadius(20)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Viewing Animals"))
    }
    
    var landscapeButton: some View {
        Button(action: {
            animalsTag = false
            landscapeTag = true
            funnyTag = false
        }) {
            Text("Landscape")
                .font(.custom("Nunito", size: 18))
                .frame(width: 120, height: 30)
                .foregroundColor(.white)
                .background(self.landscapeTag ? violetColor : lightVioletColor)
                .cornerRadius(20)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Viewing Landscape"))
    }
    
    var funnyButton: some View {
        Button(action: {
            animalsTag = false
            landscapeTag = false
            funnyTag = true
        }) {
            Text("Funny Images")
                .font(.custom("Nunito", size: 18))
                .frame(width: 120, height: 30)
                .foregroundColor(.white)
                .background(self.funnyTag ? violetColor : lightVioletColor)
                .cornerRadius(20)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Viewing Funny Images"))
    }
}

#if DEBUG
struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
#endif
