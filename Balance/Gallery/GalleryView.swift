//
//  GalleryView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI

struct Photo: Identifiable {
    var id = UUID()
    var name: String
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
            HeaderMenu(title: "Look at Pictures")
            VStack(alignment: .center, spacing: 10) {
                highlightsTitle
                PagingView(index: $index.animation(), maxIndex: imgArray1.count - 1) {
                    ForEach(imgArray1.indices, id: \.self) { index in
                        Image(imgArray1[index].name)
                            .resizable()
                            .scaledToFill()
                            .accessibilityLabel(imgArray1[index].name)
                    }
                }
                .aspectRatio(4 / 3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                PageControl(index: $index, maxIndex: imgArray1.count)
                    .padding(.top, 5.0)
                categoriesTitle
                tagsView
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
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
        }.background(backgoudColor)
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
            // enable logging for a specific image being selected
            ImgHighlightView(imgID: imgID)
                .frame(width: UIScreen.main.bounds.width, height: 200)
                .cornerRadius(20)
        }
    }
    
    var tagsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer(minLength: 10)
                animalsButton
                landscapeButton
                funnyButton
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
