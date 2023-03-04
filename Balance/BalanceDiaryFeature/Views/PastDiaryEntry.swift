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
    @StateObject var store = NoteStore()
    //@State private var showingEditor = false
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(note.date.timeSinceDate(fromDate: Date()))
                    .bold()
                Text(note.title)
                    .font(.title.bold())
                Text(note.text)
                    .font(.title3)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            Image(systemName: "chevron.right")
                .offset(x: 140)
            
            Spacer()
            
//            Button("Edit") {
//                self.showingEditor.toggle()
//            }.buttonStyle(.borderedProminent)

            Spacer()
        }
//        .sheet(isPresented: $showingEditor) {
//                DiaryNoteEntryView(
//                    store: store,
//                    id: note.id,
//                    title: note.title,
//                    text: note.text,
//                    showingEditor: self.$showingEditor
//                )
//            }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .frame(width: 350)
        .background()
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 5)
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
