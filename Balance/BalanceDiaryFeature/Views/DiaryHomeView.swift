//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct DiaryHomeView: View {
    @StateObject var store = NoteStore()
    @State private var showingEditor = false
    @State private var currentNote = Note(id: UUID().uuidString, title: "", text: "", date: Date())
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack {
            HeaderMenu(title: "Diary")
            Spacer()

            Button("Write a Note") {
                self.currentNote = Note(id: UUID().uuidString, title: "", text: "", date: Date())
                self.showingEditor.toggle()
            }.buttonStyle(.borderedProminent)
           
            Spacer()

            Text("Previous Entries")
                .font(.title.bold())

            List {
                ForEach(store.notes, id: \.self) { note in
                    Button(action: {
                        self.currentNote = note
                        self.showingEditor.toggle()
                    }) {
                        PastDiaryEntry(note)
                    }
                    .buttonStyle(ActivityLogButtonStyle(activityDescription: "Selected past diary note"))
                }
                .onDelete(perform: delete)
            }
        }
        .sheet(isPresented: $showingEditor) {
            ActivityLogBaseView(viewName: "Diary Note Entry View") {
                DiaryNoteEntryView(
                    store: store,
                    currentNote: $currentNote,
                    showingEditor: $showingEditor
                )
            }
        }
        .onAppear {
            NoteStore.load { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let notes):
                    store.notes = notes
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                NoteStore.save(notes: store.notes) { result in
                    if case .failure(let error) = result {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }

    func delete(indexSet: IndexSet) {
        // remove the note from the notes array
        store.notes.remove(atOffsets: indexSet)

        // save the updated array to local storage
        // asynchronously
        NoteStore.save(notes: store.notes) { result in
            if case .failure(let error) = result {
                print(error.localizedDescription)
            }
        }
    }
}

struct DiaryHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryHomeView()
    }
}
