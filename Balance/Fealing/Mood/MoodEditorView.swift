//
//  MoodEditorView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/05/2023.
//

import SwiftUI

struct MoodEditorView: View {
    @Environment(\.dismiss)
    var dismiss
    @EnvironmentObject var store: NoteStore
    @Binding var currentNote: Note
    @State private var title = ""
    @State private var text: String = ""
    @State private var id = UUID().uuidString
    @State private var savedNotes: [Note] = []
    @State private var emptyNoteAlert = false
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Feeling learning")
                Spacer().frame(height: 20)
                titleText
                TextField("Note Title", text: $title)
                    .font(.custom("Nunito-Bold", size: 18))
                    .padding()
                TextEditor(text: $text)
                    .font(.custom("Nunito", size: 16))
                    .border(.black.opacity(0.2), width: 1)
                    .padding()
                saveButton
            }.onAppear {
                self.title = currentNote.title
                self.text = currentNote.text
                self.id = currentNote.id
            }
        }
    }
    
    var titleText: some View {
        Text("Write below how you feel, describe your emotion")
            .font(.custom("Nunito-Bold", size: 25))
            .foregroundColor(violetColor)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 30.0)
            .background(.clear)
    }
    
    var saveButton: some View {
        Button(action: {
            if text.isEmpty {
                self.emptyNoteAlert = true
                return
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
                } else {
                    dismiss()
                }
            }
        }) {
            Text("Save in Diary")
                .font(.custom("Montserrat-SemiBold", size: 17))
                .padding(.horizontal, 10.0)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
        }
        .buttonBorderShape(.roundedRectangle(radius: 10))
        .background(primaryColor)
        .cornerRadius(10)
        .padding(.all, 20.0)
    }
    
    var saveView: some View {
        buttonSave
            .buttonStyle(ActivityLogButtonStyle(activityDescription: "Saved a Diary Note"))
            .font(.custom("Nunito-Bold", size: 17))
            .foregroundColor(.white)
            .background(primaryColor)
            .cornerRadius(15)
            .frame(height: 44.0)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30.0)
            .alert("Please enter a text before you save.", isPresented: $emptyNoteAlert) {
                Button("OK", role: .cancel) { }
            }
    }
    
    var buttonSave: some View {
        Button("Save") {
            if text.isEmpty {
                self.emptyNoteAlert = true
                return
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
            dismiss()
        }
    }
}

struct MoodEditorViewView_Previews: PreviewProvider {
    @State static var currentNote = Note(id: UUID().uuidString, title: "Sample Note", text: "Test", date: Date())
    
    static var previews: some View {
        MoodEditorView(
            currentNote: $currentNote
        )
    }
}
