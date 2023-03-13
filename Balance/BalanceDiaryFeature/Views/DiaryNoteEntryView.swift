//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI

struct DiaryNoteEntryView: View {
    @ObservedObject var store: NoteStore
    @Binding var currentNote: Note
    @Binding var showingEditor: Bool
    
    @State private var title = ""
    @State private var text: String = ""

    @State private var id = UUID().uuidString

    @State private var savedNotes: [Note] = []
    @State private var burningNote = false
    @State private var burnComplete = false
    @State private var emptyNoteAlert = false
    
    let fcolor = Color(red: 0.25, green: 0.38, blue: 0.50, opacity: 1.00)
    let bcolor = Color(red: 0.30, green: 0.79, blue: 0.94, opacity: 1.00)
    
    // swiftlint:disable closure_body_length
    var body: some View {
        ZStack {
            VStack {
                TextField("Note Title", text: $title)
                    .font(.custom("Nunito-Bold", size: 18))
                    .padding()
                
                TextEditor(text: $text)
                    .font(.custom("Nunito", size: 16))
                    .border(.black.opacity(0.2), width: 1)
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
                    }.font(.custom("Nunito-Bold", size: 17))
                        .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
                        .foregroundColor(.white)
                        .background(bcolor)
                        .cornerRadius(14)
                        .alert("Please enter a text before you save.", isPresented: $emptyNoteAlert) {
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
                    .font(.custom("Nunito-Bold", size: 17))
                        .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
                        .foregroundColor(bcolor)
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(bcolor, lineWidth: 1)
                                )
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

struct DiaryNoteEntryView_Previews: PreviewProvider {
    @State static var currentNote = Note(id: UUID().uuidString, title: "Sample Note", text: "Test", date: Date())

    static var previews: some View {
        let store = NoteStore()
        DiaryNoteEntryView(
            store: store,
            currentNote: $currentNote,
            showingEditor: .constant(false)
        )
    }
}
