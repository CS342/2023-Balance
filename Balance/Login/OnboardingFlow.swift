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
        case avatar
    }
    
    @SceneStorage(StorageKeys.onboardingFlowStep) private var onboardingSteps: [Step] = []

    public var body: some View {
        NavigationStack(path: $onboardingSteps) {
            BalanceAccount(onboardingSteps: $onboardingSteps)
                .navigationDestination(for: Step.self) { onboardingStep in
                    switch onboardingStep {
                    case .login:
                        LoginView().environmentObject(AuthViewModel())
                    case .signUp:
                        SignInView(onboardingSteps: $onboardingSteps)
                    case .avatar:
                        AvatarSelectionView(firstLoad: true)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct OnboardingFlow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFlow()
    }
}
