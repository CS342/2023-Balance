//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import CardinalKit

struct DiaryNoteEntryView: View {
    @ObservedObject var store: NoteStore
    @Binding var currentNote: Note
    @Binding var showingEditor: Bool

    @State private var id = UUID().uuidString
    @State private var title = ""
    @State private var text = ""

    @State private var savedNotes: [Note] = []
    @State private var burningNote = false
    @State private var burnComplete = false
    @State private var emptyNoteAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                TextField("Note Title", text: $title)
                    .padding()
                
                TextEditor(text: $text)
                    .border(.black, width: 1)
                    .padding()
                
                HStack(spacing: 100) {
                    Button("Save") {
                        if text.isEmpty {
                            self.emptyNoteAlert = true
                        }

                        let newNote = Note(
                            id: currentNote.id,
                            title: title,
                            text: text,
                            date: Date()
                        )

                        store.saveNote(newNote)
                        
                        NoteStore.save(notes: store.notes) { result in
                            if case .failure(let error) = result {
                                print(error.localizedDescription)
                            }
                        }

                        self.showingEditor.toggle()
                    }.buttonStyle(.borderedProminent)
                        .alert("Please enter a text before you save.", isPresented: $emptyNoteAlert){
                            Button("OK", role: .cancel) { }
                        }
                    
                    Button("Burn") {
                        store.deleteNote(currentNote.id)

                        NoteStore.save(notes: store.notes) { result in
                            if case .failure(let error) = result {
                                print(error.localizedDescription)
                            }
                        }

                        burningNote.toggle()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()

                List(savedNotes, id: \.title) { note in
                    VStack(alignment: .leading) {
                        Text(note.title)
                            .font(.headline)
                        Text(note.text)
                    }
                }
            }.onAppear {
                self.title = currentNote.title
                self.text = currentNote.text
                self.id = currentNote.id
            }

            if burningNote {
                BurnedView(
                    burningNote: $burningNote,
                    showingEditor: $showingEditor
                )
            }
        }
    }

}

//struct DiaryNoteEntryView_Previews: PreviewProvider {
//    @State var currentNote = Note(id: UUID().uuidString, title: "Sample Note", text: "Test", date: Date())
//
//    static var previews: some View {
//        let store = NoteStore()
//        DiaryNoteEntryView(
//            store: store,
//            currentNote: $currentNote,
//            showingEditor: .constant(false)
//        )
//    }
//}

