//
//  ContentView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/04/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authModel: AuthViewModel

    var body: some View {
        Group {
            if authModel.user != nil {
                MainView()
            } else {
              //  LoginView()
            }
        }.onAppear {
            authModel.listenAuthentificationState()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
