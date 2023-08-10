//
//  BalanceWatchApp.swift
//  BalanceWatch Watch App
//
//  Created by Gonzalo Perisset on 09/08/2023.
//

import SwiftUI

@main
struct BalanceWatch_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private let workoutManager = WorkoutManager.shared
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            PagingView()
                .environmentObject(workoutManager)
        }
    }
}
