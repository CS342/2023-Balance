//
// This source file is part of the CS342 2023 Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

public struct PastDiaryEntry: View {
    private let date: String
    private let title: String
    private let text: String
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(date)
                    .bold()
                
                Text(title)
                    .font(.title.bold())
                Text(text)
                    .font(.title3)
                    .foregroundColor(.gray)
                    . lineLimit(3)
            }
            Image(systemName: "chevron.right")
                .offset(x: 140)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .frame(width: 350)
        .background()
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 5)
    }
    
    public init(date: String, title: String, text: String) {
        self.date = date
        self.title = title
        self.text = text
    }
}

struct PastDiaryEntry_Previews: PreviewProvider {
    static var previews: some View {
        PastDiaryEntry(
            date: String( "Date"),
            title: String("Note Name"),
            text: String("Note body text")
        )
    }
}
