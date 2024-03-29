//
//  ContentWebView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 06/04/2023.
//

import SwiftUI

struct GamesWebView: View {
    @StateObject var webViewStore = WebViewStore()
    var gameLink: String
    var titleGame: String
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderMenu(title: titleGame)
            WebView(webView: webViewStore.webView)
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    guard let sudokuLink = URL(string: gameLink) else {
                        return
                    }
                    self.webViewStore.webView.load(URLRequest(url: sudokuLink))
                }
                .background(backgroundColor)
        }
    }
    
    init(gameLink: String, titleGame: String) {
        self.gameLink = gameLink
        self.titleGame = titleGame
    }
    
    func goBack() {
        webViewStore.webView.goBack()
    }
    
    func goForward() {
        webViewStore.webView.goForward()
    }
}

struct SudokuWebView_Previews: PreviewProvider {
    static var previews: some View {
        GamesWebView(gameLink: "https://sudoku.com/", titleGame: "Sudoku")
    }
}
