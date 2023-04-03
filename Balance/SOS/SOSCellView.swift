//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct SOSCellView: View {
    @State var isChecked = false
    var title: String
    var subtitle: String
    
    let fcolor = Color(red: 0.25, green: 0.38, blue: 0.50, opacity: 1.00)
    let bcolor = Color(red: 0.30, green: 0.79, blue: 0.94, opacity: 0.05)
    
    var body: some View {
        HStack {
            Button(action: toggle) {
                HStack(alignment: .top, spacing: 10) {
                    VStack {
                        Spacer()
                        Image(systemName: isChecked ? "checkmark.square" : "square")
                        Spacer()
                    }
                    VStack {
                        Text(title)
                            .font(.custom("Nunito-Bold", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.indigo)

                        Text(subtitle)
                            .font(.custom("Nunito-Light", size: 14))
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 0))
        .frame(maxWidth: 311, maxHeight: 114)
        .foregroundColor(fcolor)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .clipped()
        .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
    }
    
    func toggle() {
        isChecked.toggle()
    }
}

struct SOSCellViewPreview: PreviewProvider {
    static var previews: some View {
        SOSCellView(title: "Body sensations", subtitle: "lrem ipsum dolor sit amet consecte tuer adipiscing...")
    }
}
