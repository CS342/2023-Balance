//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import BalanceSharedContext
import SwiftUI


/// Displays an multi-step onboarding flow for the CS342 2023 Balance Team Application.
public struct OnboardingFlow: View {
    enum Step: String, Codable {
        case login
        case signUp
    }
    
    
    @SceneStorage(StorageKeys.onboardingFlowStep)
    private var onboardingSteps: [Step] = []
    
    
    public var body: some View {
        NavigationStack(path: $onboardingSteps) {
            AccountSetup(onboardingSteps: $onboardingSteps)
                .navigationDestination(for: Step.self) { onboardingStep in
                    switch onboardingStep {
                    case .login:
                        BalanceLogin()
                    case .signUp:
                        BalanceSignUp()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    public init() {}
}


struct OnboardingFlow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFlow()
    }
}
