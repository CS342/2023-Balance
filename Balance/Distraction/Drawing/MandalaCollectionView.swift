//
//  MandalaCollectionView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 24/04/2023.
//

import SwiftUI

struct MandalaCollectionView: View {
    @Binding var currentDraw: Draw
    @Binding var images: [Mandala]
    var gridItemLayout = [GridItem(.fixed(110)), GridItem(.fixed(110)), GridItem(.fixed(110))]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridItemLayout, alignment: .center, spacing: 10) {
                ForEach(images.indices, id: \.self) { index in
                    NavigationLink(
                        destination: ActivityLogBaseView(
                            viewName: "Mandala Selected: " + images[index].name,
                            isDirectChildToContainer: true,
                            content: {
                                DrawSketch(draw: currentDraw)
                                // DrawView(currentDraw: $currentDraw, isNewDraw: true, isColoring: true)
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
                    }.simultaneousGesture(TapGesture().onEnded {
                        self.currentDraw.backImage = images[index].name
                    })
                }
            }
        }
    }
}
