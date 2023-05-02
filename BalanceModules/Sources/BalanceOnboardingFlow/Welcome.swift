//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Onboarding
import SwiftUI


struct Welcome: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    
    
    var body: some View {
        OnboardingView(
            title: "WELCOME_TITLE".moduleLocalized,
            subtitle: "".moduleLocalized,
            areas: [
            ],
            actionText: "WELCOME_BUTTON".moduleLocalized,
            action: {
                onboardingSteps.append(.login)
            }
        )
    }
    
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}


struct Welcome_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []

    static var previews: some View {
        Welcome(onboardingSteps: $path)
    }
}
