//
// This source file is part of the CS342 2023 Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import CardinalKit

struct DiaryNoteEntryView: View {
    @ObservedObject var vm: DiaryFeatureViewModel
    @State private var title = ""
    @State private var text: String = "This is some editable text..."
    @State private var savedNotes: [Note] = []
    
    var body: some View {
        VStack {
            TextField("Note Title", text: $title)
                .padding()
            
            TextEditor(text: $text)
                .foregroundColor(self.text == "This is some editable text..." ? .gray : .primary)
//TextEditor doesn't allow placeholder text so found this patch online
                .onTapGesture {
                    if self.text == "This is some editable text..." {
                        self.text = ""
                    }
                }
                .padding()
            
            HStack(spacing: 100) {
                Button("Save") {
                    let note = Note(
                        id: UUID().uuidString,
                        title: title,
                        text: text,
                        date: Date()
                    )
                    vm.notes.append(note)
                    title = ""
                    text = ""
                }.buttonStyle(.borderedProminent)

                Button("Burn") {
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
 // found online how to get notes saved right below
            List(savedNotes, id: \.title) { note in
                VStack(alignment: .leading) {
                    Text(note.title)
                        .font(.headline)
                    Text(note.text)
                }
            }
        }
    }
}

struct DiaryNoteEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DiaryFeatureViewModel()

        DiaryNoteEntryView(vm: vm)
    }
}

