//
//  DrawHomeView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/04/2023.
//

import SwiftUI

struct DrawHomeView: View {
    @StateObject var store = DrawStore()
    @State private var showingEditor = false
    @State private var currentDraw = Draw(id: UUID().uuidString, title: "", image: "", date: Date())

    @Environment(\.scenePhase) private var scenePhase
    let fcolor = Color(red: 0.25, green: 0.38, blue: 0.50, opacity: 1.00)
    let bcolor = Color(red: 0.30, green: 0.79, blue: 0.94, opacity: 1.00)
    
    var body: some View {
        ZStack {
            backgroudColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Drawing Something")
                VStack(alignment: .center, spacing: 10) {
                    newDiaryView
                    previusView
                    drawList
                }
                .sheet(isPresented: $showingEditor) {
                    ActivityLogBaseView(viewName: "New draw view") {
                        drawView
                    }
                }
                .onAppear {
                    DrawStore.load { result in
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let draws):
                            store.draws = draws
                        }
                    }
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive {
                        DrawStore.save(draws: store.draws) { result in
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
    
    var drawView: some View {
        DrawView(
            store: store,
            currentDraw: $currentDraw,
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
            Image("drawingIcon")
                .accessibilityLabel(Text("Draw icon"))
                .offset(x: -6, y: 2)
            VStack(alignment: .leading) {
                Text("Draw something new...")
                    .font(.custom("Nunito-Bold", size: 15))
                Button("New Draw") {
                    self.currentDraw = Draw(id: UUID().uuidString, title: "", image: "", date: Date())
                    self.showingEditor.toggle()
                }
                .buttonStyle(ActivityLogButtonStyle(activityDescription: "Opened a New Draw"))
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
    
    var drawList: some View {
        List {
            ForEach(store.draws, id: \.self) { draw in
                Button(action: {
                    self.currentDraw = draw
                    self.showingEditor.toggle()
                }) {
                    PastDrawEntry(draw)
                }
                .buttonStyle(ActivityLogButtonStyle(activityDescription: "Selected past draw"))
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: delete)
        }
        .listStyle(.plain)
    }
    
    func delete(indexSet: IndexSet) {
        // remove the note from the notes array
        store.draws.remove(atOffsets: indexSet)
        
        // save the updated array to local storage
        // asynchronously
        DrawStore.save(draws: store.draws) { result in
            if case .failure(let error) = result {
                print(error.localizedDescription)
            }
        }
    }
}

#if DEBUG
struct DrawHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DrawHomeView()
    }
}
#endif
