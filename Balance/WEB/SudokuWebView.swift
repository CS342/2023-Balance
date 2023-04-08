//
//  ContentWebView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 06/04/2023.
//

import SwiftUI

struct SudokuWebView: View {
    @StateObject var webViewStore = WebViewStore()
    
    var body: some View {
        HeaderMenu(title: "Sudoku")
        WebView(webView: webViewStore.webView)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                guard let sudokuLink = URL(string: "https://sudoku.com/") else {
                    return
                }
                self.webViewStore.webView.load(URLRequest(url: sudokuLink))
            }
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
        SudokuWebView()
    }
}
