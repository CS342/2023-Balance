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
    let fcolor = Color(red: 0.25, green: 0.38, blue: 0.50, opacity: 1.00)
    let bcolor = Color(red: 0.30, green: 0.79, blue: 0.94, opacity: 1.00)
    
    var body: some View {
        ZStack {
            backgroudColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Diary")
                VStack(alignment: .center, spacing: 10) {
                    newDiaryView
                    previusView
                    diaryList
                }
                .sheet(isPresented: $showingEditor) {
                    ActivityLogBaseView(viewName: "Diary Note Entry View") {
                        diaryNoteView
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
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    var diaryNoteView: some View {
        DiaryNoteEntryView(
            store: store,
            currentNote: $currentNote,
            showingEditor: $showingEditor
        )
    }
    
    var previusView: some View {
        Text("Previous Entries")
            .font(.custom("Nunito-Bold", size: 18))
            .foregroundColor(fcolor)
            .offset(x: -100)
    }
    
    var newDiaryView: some View {
        HStack {
            Image("DiaryIcon")
                .accessibilityLabel(Text("Diary icon"))
                .offset(x: -6, y: 2)
            VStack(alignment: .leading) {
                Text("Write in your diary")
                    .font(.custom("Nunito-Bold", size: 15))
                Button("Write") {
                    self.currentNote = Note(id: UUID().uuidString, title: "", text: "", date: Date())
                    self.showingEditor.toggle()
                }
                .buttonStyle(ActivityLogButtonStyle(activityDescription: "Opened a New Diary Note"))
                .font(.custom("Nunito-Bold", size: 15))
                .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
                .foregroundColor(.white)
                .background(bcolor)
                .cornerRadius(14)
            }
        }
        .frame(maxWidth: 349, maxHeight: 112, alignment: .leading)
        .foregroundColor(fcolor)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .clipped()
        .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
    }
    
    var diaryList: some View {
        List {
            ForEach(store.notes, id: \.self) { note in
                Button(action: {
                    self.currentNote = note
                    self.showingEditor.toggle()
                }) {
                    PastDiaryEntry(note)
                }
                .buttonStyle(ActivityLogButtonStyle(activityDescription: "Selected past diary note"))
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: delete)
        }
        .listStyle(.plain)
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

#if DEBUG
struct DiaryHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryHomeView()
    }
}
#endif
