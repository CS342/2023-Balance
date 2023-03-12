//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

public struct PastDiaryEntry: View {
    private var note: Note
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(note.date.timeSinceDate(fromDate: Date()))
                    .font(.custom("Nunito-Bold", size: 11))
                    .foregroundColor(.gray)
                Text(note.title)
                    .font(.custom("Nunito-Black", size: 18))
                    .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
                Text(note.text)
                    .font(.custom("Nunito", size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            Image(systemName: "chevron.right")
                .offset(x: 140)
                .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .frame(width: 350)
        .background()
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 7)
    }

    public init(_ note: Note) {
        self.note = note
    }
}

struct PastDiaryEntry_Previews: PreviewProvider {
    static var previews: some View {
        PastDiaryEntry(Note(id: "1234", title: "Title", text: "Text", date: Date().previousDate()))
    }
}
