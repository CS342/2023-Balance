//
//  ImageCollectionView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI

struct ImageCollectionView: View {
    var symbols = [String]()
    var gridItemLayout = [GridItem(.fixed(110)), GridItem(.fixed(110)), GridItem(.fixed(110))]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridItemLayout, alignment: .center, spacing: 10) {
                ForEach((0...30), id: \.self) {
                    Image(symbols[$0 % symbols.count])
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(minWidth: 0, maxWidth: 110, minHeight: 0, maxHeight: 110)
                        .cornerRadius(10)
                        .accessibilityLabel(symbols[$0 % symbols.count])
                }
            }
        }
    }
    
    init(imageArray: [String]) {
        self.symbols = imageArray
    }
}

struct ImageCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCollectionView(imageArray: ["img1", "img2", "img3", "img4", "img5", "img6", "img7", "img8"])
    }
}
