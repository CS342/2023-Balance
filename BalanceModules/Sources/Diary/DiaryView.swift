//
//  SwiftUIView.swift
//  
//
//  Created by Alexis Lowber on 2/14/23.
//

import SwiftUI

public struct DiaryView: View {
    @Binding var navigationPath: NavigationPath
    
    public var body: some View {
        Text("Welcome to the Diary View")
    }
    
    public init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiaryView(navigationPath: .constant(NavigationPath()))
        }
    }
    
}
