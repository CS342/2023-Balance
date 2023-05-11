//
//  BackgroundDrawView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 24/04/2023.
//

import SwiftUI

struct BackgroundDrawView: View {
    @Binding var currentDraw: Draw
    @State private var animalsTag = true
    @State private var landscapeTag = false
    @State private var funnyTag = false
    @State var index = 0
    
    let highlightsImages = (1...11).map { Photo(name: "mandala\($0)") }

    let imgArray2 = (1...20).map { Photo(name: "coffee-\($0)") }
    let imgArray1 = (1...11).map { Photo(name: "mandala\($0)") }
    let imgArray3 = (1...8).map { Photo(name: "img\($0)") }

    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroudColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Draw Something")
                    VStack(alignment: .center, spacing: 10) {
                        highlightsTitle
                        PagingView(index: $index.animation(), maxIndex: highlightsImages.count - 1) {
                            ForEach(highlightsImages.indices, id: \.self) { index in
                                Image(highlightsImages[index].name)
                                    .resizable()
                                    .scaledToFill()
                                    .accessibilityLabel(imgArray1[index].name)
                            }
                        }
                        .aspectRatio(4 / 3, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        PageControl(index: $index, maxIndex: highlightsImages.count)
                            .padding(.top, 5.0)
                        categoriesTitle
                        tagsView
                        if animalsTag {
                            MandalaCollectionView(currentDraw: $currentDraw, images: imgArray1)
                                .padding(.horizontal, 10.0)
                        } else if landscapeTag {
                            MandalaCollectionView(currentDraw: $currentDraw, images: imgArray2)
                                .padding(.horizontal, 10.0)
                        } else if funnyTag {
                            MandalaCollectionView(currentDraw: $currentDraw, images: imgArray1)
                                .padding(.horizontal, 10.0)
                        }
                        Spacer()
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        }
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
struct BackgroundDrawView_Previews: PreviewProvider {
    @State static var currentDraw = Draw(id: UUID().uuidString, title: "Sample draw", image: Data(), date: Date(), backImage: "mandala1")
    
    static var previews: some View {
        BackgroundDrawView(
            currentDraw: $currentDraw
        )
    }
}
#endif
