//
//  SwiftUIView.swift
//  
//
//  Created by Griffin Somaratne on 2/22/23.
//

import SwiftUI
    
struct DiaryHomeView: View {
    @StateObject var vm = DiaryFeatureViewModel()
    @State private var showingEditor = false

    var body: some View {
        VStack {
            HeaderMenu()

            Spacer()

            Button("Write a Note") {
                self.showingEditor.toggle()
            }.buttonStyle(.borderedProminent)

            Spacer()

            Text("Previous Entries")
                .font(.title.bold())

            List($vm.notes, id: \.self, editActions: .delete) { $note in
                PastDiaryEntry(note)
            }
        }   .sheet(isPresented: $showingEditor) {
                DiaryNoteEntryView(
                    vm: vm,
                    showingEditor: self.$showingEditor
                )
            .task {
                await vm.readFromStorage()
            }
        }
    }
}

struct DiaryHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryHomeView()
    }
}
