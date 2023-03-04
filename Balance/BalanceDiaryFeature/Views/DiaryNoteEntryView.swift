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
    @State private var text: String = "This is some editable text..."

    @State private var savedNotes: [Note] = []
    @State private var burningNote = false
    @State private var burnComplete = false
    
    var body: some View {
        ZStack {
            VStack {
                TextField("Note Title", text: $title)
                    .padding()
                
                TextEditor(text: $text)
                    .foregroundColor(self.text == "This is some editable text..." ? .gray : .primary)
                //TextEditor doesn't allow placeholder text so found this patch online
                    .onTapGesture {
                        if (self.text == "This is some editable text...") {
                            self.text = ""
                        }
                        burnComplete.toggle()
                    }
                    .padding()
                
                HStack(spacing: 100) {
                    Button("Save") {
                        let note = Note(
                            id: currentNote.id,
                            title: title,
                            text: text,
                            date: Date()
                        )

                        let indexOfNote = store.notes.firstIndex { note in
                            return note.id == currentNote.id
                        }

                        if let indexOfNote {
                            store.notes[indexOfNote] = note
                        } else {
                            store.notes.append(note)
                        }
                        
                        NoteStore.save(notes: store.notes) { result in
                            if case .failure(let error) = result {
                                print(error.localizedDescription)
                            }
                        }

                        self.showingEditor.toggle()
                    }.buttonStyle(.borderedProminent)
                    
                    Button("Burn") {
                        let indexOfNote = store.notes.firstIndex { note in
                            return note.id == currentNote.id
                        }

                        if let indexOfNote {
                            store.notes.remove(at: indexOfNote)
                        }
                        
                        burningNote.toggle()
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
            }.onAppear {
                self.title = currentNote.title
                self.text = currentNote.text
                self.id = currentNote.id
            }

            if burningNote {
                BurnedView(
                    burningNote: $burningNote,
                    text: $text,
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
//        DiaryNoteEntryView(store: store, currentNote: $currentNote, showingEditor: .constant(false))
//    }
//}

