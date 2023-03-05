//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import BalanceSharedContext
import SwiftUI


private struct BalanceTestingSetup: ViewModifier {
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    
    
    func body(content: Content) -> some View {
        content
            .task {
                if CommandLine.arguments.contains("--skipOnboarding") {
                    completedOnboardingFlow = true
                }
                if CommandLine.arguments.contains("--showOnboarding") {
                    completedOnboardingFlow = false
                }
            }
    }
}


extension View {
    func testingSetup() -> some View {
        self.modifier(BalanceTestingSetup())
    }
}
