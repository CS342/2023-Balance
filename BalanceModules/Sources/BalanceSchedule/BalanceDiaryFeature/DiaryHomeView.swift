//
//  SwiftUIView.swift
//  
//
//  Created by Griffin Somaratne on 2/22/23.
//

import SwiftUI
    
struct DiaryHomeView: View {
    var body: some View {
        VStack {
            HeaderMenu()
                .offset(y: -150)
            Text("Previous Entries")
                .font(.title.bold())
            PastDiaryEntry(
                date: String( "Date"),
                title: String("Note Name"),
                text: String("Note body text")
            )
            PastDiaryEntry(
                date: String( "Date"),
                title: String("Note Name"),
                text: String("Note body text")
            )
            PastDiaryEntry(
                date: String( "Date"),
                title: String("Note Name"),
                text: String("Note body text")
            )
        }
    }
}

struct DiaryHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryHomeView()
    }
}
