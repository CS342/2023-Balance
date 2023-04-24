//
//  MandalaCollectionView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 24/04/2023.
//

import SwiftUI

struct MandalaCollectionView: View {
    @Binding var currentDraw: Draw
    @ObservedObject var store: DrawStore
    @State var images = [Photo]()
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
                                DrawView(store: store, currentDraw: $currentDraw, backgroundImage: images[index].name)
//                                ImageView(image: images[index].name)
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
    
//    init(imageArray: [Photo]) {
//        self.images = imageArray
//    }
}

#if DEBUG
struct MandalaCollectionView_Previews: PreviewProvider {
    @State static var currentDraw = Draw(id: UUID().uuidString, title: "Sample draw", image: Data(), date: Date(), backImage: "mandala1")
    
    static var previews: some View {
        let store = DrawStore()
        
        MandalaCollectionView(
            currentDraw: $currentDraw,
            store: store,
            images: (1...11).map {
                Photo(name: "mandala\($0)")
            }
        )
    }
}
#endif
