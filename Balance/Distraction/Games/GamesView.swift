//
//  GamesView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 08/04/2023.
//

import SwiftUI

struct GamesView: View {
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Games")
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        sudokuGame
                        crossoverGame
                        solitaireGame
                        mahjongGame
                        twocerofoureightGame
                        bouncingGame
                        dailyWordGame
                        simonGame
                        colorsGame
                        bejeweledGame
                        tetrisGame
                    }
                    .padding(10)
                    .ignoresSafeArea(.all)
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

    var bejeweledGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Bejeweled Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://www.bubbleshooter.net/game/bejeweled/", titleGame: "Bejeweled")
                }
            )
        ) {
            GamesCellView(image: "bejeweledIcon", text: "Bejeweled")
        }
    }
    
    var tetrisGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Tetris Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://www.lumpty.com/amusements/Games/Tetris/tetris.html", titleGame: "Tetris")
                }
            )
        ) {
            GamesCellView(image: "tetrisIcon", text: "Tetris")
        }
    }
    
    var colorsGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "4Colors Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://freegames.org/4-colors/", titleGame: "4 Colors")
                }
            )
        ) {
            GamesCellView(image: "colorsIcon", text: "4 Colors")
        }
    }
    
    var simonGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Simon Says Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://freegames.org/simon-says/", titleGame: "Simon Says")
                }
            )
        ) {
            GamesCellView(image: "simonIcon", text: "Simon Says")
        }
    }
    
    var dailyWordGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Daily Word Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://freegames.org/daily-word-search/", titleGame: "Daily Word")
                }
            )
        ) {
            GamesCellView(image: "wordIcon", text: "Daily Word")
        }
    }
    
    var bouncingGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Bouncing Ball Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://freegames.org/bouncing-balls/", titleGame: "Bouncing Ball")
                }
            )
        ) {
            GamesCellView(image: "bouncingIcon", text: "Bouncing")
        }
    }
    
    var twocerofoureightGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "2048 Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://play2048.co/", titleGame: "2048")
                }
            )
        ) {
            GamesCellView(image: "2048Icon", text: "2048")
        }
    }
    
    var mahjongGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Mahjong Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://freegames.org/mahjong/", titleGame: "Mahjong")
                }
            )
        ) {
            GamesCellView(image: "mahjongIcon", text: "Mahjong")
        }
    }
    
    var solitaireGame: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Solitaire Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://freegames.org/solitaire/", titleGame: "Solitaire")
                }
            )
        ) {
            GamesCellView(image: "solitarioIcon", text: "Solitaire")
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
                viewName: "Sudoku Game",
                isDirectChildToContainer: true,
                content: {
                    GamesWebView(gameLink: "https://sudoku.com/", titleGame: "Sudoku")
                }
            )
        ) {
            GamesCellView(image: "sudokuIcon", text: "Sudoku")
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
