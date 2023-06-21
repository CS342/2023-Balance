//
//  ActivityLogBaseView.swift
//  Balance
//
//  Created by Alexis Lowber on 3/10/23.
//

import SwiftUI

// swiftlint:disable lower_acl_than_parent
struct ActivityLogContainer<Content>: View where Content: View {
    @StateObject var activityLogEntry = ActivityLogEntry()
    private let content: Content
    
    var body: some View {
        content.environmentObject(activityLogEntry)
    }
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

// This base view implements functionality to log information that will be send to the ActivityStorageManager
struct ActivityLogBaseView<Content>: View where Content: View {
    @EnvironmentObject var activityLogEntry: ActivityLogEntry
    @EnvironmentObject var logStore: ActivityLogStore
    private let viewName: String
    private let isDirectChildToContainer: Bool
    private let content: Content
    
    var body: some View {
        content
            .onAppear(perform: {
                activityLogEntry.addAction(actionDescription: "Opened \(viewName)")
#if DEBUG
                print("Opened \(viewName)")
#endif
            })
            .onDisappear(perform: {
                activityLogEntry.endLog(actionDescription: "Closed \(viewName)")
                
                if isDirectChildToContainer {
#if DEMO
                    let log = ActivityLogLocal()
                    log.actions = activityLogEntry.actions
                    log.duration = activityLogEntry.duration
                    log.endTime = activityLogEntry.endTime
                    log.startTime = activityLogEntry.startTime

                    logStore.saveLog(log)
                    ActivityLogStore.save(logs: logStore.logs) { result in
                        if case .failure(let error) = result {
                            print(error.localizedDescription)
                        }
                    }
#else
                    ActivityStorageManager.shared.uploadActivity(activityLogEntry: activityLogEntry)
#endif
                    // for debugging
                    let activityLogEntryString = activityLogEntry.toString()
#if DEBUG
                    print("Sending activity log to storage manager: \(activityLogEntryString)")
#endif
                }
                
#if DEBUG
                print("Closed \(viewName)")
#endif
            })
    }
    
    public init(viewName: String, isDirectChildToContainer: Bool = false, @ViewBuilder content: () -> Content) {
        self.viewName = viewName
        self.isDirectChildToContainer = isDirectChildToContainer
        self.content = content()
    }
}
