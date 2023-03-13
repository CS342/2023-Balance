//
//  ActivityLogBaseView.swift
//  Balance
//
//  Created by Alexis Lowber on 3/10/23.
//

import SwiftUI

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

//This base view implements functionality to log information that will be send to the ActivityStorageManager
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
                //TODO: remove print statement
                print("Opened \(viewName)")
            })
            .onDisappear(perform: {
                activityLogEntry.endLog(actionDescription: "Closed \(viewName)")
                if isDirectChildToContainer {
                    if let (startStr, activityLogEntryString) = activityLogEntry.toString() {
                        ActivityStorageManager.shared.uploadActivity(startID: startStr, activityLogEntryString: activityLogEntryString)
                        //TODO: use logging
                        print("Sending activity log to storage manager: \(activityLogEntryString)")
                    }
                }
                //TODO: remove print statement
                print("Closed \(viewName)")
            })
    }
}
    
