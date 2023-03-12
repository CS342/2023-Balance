//
//  ActivityLogBaseView.swift
//  Balance
//
//  Created by Alexis Lowber on 3/10/23.
//

import SwiftUI


//This base view implements functionality to log information that will be send to the ActivityStorageManager
struct ActivityLogBaseView<Content>: View where Content: View {
    
    private let viewName: String
    private let content: Content
    
    var activityLogEntry: ActivityLogEntry
    
    public init(viewName: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.viewName = viewName
        self.activityLogEntry = ActivityLogEntry()
    }
        
    var body: some View {
        content
            .onAppear(perform: {
                activityLogEntry.reset()
                activityLogEntry.addAction(actionDescription: "Opened \(viewName)")
                //TODO: remove print statement
                print("Opened\(viewName): starting log")
            })
            .onDisappear(perform: {
                activityLogEntry.endLog(actionDescription: "Closed \(viewName)")
                if let (startStr, activityLogEntryString) = activityLogEntry.toString() {
                    ActivityStorageManager.shared.uploadActivity(startID: startStr, activityLogEntryString: activityLogEntryString)
                }
                //TODO: remove print statement
                print("view disappeared, ending/sending log")
            })
    }
}
