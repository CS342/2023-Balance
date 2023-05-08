//
//  ImageCollectionView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI

struct ImageCollectionView: View {
    var images = [Photo]()
    var gridItemLayout = [GridItem(.fixed(110)), GridItem(.fixed(110)), GridItem(.fixed(110))]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridItemLayout, alignment: .center, spacing: 10) {
                ForEach(images.indices, id: \.self) { index in
                    NavigationLink(
                        destination: ActivityLogBaseView(
                            viewName: "Image Selected: " + images[index].name,
                            isDirectChildToContainer: true,
                            content: {
                                ImageView(image: images[index].name)
                            }
                        )
                    ) {
                        Image(images[index].name)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(width: 110, height: 110, alignment: .center)
                            .cornerRadius(10)
                            .accessibilityLabel(images[index].name)
                    }
                }
            }
        }
    }
    
    init(imageArray: [Photo]) {
        self.images = imageArray
    }
}

struct ImageCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCollectionView(imageArray: (1...8).map { Photo(name: "img\($0)") })
    }
}
