//
//  ActivityLogBaseView.swift
//  Balance
//
//  Created by Alexis Lowber on 3/10/23.
//

import SwiftUI

// swiftlint:disable lower_acl_than_parent
// swiftlint:disable type_contents_order
// swiftlint:disable todo
struct ActivityLogContainer<Content>: View where Content: View {
    private let content: Content
    @StateObject var activityLogEntry = ActivityLogEntry()
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .environmentObject(activityLogEntry)
    }
}

// This base view implements functionality to log information that will be send to the ActivityStorageManager
struct ActivityLogBaseView<Content>: View where Content: View {
    private let viewName: String
    private let isDirectChildToContainer: Bool
    private let content: Content
    
    @EnvironmentObject var activityLogEntry: ActivityLogEntry
    
    public init(viewName: String, isDirectChildToContainer: Bool = false, @ViewBuilder content: () -> Content) {
        self.viewName = viewName
        self.isDirectChildToContainer = isDirectChildToContainer
        self.content = content()
    }
        
    var body: some View {
        content
            .onAppear(perform: {
                activityLogEntry.addAction(actionDescription: "Opened \(viewName)")
                // TODO: remove print statement
                print("Opened \(viewName)")
            })
            .onDisappear(perform: {
                activityLogEntry.endLog(actionDescription: "Closed \(viewName)")
                
                if isDirectChildToContainer {
                    ActivityStorageManager.shared.uploadActivity(activityLogEntry: activityLogEntry)
                    
                    // for debugging
                    let activityLogEntryString = activityLogEntry.toString()
                    // TODO: remove print statement
                    print("Sending activity log to storage manager: \(activityLogEntryString)")
                }
                
                // TODO: remove print statement
                print("Closed \(viewName)")
            })
    }
}
    
