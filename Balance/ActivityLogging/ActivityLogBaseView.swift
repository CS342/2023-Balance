//
//  ActivityLogBaseView.swift
//  Balance
//
//  Created by Alexis Lowber on 3/10/23.
//

import SwiftUI


//This base view implements functionality to log information that will be send to the ActivityStorageManager
struct ActivityLogBaseView<Content>: View where Content: View {
    
    public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        
        
    private let content: Content
    var body: some View {
        content
    }
}

struct ActivityLogBaseView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityLogBaseView()
    }
}
