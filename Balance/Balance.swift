//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import BalanceOnboardingFlow
import BalanceSharedContext
import CardinalKit
import SwiftUI

@main
struct Balance: App {
    @UIApplicationDelegateAdaptor(BalanceAppDelegate.self) var appDelegate
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    
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
        }
    }
}
