//
//  DrawHomeView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/04/2023.
//

import SwiftUI

struct DrawHomeView: View {
    @EnvironmentObject var store: DrawStore
    @State private var currentDraw = Draw()
    @Environment(\.scenePhase)
    private var scenePhase
    @State private var isShowingSecondView = false
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Drawing Something")
                VStack(alignment: .center, spacing: 10) {
                    newDrawView
                    previusView
                    drawList
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
        DrawView(currentDraw: $currentDraw)
    }
    
    var previusView: some View {
        Text("Previous Entries")
            .font(.custom("Nunito-Bold", size: 18))
            .foregroundColor(darkBlueColor)
            .offset(x: -100)
    }
    
    var newDrawView: some View {
        HStack {
            Image("writesIcon")
                .accessibility(hidden: true)
                .frame(width: 110, height: 110, alignment: .center)
            VStack {
                Text("Draw something new...")
                    .font(.custom("Nunito-Bold", size: 15))
                NavigationLink(
                    destination: ActivityLogBaseView(
                        viewName: "New Draw Feature",
                        isDirectChildToContainer: true,
                        content: {
                            DrawView(currentDraw: $currentDraw)
                        }
                    )
                ) {
                    Text("New Draw")
                        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Opened a New Draw"))
                        .font(.custom("Montserrat-SemiBold", size: 17))
                        .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
                        .foregroundColor(.white)
                        .background(primaryColor)
                        .cornerRadius(14)
                        .allowsHitTesting(false)
                }.simultaneousGesture(TapGesture().onEnded {
                    self.currentDraw = Draw()
                })
            }
        }
        .frame(maxWidth: 350, maxHeight: 110, alignment: .leading)
        .foregroundColor(darkBlueColor)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .clipped()
        .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
    }
    
    var drawList: some View {
        List {
            ForEach(store.draws, id: \.self) { draw in
                ZStack {
                    Button(action: {
                        self.currentDraw = draw
                    }) {
                        PastEntryView(draw)
                    }
                    
                    NavigationLink(
                        destination: ActivityLogBaseView(
                            viewName: "Draw Saved Feature",
                            isDirectChildToContainer: true,
                            content: {
                                DrawView(currentDraw: $currentDraw)
                            }
                        )
                    ) {
                        EmptyView()
                    }.opacity(0.0)
                }
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: delete)
        }
        .listStyle(.plain)
    }
    
    var drawCell: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Draw Something Feature",
                isDirectChildToContainer: true,
                content: {
                    DrawView(currentDraw: $currentDraw)
                }
            )
        ) {
            EmptyView()
        }
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
