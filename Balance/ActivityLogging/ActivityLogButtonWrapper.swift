//
//  ActivityLogButtonWrapper.swift
//  Balance
//
//  Created by Alexis Lowber on 3/11/23.
//

import SwiftUI

struct ActivityLogButtonWrapper<Content>: View where Content: View{
    
    private let content: Content
    
    var activityDescription: String?
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .onTapGesture {
            }
    }
}
