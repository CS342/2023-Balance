//
//  PastDrawEntry.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/04/2023.
//

import PencilKit
import SwiftUI

struct PastColoringEntryView: View {
    private var draw: Draw
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(draw.date.timeSinceDate(fromDate: Date()))
                    .font(.custom("Nunito-Bold", size: 11))
                    .foregroundColor(.gray)
                Spacer().frame(height: 10)
                loadImages
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(darkBlueColor)
                .accessibility(hidden: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background()
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    
    var loadImages: some View {
        HStack {
            let image = UIImage(data: draw.image)
            if image == nil {
                let drawing = try? PKDrawing(data: draw.image)
                let imageDraw = drawing?.image(from: .init(x: 0, y: 0, width: 350, height: 350), scale: 1)
                ZStack {
                    Image(draw.backImage)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width: 80, height: 80)
                        .accessibilityLabel("backString")
                        .zIndex(0)
                    
                    Image(uiImage: imageDraw ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .background(.clear)
                        .frame(width: 80, height: 80)
                        .accessibilityLabel("base64Cell")
                        .zIndex(1)
                }
            } else {
                Image(uiImage: image ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .background(.clear)
                    .frame(width: 80, height: 80)
                    .accessibilityLabel("base64Cell")
                    .zIndex(1)
            }
            Spacer().frame(width: 20)
            Text(draw.title)
                .font(.custom("Nunito-Black", size: 18))
                .foregroundColor(darkBlueColor)
        }
    }
    
    init(_ draw: Draw) {
        self.draw = draw
    }
}
