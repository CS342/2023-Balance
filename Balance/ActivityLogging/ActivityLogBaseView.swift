//
//  ActivityLogBaseView.swift
//  Balance
//
//  Created by Alexis Lowber on 3/10/23.
//

import SwiftUI


//This base view implements functionality to log information that will be send to the ActivityStorageManager
struct ActivityLogBaseView<Content>: View where Content: View {
    var activityLogEntry: ActivityLogEntry
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.activityLogEntry = ActivityLogEntry()
    }
        
    var body: some View {
        content
            .onAppear(perform: {
                activityLogEntry.restart()
                print("view appeared: starting log")
            })
            .onDisappear(perform: {
                activityLogEntry.endLog()
                let (startStr, activityLogEntryString) = activityLogEntry.toString()
                ActivityStorageManager.shared.uploadActivity(filename: startStr, activityLogEntryString: activityLogEntryString)
                print("view disappeared, ending/sending log")
            })
    }
}
