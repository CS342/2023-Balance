//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI

@main
struct Balance: App {
    @UIApplicationDelegateAdaptor(BalanceAppDelegate.self)
    var appDelegate
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @StateObject var noteStore = NoteStore()
    @StateObject var drawStore = DrawStore()
    @StateObject var coloringStore = ColoringStore()
    @StateObject var userModel = AuthViewModel.shared
#if DEMO
    @StateObject var logStore = ActivityLogStore()
#endif
    @StateObject var activityLogEntry = ActivityLogEntry()
    
    @Environment(\.scenePhase)
    var scenePhase
    
    var body: some Scene {
        WindowGroup {
            Group {
                if completedOnboardingFlow {
                    HomeView()
                } else {
                    OnboardingFlow()
                }
            }
            .testingSetup()
            .cardinalKit(appDelegate)
            .environmentObject(noteStore)
            .environmentObject(drawStore)
            .environmentObject(coloringStore)
            .environmentObject(userModel)
#if DEMO
            .environmentObject(logStore)
#endif
            .environmentObject(activityLogEntry)

            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    print("ScenePhase: active")
                    UserDefaults.standard.set(false, forKey: StorageKeys.spotifyConnect)
                case .background:
                    print("ScenePhase: background")
                    let value = UserDefaults.standard.bool(forKey: StorageKeys.spotifyConnect)
                    if value == false {
                        activityLogEntry.reset()
                    }
                case .inactive:
                    print("ScenePhase: inactive")
                @unknown default:
                    print("ScenePhase: unexpected state")
                }
            }
        }
    }
}
