//
//  PastDrawEntry.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/04/2023.
//

import PencilKit
import SwiftUI

struct PastDrawEntry: View {
    private var draw: Draw
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(draw.date.timeSinceDate(fromDate: Date()))
                    .font(.custom("Nunito-Bold", size: 11))
                    .foregroundColor(.gray)
                Spacer().frame(height: 10)
                HStack {
                    let drawing = try? PKDrawing(data: draw.image)
                    let image = drawing?.image(from: .init(x: 0, y: 0, width: 350, height: 350), scale: 1)

                    ZStack {
                        Image(draw.backImage)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                            .frame(width: 80, height: 80)
                            .accessibilityLabel("backString")
                            .zIndex(0)
                        
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
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(darkBlueColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background()
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    
    init(_ draw: Draw) {
        self.draw = draw
    }
}

struct PastDrawEntry_Previews: PreviewProvider {
    static var previews: some View {
        PastDrawEntry(Draw(id: "1234", title: "Title", image: Data(), date: Date().previousDate(), backImage: "mandala1"))
    }
}
