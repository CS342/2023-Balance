//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

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
                saveView
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                notesList
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
    
    var notesList: some View {
        List(savedNotes, id: \.title) { note in
            VStack(alignment: .leading) {
                Text(note.title)
                    .font(.headline)
                Text(note.text)
            }
        }
    }
    
    var saveView: some View {
        HStack(spacing: 100) {
            buttonSave
                .buttonStyle(ActivityLogButtonStyle(activityDescription: "Saved a Diary Note"))
                .font(.custom("Nunito-Bold", size: 17))
                .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
                .foregroundColor(.white)
                .background(primaryColor)
                .cornerRadius(14)
                .alert("Please enter a text before you save.", isPresented: $emptyNoteAlert) {
                    Button("OK", role: .cancel) { }
                }
            burnButton
                .buttonStyle(ActivityLogButtonStyle(activityDescription: "Burned Diary Note"))
                .font(.custom("Nunito-Bold", size: 17))
                .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
                .foregroundColor(darkBlueColor)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(darkBlueColor, lineWidth: 1)
                )
        }
    }
    
    var buttonSave: some View {
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
        }
    }
    
    var burnButton: some View {
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
