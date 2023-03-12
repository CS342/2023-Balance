//
//  ActivityLogButtonWrapper.swift
//  Balance
//
//  Created by Alexis Lowber on 3/11/23.
//

import SwiftUI
import UIKit

// This class only logs information when the user interacts with a button (or some selectable content). We don't care when the view appers or disappears.

struct ActivityLogButtonWrapper<Content>: View where Content: View{
    
    @EnvironmentObject var activityLogEntry: ActivityLogEntry
    
    private let content: Content
    
    var activityDescription: String
    
    public init(activityDescription: String, @ViewBuilder content: () -> Content) {
        self.activityDescription = activityDescription
        self.content = content()
    }
    
    var body: some View {
        content
            .onTapGesture {
                activityLogEntry.addAction(actionDescription: activityDescription)
                //TODO: remove print when not debugging
                print(activityDescription)
            }
    }
    
    mutating func setActivityDescription(activityDescription: String) {
        self.activityDescription = activityDescription
    }
}
