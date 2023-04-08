//
//  GamesView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 08/04/2023.
//

import SwiftUI

struct GamesView: View {
    var body: some View {
        ActivityLogContainer {
            HeaderMenu(title: "Games")
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    sudokuGame
                    crossoverGame
                    notesGame
                }
                .padding(10)
                .ignoresSafeArea(.all)
            }
        }
    }
    
    var notesGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Random Notes Games",
                isDirectChildToContainer: true,
                content: {
                    // define action
                }
            )
        ) {
            GamesCellView(image: "writesIcon", text: "Random Notes")
        }
    }
    
    var crossoverGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Crossover Game",
                isDirectChildToContainer: true,
                content: {
                    
                }
            )
        ) {
            GamesCellView(image: "musicIcon", text: "Crossover")
        }
    }
    
    var sudokuGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Sudoko Game",
                isDirectChildToContainer: true,
                content: {
                    SudokuWebView()
                }
            )
        ) {
            GamesCellView(image: "sudokuIcon", text: "Sudoko")
        }
    }
}

#if DEBUG
struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}
#endif
