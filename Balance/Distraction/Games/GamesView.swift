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
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Games")
                    ScrollView(.vertical) {
                        VStack(spacing: 20) {
                            sudokuGame
                            crossoverGame
                        }
                        .padding(10)
                        .ignoresSafeArea(.all)
                    }
                }
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
            GamesCellView(image: "notesIcon", text: "Random Notes")
        }
    }
    
    var crossoverGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Crossover Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://www.bestcrosswords.com/bestcrosswords/guestconstructor/GuestConstructorPuzzle.external?sp=S252535", titleGame: "Crossover")
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
                    GamesWebView(gameLink: "https://sudoku.com/", titleGame: "Sudoku")
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
