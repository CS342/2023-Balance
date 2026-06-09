//
//  ActivityLogBaseView.swift
//  Balance
//
//  Created by Alexis Lowber on 3/10/23.
//

import SwiftUI

// swiftlint:disable lower_acl_than_parent
struct ActivityLogContainer<Content>: View where Content: View {
    @EnvironmentObject var activityLogEntry: ActivityLogEntry
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
    @State private var isVisible = false
    private let viewName: String
    private let isDirectChildToContainer: Bool
    private let content: Content

    var body: some View {
        content
            .onAppear(perform: {
#if DEBUG
                print("[ActivityLogBaseView][onAppear] - View: \(viewName)")
#endif
                isVisible = true
                activityLogEntry.addAction(actionDescription: "Opened \(viewName)")
            })
            .onDisappear(perform: {
#if DEBUG
                print("[ActivityLogBaseView][onDisappear] - View: \(viewName)")
#endif
                isVisible = false
                activityLogEntry.endLog(actionDescription: "Closed \(viewName)")

                if isDirectChildToContainer {
                    logStore.saveLog(activityLogEntry)
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
#if DEBUG
                    print("[ActivityLogBaseView][didBecomeActive]: \(viewName)")
#endif
                guard isVisible else { return }
                let alreadyLogged = activityLogEntry.actions.contains { $0.description == "Opened \(viewName)" }
                if !alreadyLogged {
#if DEBUG
                    print("[ActivityLogBaseView][didBecomeActive] - View is Visible and wasn't logged yet. Readding view: \(viewName)")
#endif
                    activityLogEntry.addAction(actionDescription: "Opened \(viewName)")
                }
            }
    }

    public init(viewName: String, isDirectChildToContainer: Bool = false, @ViewBuilder content: () -> Content) {
        self.viewName = viewName
        self.isDirectChildToContainer = isDirectChildToContainer
        self.content = content()
    }
}
