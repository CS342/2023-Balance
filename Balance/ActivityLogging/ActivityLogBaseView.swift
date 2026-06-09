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

struct ActivityLogBaseView<Content>: View where Content: View {
    @EnvironmentObject var activityLogEntry: ActivityLogEntry
    @EnvironmentObject var logStore: ActivityLogStore
    @State private var isVisible = false
    private let viewName: String
    private let isDirectChildToContainer: Bool
    private let content: Content

    var body: some View {
        content
            .onAppear {
#if DEBUG
                print("[ActivityLogBaseView][onAppear] - View: \(viewName)")
#endif
                isVisible = true
                activityLogEntry.push(viewName: viewName)
            }
            .onDisappear {
#if DEBUG
                print("[ActivityLogBaseView][onDisappear] - View: \(viewName)")
#endif
                isVisible = false
                // On forward nav, push() already finalized this view before onDisappear fires.
                // Only finalize if pendingEntry still matches — i.e. this is a back navigation.
                if activityLogEntry.pendingEntry?.description == viewName {
                    activityLogEntry.finalizePending()
                }
                if isDirectChildToContainer {
                    logStore.saveLog(activityLogEntry)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
#if DEBUG
                print("[ActivityLogBaseView][didBecomeActive] - View: \(viewName), isVisible: \(isVisible)")
#endif
                guard isVisible else { return }
                if activityLogEntry.pendingEntry?.description != viewName {
#if DEBUG
                    print("[ActivityLogBaseView][didBecomeActive] - Re-pushing view: \(viewName)")
#endif
                    activityLogEntry.push(viewName: viewName)
                }
            }
    }

    public init(viewName: String, isDirectChildToContainer: Bool = false, @ViewBuilder content: () -> Content) {
        self.viewName = viewName
        self.isDirectChildToContainer = isDirectChildToContainer
        self.content = content()
    }
}
