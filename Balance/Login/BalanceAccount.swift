//
// This source file is part of the Stanford CardinalKit Balance Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Account
import BalanceSharedContext
import class FHIR.FHIR
import FirebaseAccount
import Onboarding
import SwiftUI

struct BalanceAccount: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @EnvironmentObject var account: Account
    
    var body: some View {
        Group {
            LoginView(onboardingSteps: $onboardingSteps)
                .onReceive(account.objectWillChange) {
                    if account.signedIn {
                        completedOnboardingFlow = true
                    }
                }
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
            .environmentObject(Account(accountServices: []))
            .environmentObject(FirebaseAccountConfiguration<FHIR>(emulatorSettings: (host: "localhost", port: 9099)))
    }
}
#endif
