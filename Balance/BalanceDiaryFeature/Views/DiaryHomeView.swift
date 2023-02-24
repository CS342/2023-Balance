//
//  SwiftUIView.swift
//  
//
//  Created by Griffin Somaratne on 2/22/23.
//

import SwiftUI
    
struct DiaryHomeView: View {
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

            ScrollView {
                PastDiaryEntry(
                    date: String( "Date"),
                    title: String("Note Name"),
                    text: String("Note body text")
                )
            }
        }.sheet(isPresented: $showingEditor) {
            DiaryNoteEntryView()
        }
    }
}

struct DiaryHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryHomeView()
    }
}
