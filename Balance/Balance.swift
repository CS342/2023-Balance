//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// import BalanceOnboardingFlow
import BalanceSharedContext
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
    @StateObject var userModel = AuthViewModel()

    @State var started = false
    
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
        }
    }
}
