//
//  ActivityLogButtonWrapper.swift
//  Balance
//
//  Created by Alexis Lowber on 3/11/23.
//

import SwiftUI

struct ActivityLogButtonWrapper<Content>: View where Content: View{
    
    @EnvironmentObject var activityLogEntry: ActivityLogEntry
    
    private let content: Content
    
    var activityDescription: String
    
    public init(activityDescription: String, @ViewBuilder content: () -> Content, activityLogEntry: Binding<ActivityLogEntry>) {
        self.activityDescription = activityDescription
        self.content = content()
    }
    
    var body: some View {
        content
            .onTapGesture {
                activityLogEntry.addAction(actionDescription: activityDescription)
            }
    }
    
    mutating func setActivityDescription(activityDescription: String) {
        self.activityDescription = activityDescription
    }
}
