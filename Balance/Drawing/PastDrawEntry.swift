//
//  PastDrawEntry.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/04/2023.
//

import SwiftUI

struct PastDrawEntry: View {
    private var draw: Draw
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(draw.date.timeSinceDate(fromDate: Date()))
                    .font(.custom("Nunito-Bold", size: 11))
                    .foregroundColor(.gray)
                Text(draw.title)
                    .font(.custom("Nunito-Black", size: 18))
                    .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
//                Text(draw.image)
//                    .font(.custom("Nunito", size: 14))
//                    .foregroundColor(.gray)
//                    .lineLimit(3)
//                    .frame(maxWidth: 270, alignment: .leading)
            }
            Image(systemName: "chevron.right")
                .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
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
        PastDrawEntry(Draw(id: "1234", title: "Title", image:"", date: Date().previousDate()))
    }
}
