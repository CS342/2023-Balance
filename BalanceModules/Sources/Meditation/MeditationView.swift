//
//  SwiftUIView.swift
//  
//
//  Created by Alexis Lowber on 2/14/23.
//

/*
 might want to check out NavigationSplit view if you want a two-column presentation w meditation options and views. See here: https://developer.apple.com/videos/play/wwdc2022/10054/
 */


import SwiftUI

public struct MeditationView: View {
    @Binding var navigationPath: NavigationPath
    
    public var body: some View {
        Text("Welcome to the Meditation View")
    }
    
    public init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MeditationView(navigationPath: .constant(NavigationPath()))
        }
    }
}
