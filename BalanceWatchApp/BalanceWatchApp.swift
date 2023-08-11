//
//  BalanceWatchApp.swift
//  BalanceWatch Watch App
//
//  Created by Gonzalo Perisset on 09/08/2023.
//

import SwiftUI

@main
struct BalanceWatchApp: App {
    @StateObject private var workoutManager = WorkoutManager()
    @StateObject var counter = Counter()

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environmentObject(workoutManager)
            .environmentObject(counter)
        }
    }
}
