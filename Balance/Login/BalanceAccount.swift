//
// This source file is part of the Stanford CardinalKit Balance Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Onboarding
import SwiftUI

struct BalanceAccount: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    
    var body: some View {
        Group {
#if DEMO
            LoginViewLocal(onboardingSteps: $onboardingSteps)
#else
            LoginView(onboardingSteps: $onboardingSteps)
                .onReceive(account.objectWillChange) {
                    if account.signedIn {
                        completedOnboardingFlow = true
                    }
                }
#endif
        }
        .background(backgroundColor)
    }
    
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}


#if DEBUG
struct AccountSetup_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    
    static var previews: some View {
        BalanceAccount(onboardingSteps: $path)
    }
}
#endif
