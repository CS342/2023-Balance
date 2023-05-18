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
        ActivityLogContainer {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(note.date.timeSinceDate(fromDate: Date()))
                        .font(.custom("Nunito-Bold", size: 11))
                        .foregroundColor(.gray)
                    Text(note.title)
                        .font(.custom("Nunito-Black", size: 18))
                        .foregroundColor(darkBlueColor)
                    Text(note.text)
                        .font(.custom("Nunito", size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .frame(maxWidth: 270, alignment: .leading)
                }
                Image(systemName: "chevron.right")
                    .foregroundColor(darkBlueColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5)
        }
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
