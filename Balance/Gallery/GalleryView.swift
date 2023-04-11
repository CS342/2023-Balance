//
//  GalleryView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI

struct GalleryView: View {
    @State private var animalsTag = true
    @State private var landscapeTag = false
    @State private var funnyTag = false
    
    let imageIDArray = ["118299", "100489", "130869", "115905", "115512", "131807", "102595"]
    let animalsArray = ["img1", "img2", "img3", "img4", "img5", "img6", "img7", "img8"]
    
    var body: some View {
        HeaderMenu(title: "Look at Pictures")
        VStack(alignment: .center, spacing: 10) {
            highlightsTitle
            ScrollView(.horizontal) {
                HStack {
                    imagesArrayView
                }
            }
            categoriesTitle
            tagsView
            if animalsTag {
                ImageCollectionView(imageArray: animalsArray)
                    .padding(.horizontal, 10.0)
            } else if landscapeTag {
                YoutubeView()
                    .padding(.horizontal, 10.0)
            } else if funnyTag {
                SleepView()
                    .padding(.horizontal, 10.0)
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
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
            // enable logging for a specific video being selected
            ImgHighlightView(imgID: imgID)
                .frame(width: 300, height: 200)
//                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
                .cornerRadius(20)
        }
    }
    
    var tagsView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                animalsButton
                landscapeButton
                funnyButton
            }
        }
        .padding(.leading, 10)
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
