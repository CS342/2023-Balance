//
//  ImageCollectionView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI

struct ImageCollectionView: View {
    var images = [Photo]()
    var category: Category
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
                                ImageView(imagesArray: images, currentIndex: index, selected: images[index], selectedCategory: category)
                            }
                        )
                    ) {
                        if images[index].imageData.isEmpty {
                            Image(images[index].name)
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .frame(width: 110, height: 110, alignment: .center)
                                .cornerRadius(10)
                                .accessibility(hidden: true)
                        } else {
                            if let uiImage = UIImage(data: images[index].imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .frame(width: 110, height: 110, alignment: .center)
                                    .cornerRadius(10)
                                    .accessibility(hidden: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    init(imageArray: [Photo], category: Category) {
        self.images = imageArray
        self.category = category
    }
}

struct ImageCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCollectionView(imageArray: (1...8).map { Photo(category: [Category(id: 5, name: "Landscape")], name: "img\($0)") }, category: Category(id: 0, name: "Removed"))
    }
}
